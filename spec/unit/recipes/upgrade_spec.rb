# This Chefspec test was created by Chef generate
#
# Cookbook Name:: openssl
# Spec:: upgrade_spec
#
# Author:: Joshua Timberman (<jtimberman@chef.io>)
# Author:: Charles Johnson (<charles@chef.io>)
#
# Copyright 2015, Chef Software, Inc.
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

describe 'openssl::upgrade' do
  let(:openssl) { chef_run.node['openssl'] }

  shared_examples_for :upgrade_recipe do
    it 'includes the chef-sugar recipe' do
      expect(chef_run).to include_recipe('chef-sugar')
    end

    it 'adds a package resource with action upgrade for each package in the [\'openssl\'][\'packages\'] array' do
      openssl['packages'].each do |pkg|
        expect(chef_run).to upgrade_package(pkg)
      end
    end
  end

  context 'When all attributes are default, on an unspecified platform:' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'sets the default attributes correctly' do
      expect(openssl['packages']).to be_empty
      expect(openssl['restart_services']).to be_empty
    end

    it_behaves_like :upgrade_recipe
  end

  context 'When all attributes are default, on the Ubuntu Precise platform or later, the recipe:' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04')
      runner.converge(described_recipe)
    end

    it 'sets the default attributes correctly' do
      expect(openssl['packages']).to match_array(['libssl1.0.0', 'openssl'])
      expect(openssl['restart_services']).to be_empty
    end

    it_behaves_like :upgrade_recipe
  end

  context 'When all attributes are default, on RedHat 6.5, the recipe:' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '6.5')
      runner.converge(described_recipe)
    end

    it 'sets the default attributes correctly' do
      expect(openssl['packages']).to match_array(['openssl'])
      expect(openssl['restart_services']).to be_empty
    end

    it_behaves_like :upgrade_recipe
  end

  context 'When the [\'openssl\'][\'restart_services\'] array is set to [\'httpd\'], on RedHat 6.5, the recipe:' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '6.5')
      runner.node.set['openssl']['restart_services'] = ['httpd']
      runner.converge('test::httpd', described_recipe)
    end

    it 'sets the default attributes correctly' do
      expect(openssl['packages']).to match_array(['openssl'])
    end

    it_behaves_like :upgrade_recipe

    let(:package) { chef_run.package('openssl') }

    it 'The created package resource to upgrade openssl notifies the httpd service resource to restart' do
      expect(package).to notify('service[httpd]').to(:restart)
    end
  end
end
