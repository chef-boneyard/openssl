include OpenSSLCookbook::Helpers

property :path,                String, name_property: true
property :private_key_path,    String
property :private_key_content, String
property :private_key_pass,    String
property :owner,               String, default: node['platform'] == 'windows' ? 'Administrator' : 'root'
property :group,               String, default: node['root_group']
property :mode,                [Integer, String], default: '0640'

default_action :create

action :create do
  raise ArgumentError, "You cannot specify both 'private_key_path' and 'private_key_content' properties at the same time." if new_resource.private_key_path && new_resource.private_key_content
  raise ArgumentError, "You must specify the private key with either 'private_key_path' or 'private_key_content' properties." unless new_resource.private_key_path || new_resource.private_key_content
  raise "#{new_resource.private_key_path} not a valid private EC key or password is invalid" unless priv_key_file_valid?((new_resource.private_key_path || new_resource.private_key_content), new_resource.private_key_pass)

  ec_key_content = gen_ec_pub_key((new_resource.private_key_path || new_resource.private_key_content), new_resource.private_key_pass)

  file new_resource.name do
    action :create
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    content ec_key_content
  end
end
