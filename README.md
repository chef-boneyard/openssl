Description
====

Provide a library method to generate secure random passwords in recipes.

Requirements
====

Works on any platform with OpenSSL Ruby bindings installed, which are a requirement for Chef anyway.

Usage
====

Most often this will be used to generate a secure password for an attribute.

    include Opscode::OpenSSL::Password

    set_unless[:my_password] = secure_password


LWRP
==== 

This cookbook includes an LWRP for generating Self Signed Certificates


## openssl_x509
generate a pem formatted x509 cert + key  

### Attributes
`common_name` A String representing the `CN` ssl field
`org` A String representing the `O` ssl field
`org_unit` A String representing the `OU` ssl field
`country` A String representing the `C` ssl field
`expire` A Fixnum reprenting the number of days from _now_ to expire the cert
`key_file` Optional A string to the key file to use. If no key is present it will generate and store one. 
`key_pass` A String that is the key's passphrase
`key_length` A Fixnum reprenting your desired Bit Length _Default: 2048_
`owner` The owner of the files _Default: "root"_
`group` The group of the files _Default: "root"_
`mode`  The mode to store the files in _Default: "0400"_

### Example usage

    openssl_x509 "/tmp/mycert.pem" do
      common_name "www.f00bar.com"
      org "Foo Bar"
      org_unit "Lab"
      country "US"
    end

    
License and Author
====

Author:: Jesse Nelson (<spheromak@gmail.com>)
Author:: Joshua Timberman (<joshua@opscode.com>)

Copyright:: 2009-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
