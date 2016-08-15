#
# Cookbook Name:: openssl
# Attributes:: default
#
# Copyright 2014, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['openssl']['packages'] = []
default['openssl']['restart_services'] = []

case node['platform_family']
when 'rhel'
  default['openssl']['default_x509_dir'] = '/etc/pki/tls/localcerts'
when 'debian'
  default['openssl']['default_x509_dir'] = '/etc/ssl/localcerts'
end
