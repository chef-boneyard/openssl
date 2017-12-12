name             'openssl'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache-2.0'
description      'Resources and libraries for interacting with certificates, keys, passwords, and dhparam files.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '7.1.0'

recipe 'openssl::upgrade', 'Upgrade OpenSSL library and restart dependent services'

%w(ubuntu debian redhat centos suse opensuse opensuseleap scientific oracle amazon zlinux).each do |os|
  supports os
end

source_url 'https://github.com/chef-cookbooks/openssl'
issues_url 'https://github.com/chef-cookbooks/openssl/issues'
chef_version '>= 12.7' if respond_to?(:chef_version)
