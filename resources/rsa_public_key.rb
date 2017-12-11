include OpenSSLCookbook::Helpers

property :path,             String, name_property: true
property :type,             equal_to: %w(pkcs openssh), default: 'pkcs'
property :private_key_path, String, required: true
property :private_key_pass, String
property :owner,            String, default: 'root'
property :group,            String, default: node['root_group']
property :mode,             [Integer, String], default: '0640'

action :create do
  converge_by("Create an RSA public key #{new_resource.path} from #{new_resource.private_key_path}") do
    raise "#{new_resource.private_key_path} not a valid private RSA key or password is invalid" unless priv_key_file_valid?(new_resource.private_key_path, new_resource.private_key_pass)

    rsa_key_content = gen_rsa_pub_key(new_resource.private_key_path, new_resource.type, new_resource.private_key_pass)

    file new_resource.path do
      action :create
      owner new_resource.owner
      group new_resource.group
      mode new_resource.mode
      content rsa_key_content
    end
  end
end
