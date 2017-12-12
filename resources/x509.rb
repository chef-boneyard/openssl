include OpenSSLCookbook::Helpers

property :path,                String, name_property: true
property :owner,               String, default: 'root'
property :group,               String, default: node['root_group']
property :expire,              Integer
property :mode,                [Integer, String], default: '0644'
property :org,                 String, required: true
property :org_unit,            String, required: true
property :country,             String, required: true
property :state,               String
property :city,                String
property :common_name,         String, required: true
property :subject_alt_name,    Array, default: []
property :private_key_content, String
property :private_key_path,    String
property :private_key_pass,    String
property :key_length,          equal_to: [1024, 2048, 4096, 8192], default: 2048

alias_method :key_file, :private_key_path # key_file was too ambiguous
alias_method :key_pass, :private_key_pass # key_pass was too ambiguous

def after_created
  raise ArgumentError, "You cannot specify both 'private_key_content' and 'private_key_path' properties at the same time." if private_key_content && private_key_path
  raise ArgumentError, "You must specify the private key with either 'private_key_content' or 'private_key_path' properties. The openssl_rsa_private_key resource may be used to generate this key in your cookbook." unless private_key_content || private_key_path
end

action :create do
  unless ::File.exist? new_resource.path
    converge_by("Create #{new_resource.path}") do
      create_keys
      cert_content = cert.to_pem

      file new_resource.path do
        action :create_if_missing
        mode new_resource.mode
        owner new_resource.owner
        group new_resource.group
        sensitive true
        content cert_content
      end
    end
  end
end

action_class do
  def key
    @key ||= if priv_key_file_valid?((new_resource.private_key_path || new_resource.private_key_content), new_resource.key_pass) # rubocop: disable Style/GuardClause
               OpenSSL::PKey::RSA.new (new_resource.private_key_content || ::File.read(new_resource.private_key_path)), new_resource.key_pass
             else
               raise 'The provided private key is not valid or the provided key_pass was not correct!'
             end
    @key
  end

  def cert
    @cert ||= OpenSSL::X509::Certificate.new
  end

  def gen_cert
    cert
    cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
    cert.not_before = Time.now
    cert.not_after = Time.now + (new_resource.expire.to_i * 24 * 60 * 60)
    cert.public_key = key.public_key
    cert.serial = 0x0
    cert.version = 2
  end

  def subject
    @subject ||= '/C=' + new_resource.country +
                 '/ST=' + (new_resource.state ? new_resource.state : ' ') +
                 '/L=' + (new_resource.city ? new_resource.city : ' ') +
                 '/O=' + new_resource.org +
                 '/OU=' + new_resource.org_unit +
                 '/CN=' + new_resource.common_name
  end

  def extensions
    exts = []
    exts << @ef.create_extension('basicConstraints', 'CA:TRUE', true)
    exts << @ef.create_extension('subjectKeyIdentifier', 'hash')

    unless new_resource.subject_alt_name.empty?
      san = {}
      counters = {}
      new_resource.subject_alt_name.each do |an|
        kind, value = an.split(':', 2)
        counters[kind] ||= 0
        counters[kind] += 1
        san["#{kind}.#{counters[kind]}"] = value
      end
      @ef.config['alt_names'] = san
      exts << @ef.create_extension('subjectAltName', '@alt_names')
    end

    exts
  end

  def create_keys
    gen_cert
    @ef ||= OpenSSL::X509::ExtensionFactory.new
    @ef.subject_certificate = cert
    @ef.issuer_certificate = cert
    @ef.config = OpenSSL::Config.load(OpenSSL::Config::DEFAULT_CONFIG_FILE)

    cert.extensions = extensions
    cert.add_extension @ef.create_extension('authorityKeyIdentifier',
                                           'keyid:always,issuer:always')
    cert.sign key, OpenSSL::Digest::SHA256.new
  end
end
