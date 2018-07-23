include OpenSSLCookbook::Helpers

property :path,        String, name_property: true
property :key_curve,   equal_to: %w(secp384r1 secp521r1 prime256v1 secp224r1 secp256k1), default: 'prime256v1'
property :key_pass,    String
property :key_cipher,  String, default: 'des3', equal_to: OpenSSL::Cipher.ciphers
property :owner,       String, default: node['platform'] == 'windows' ? 'Administrator' : 'root'
property :group,       String, default: node['root_group']
property :mode,        [Integer, String], default: '0640'
property :force,       [true, false], default: false

default_action :create

action :create do
  unless new_resource.force || priv_key_file_valid?(new_resource.path, new_resource.key_pass)
    converge_by("Create an EC private key #{new_resource.path}") do
      log "Generating an #{new_resource.key_curve} "\
          "EC key file at #{new_resource.name}, this may take some time"

      if new_resource.key_pass
        unencrypted_ec_key = gen_ec_priv_key(new_resource.key_curve)
        ec_key_content = encrypt_ec_key(unencrypted_ec_key, new_resource.key_pass, new_resource.key_cipher)
      else
        ec_key_content = gen_ec_priv_key(new_resource.key_curve).to_pem
      end

      file new_resource.path do
        action :create
        owner new_resource.owner
        group new_resource.group
        mode new_resource.mode
        sensitive true
        content ec_key_content
      end
    end
  end
end
