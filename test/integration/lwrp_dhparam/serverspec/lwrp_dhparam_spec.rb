require 'spec_helper'

describe 'test::lwrp_dhparam' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  describe command('openssl dhparam -in /etc/ssl_test/dhparam.pem -check -noout') do
    it 'generates a valid dhparam pem' do
      expect(subject.exit_status).to eq 0
    end
  end
end
