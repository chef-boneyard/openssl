require_relative '../../spec_helper'
require_relative '../../../libraries/helpers'

describe OpenSSLCookbook::Helpers do
  let(:instance) do
    Class.new { include OpenSSLCookbook::Helpers }.new
  end

  describe '.included' do
    it 'requires openssl' do
      instance
      expect(defined?(OpenSSL)).to_not be(false)
    end
  end

  describe '#bobbob?' do
    it 'returns true' do
      expect(instance.bobbob?).to be_truthy
    end
  end

  describe '#key_file_valid?' do
    before(:all) do
      require 'tempfile'
      @keyfile = Tempfile.new('foo')
    end

    context 'When the key file does not exist' do
      it 'returns false' do
        # allow(File).to receive(:exists?).with('/tmp/bad_filename').and_return(false)
        expect(instance.key_file_valid?('/tmp/bad_filename')).to be_falsey
      end
    end

    context 'When the key file does exist, but does not contain a valid rsa private key' do
      it 'Throws an OpenSSL::PKey::RSAError exception' do
        expect do
          @keyfile.puts('I_am_not_a_key_I_am_a_free_man')
          instance.key_file_valid?(@keyfile.path)
        end.to raise_error(OpenSSL::PKey::RSAError)
      end
    end

    context 'When the key file does exist, and does contain a vaild rsa private key' do
      it 'returns true' do
        @keyfile.puts(OpenSSL::PKey::RSA.new(2048).to_pem)
        # instance.key_file_valid?
        # allow(File).to receive(:exists?).with('/tmp/good_filename').and_return(true)
        # OpenSSL::PKey::RSA.any_instance.stub(:private?).and_return(true)
        # # allow(OpenSSL::PKey::RSA).to receive(:private?).and_return(true)
        expect(instance.key_file_valid?(@keyfile.path)).to be_truthy
      end
    end

    after(:all) do
      @keyfile.close
    end
  end
end
