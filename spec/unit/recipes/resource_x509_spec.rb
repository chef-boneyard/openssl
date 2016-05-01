# This Chefspec test was created by Chef generate
#
# Cookbook Name:: openssl
# Spec:: resource-spec
#
# Author:: Charles Johnson (<charles@chef.io>)
#
# Copyright 2015-2016, Chef Software, Inc.
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

# Chefspec examples can be found at
# https://github.com/sethvargo/chefspec/tree/master/examples

require 'spec_helper'

describe 'test::resource_x509' do
  context 'When all attributes are default, on an unspecified platform:' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: ['openssl_x509'])
      runner.converge(described_recipe)
    end

    it 'adds a file resource \'/etc/ssl_test/mycert.crt\' with action delete' do
      expect(chef_run).to delete_file('Any potential existing cert')
    end

    it 'adds a file resource \'/etc/ssl_test/mycert.key\' with action delete' do
      expect(chef_run).to delete_file('Any potential existing key')
    end

    it 'adds a file resource \'/etc/ssl_test/mycert2.crt\' with action delete' do
      expect(chef_run).to delete_file('Any potential existing second cert')
    end

    it 'adds a directory resource \'/etc/ssl_test\' with action create' do
      expect(chef_run).to create_directory('/etc/ssl_test')
    end

    it 'adds an openssl_x509 resource \'/etc/ssl_test/mycert.crt\' with action create' do
      expect(chef_run).to create_x509_certificate('/etc/ssl_test/mycert.crt')
    end

    it 'The LWRP adds a file resource \'/etc/ssl_test/mycert.crt\' with action create_if_missing' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/mycert.crt')
    end

    it 'The LWRP adds a file resource \'/etc/ssl_test/mycert.key\' with action create_if_missing' do
      expect(chef_run).to create_file_if_missing('/etc/ssl_test/mycert.key')
    end
  end
end
