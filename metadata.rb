name             'openssl'
maintainer       'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license          'Apache 2.0'
description      'Provides a library with a method for generating secure random passwords.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '7.0.0'

recipe 'openssl', 'Empty, this cookbook provides a library, see README.md'
recipe 'upgrade', 'Upgrade OpenSSL library and restart dependent services'

source_url 'https://github.com/chef-cookbooks/openssl'
issues_url 'https://github.com/chef-cookbooks/openssl/issues'
chef_version '>= 12.5' if respond_to?(:chef_version)
