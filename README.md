OpenSSL Cookbook
================
[![Build Status](https://travis-ci.org/chef-cookbooks/openssl.svg?branch=master)](http://travis-ci.org/chef-cookbooks/openssl)
[![Cookbook Version](https://img.shields.io/cookbook/v/openssl.svg)](https://supermarket.chef.io/cookbooks/openssl)

This cookbook provides tools for working with the Ruby OpenSSL library. It includes:
- A library method to generate secure random passwords in recipes, using the Ruby SecureRandom library.
- An LWRP for generating RSA private keys.
- An LWRP for generating x509 certificates.
- An LWRP for generating dhparam.pem files.
- An attribute-driven recipe for upgrading OpenSSL packages.

Requirements
------------

The `random_password` mixin works on any platform with the Ruby SecureRandom module. This module is already included with Chef.

The `openssl_x509`, `openssl_rsa_key` and `openssl_dhparam` LWRPs work on any platform with the OpenSSL Ruby bindings installed. These bindings are already included with Chef.

The `upgrade` recipe has been tested on the following platforms:

* Ubuntu 12.04, 14.04
* Debian 7.4
* CentOS 6.5

The recipe may work on other platforms or different versions of the above platforms, but this has not been tested.

Dependencies
------------

This cookbook depends on the [Chef Sugar](http://supermarket.chef.io/cookbooks/chef-sugar/) cookbook. [Chef Sugar](http://supermarket.chef.io/cookbooks/chef-sugar/) is used to make the default attribute settings easier to reason about. (See [Attributes](#attributes))

Attributes
----------

* `node['openssl']['packages']` - An array of packages required to use openssl. The default attributes attempt to be smart about which packages are the default, but this may need to be changed by users of the `openssl::upgrade` recipe.
* `node['openssl']['restart_services']` - An array of service resources that depend on the packages listed in the `node['openssl']['packages']` attribute. This array is empty by default, as Chef has no reasonable way to detect which applications or services are compiled against these packages. *Note* Each service listed in this array should represent a "`service`" resource specified in the recipes of the node's run list.
* `node['default_x509_dir']` - The directory where new x509 certificates
  are placed unless specified otherwise.

Recipes
-------

### default

An empty placeholder recipe. Takes no action.

### upgrade

The upgrade recipe iterates over the list of packages in the `node['openssl']['packages']` attribute, and manages them with the `:upgrade` action. Each package will send a `:restart` notification to service resources named in the `node['openssl']['restart_services']` attribute.

#### Example Usage

In this example, assume the node is running the `stats_collector` daemon, which depends on the openssl library. Imagine that a new openssl vulnerability has been disclosed, and the operating system vendor has released an update to openssl to address this vulnerability. In order to protect the node, an administrator crafts this recipe:

```ruby
node.default['openssl']['restart_services'] = ['stats_collector']

# other recipe code here...
service 'stats_collector' do
  action [:enable, :start]
end

include_recipe 'openssl::upgrade'
```

When executed, this recipe will ensure that openssl is upgraded to the latest version, and that the `stats_collector` service is restarted to pick up the latest security fixes released in the openssl package.

Libraries & LWRPs
-----------------

There are two mixins packaged with this cookbook.

### random_password (`OpenSSLCookbook::RandomPassword`)

The `RandomPassword` mixin can be used to generate secure random passwords in Chef cookbooks, usually for assignment to a variable or an attribute. `random_password` uses Ruby's SecureRandom library and is customizable.

#### Example Usage
```ruby
Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.set['my_secure_attribute'] = random_password
node.set_unless['my_secure_attribute'] = random_password
node.set['my_secure_attribute'] = random_password(length: 50)
node.set['my_secure_attribute'] = random_password(length: 50, mode: :base64)
node.set['my_secure_attribute'] = random_password(length: 50, mode: :base64, encoding: 'ASCII')
```

Note that node attributes are widely accessible. Storing unencrypted passwords in node attributes, as in this example, carries risk.

### ~~secure_password (`Opscode::OpenSSL::Password`)~~

This library should be considered deprecated and will be removed in a future version. Please use `OpenSSLCookbook::RandomPassword` instead. The documentation is kept here for historical reasons.

#### ~~Example Usage~~
```ruby
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['my_password'] = secure_password
```

~~Note that node attributes are widely accessible. Storing unencrypted passwords in node attributes, as in this example, carries risk.~~

### openssl_x509

This LWRP generates self-signed, PEM-formatted x509 certificates. If no existing key is specified, the LWRP will automatically generate a passwordless key with the certificate.

#### Attributes
| Name  | Type | Description |
| ----- | ---- | ------------ |
| `common_name`  | String (Required)  | Value for the `CN` certificate field. |
| `org` | String (Required) | Value for the `O` certificate field. |
| `org_unit` | String (Required) | Value for the `OU` certificate field. |
| `country` | String (Required) | Value for the `C` ssl field. |
| `expire` | Fixnum (Optional) | Value representing the number of days from _now_ through which the issued certificate cert will remain valid. The certificate will expire after this period. |
| `cert_dir` | String (Optional) | The directory to place new
certificates when resource name is not an absolute path. Overrides `node['openssl']['default_x509_dir']`. _Default: varies by
platform family._ |
| `key_file` | String (Optional) | The path to a certificate key file on the filesystem. If the `key_file` attribute is specified, the LWRP will attempt to source a key from this location. If no key file is found, the LWRP will generate a new key file at this location. If the `key_file` attribute is not specified, the LWRP will generate a key file in the same directory as the generated certificate, with the same name as the generated certificate.
| `key_pass` | String (Optional) | The passphrase for an existing key's passphrase |
| `key_length` | Fixnum (Optional) | The desired Bit Length of the generated key. _Default: 2048_ |
| `owner` | String (optional) | The owner of all files created by the LWRP. _Default: "root"_ |
| `group` | String (optional) | The group of all files created by the LWRP. _Default: "root"_ |
| `mode` | String or Fixnum (Optional) | The permission mode of all files created by the LWRP.  _Default: "0400"_ |

#### Example Usage

In this example, an administrator wishes to create a self-signed x509 certificate for use with a web server. In order to create the certificate, the administrator crafts this recipe:

```ruby

openssl_x509 '/etc/httpd/ssl/mycert.pem' do
  common_name 'www.f00bar.com'
  org 'Foo Bar'
  org_unit 'Lab'
  country 'US'
end

openssl_x509 'mycert.crt' do
  cert_dir '/etc/httpd/ssl'
  common_name 'www.f00bar.com'
  org 'Foo Bar'
  org_unit 'Lab'
  country 'US'
end

# Created at `/etc/ssl/localcerts/mycert.pem` on Debian platforms.
openssl_x509 'mycert.pem' do
  common_name 'www.f00bar.com'
  org 'Foo Bar'
  org_unit 'Lab'
  country 'US'
end
```

When executed, this recipe will generate a key certificate at `/etc/httpd/ssl/mycert.key`. It will then use that key to generate a new certificate file at `/etc/httpd/ssl/mycert.pem`.

### openssl_dhparam

This LWRP generates dhparam.pem files. If a valid dhparam.pem file is found at the specified location, no new file will be created. If a file is found at the specified location but it is not a valid dhparam file, it will be overwritten.

#### Attributes
| Name  | Type | Description |
| ----- | ---- | ------------ |
| `key_length` | Fixnum (Optional) | The desired Bit Length of the generated key. _Default: 2048_ |
| `generator` | Fixnum (Optional) | The desired Diffie-Hellmann generator. Can be _2_ or _5_. |
| `owner` | String (optional) | The owner of all files created by the LWRP. _Default: "root"_ |
| `group` | String (optional) | The group of all files created by the LWRP. _Default: "root"_ |
| `mode` | String or Fixnum (Optional) | The permission mode of all files created by the LWRP.  _Default: "0644"_ |

#### Example Usage

In this example, an administrator wishes to create a dhparam.pem file for use with a web server. In order to create the .pem file, the administrator crafts this recipe:

```ruby
openssl_dhparam '/etc/httpd/ssl/dhparam.pem' do
  key_length 2048 
  generator 2
end
```

When executed, this recipe will generate a dhparam file at `/etc/httpd/ssl/dhparam.pem`.

### openssl_rsa_key

This LWRP generates rsa key files. If a valid rsa key file can be opened at the specified location, no new file will be created. If the RSA key file cannot be opened, either because it does not exist or because the password to the RSA key file does not match the password in the recipe, it will be overwritten.

#### Attributes
| Name  | Type | Description |
| ----- | ---- | ------------ |
| `key_length` | Fixnum (Optional) | The desired Bit Length of the generated key. _Default: 2048_ |
| `key_pass` | String (Optional) | The desired passphrase for the key. |
| `owner` | String (optional) | The owner of all files created by the LWRP. _Default: "root"_ |
| `group` | String (optional) | The group of all files created by the LWRP. _Default: "root"_ |
| `mode` | String or Fixnum (Optional) | The permission mode of all files created by the LWRP.  _Default: "0644"_ |

#### Example Usage

In this example, an administrator wishes to create a new RSA private key file in order to generate other certificates and public keys. In order to create the key file, the administrator crafts this recipe:

```ruby
openssl_rsa_key '/etc/httpd/ssl/server.key' do
  key_length 2048 
end
```

When executed, this recipe will generate a passwordless RSA key file at `/etc/httpd/ssl/server.key`.


License and Author
------------------

Author:: Jesse Nelson (<spheromak@gmail.com>)  
Author:: Seth Vargo (<sethvargo@gmail.com>)  
Author:: Charles Johnson (<charles@chef.io>)  
Author:: Joshua Timberman (<joshua@chef.io>)

=======

```text
Copyright:: 2009-2015, Chef Software, Inc <lega@chef.io>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
