include OpenSSLCookbook::Helpers

property :path,              String, name_property: true
property :serial_to_revoke,  [Integer, String]
property :revocation_reason, Integer, default: 0
property :expire,            Integer, default: 8
property :renewal_threshold, Integer, default: 1
property :ca_cert_file,      String, required: true
property :ca_key_file,       String, required: true
property :ca_key_pass,       String
property :owner,             String, default: 'root'
property :group,             String, default: 'root'
property :mode,              String, default: '0644'

action :create do
  file new_resource.path do
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    content crl.to_pem
    action :create
  end
end

action_class do
  def crl_info
    # Will contain issuer & expiration
    crl_info = {}

    crl_info['issuer'] = OpenSSL::X509::Certificate.new ::File.read(new_resource.ca_cert_file)
    crl_info['validity'] = new_resource.expire

    crl_info
  end

  def revoke_info
    # Will contain Serial to revoke & reason
    revoke_info = {}

    revoke_info['serial'] = new_resource.serial_to_revoke
    revoke_info['reason'] = new_resource.revocation_reason

    revoke_info
  end

  def ca_private_key
    ca_private_key = OpenSSL::PKey.read ::File.read(new_resource.ca_key_file), new_resource.ca_key_pass
    ca_private_key
  end

  def crl
    if crl_file_valid?(new_resource.path)
      crl = OpenSSL::X509::CRL.new ::File.read(new_resource.path)
    else
      log "Creating a CRL #{new_resource.path} for CA #{new_resource.ca_cert_file}"
      crl = gen_x509_crl(ca_private_key, crl_info)
    end

    if !new_resource.serial_to_revoke.nil? && serial_revoked?(crl, new_resource.serial_to_revoke) == false
      log "Revoking serial #{new_resource.serial_to_revoke} in CRL #{new_resource.path}"
      crl = revoke_x509_crl(revoke_info, crl, ca_private_key, crl_info)
    elsif crl.next_update <= Time.now + 3600 * 24 * new_resource.renewal_threshold
      log "Renewing CRL for CA #{new_resource.ca_cert_file}"
      crl = renew_x509_crl(crl, ca_private_key, crl_info)
    end

    crl
  end
end
