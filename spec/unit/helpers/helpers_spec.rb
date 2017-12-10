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

  # Path helpers
  describe '#get_key_filename' do
    context 'When the input is not a string' do
      it 'Throws a TypeError' do
        expect do
          instance.get_key_filename(33)
        end.to raise_error(TypeError)
      end
    end

    context 'when the input is a string' do
      it 'Generates valid keyfile names' do
        expect(instance.get_key_filename('/etc/temp.crt')).to match('/etc/temp.key')
      end
    end
  end

  # Validation helpers
  describe '#key_length_valid?' do
    context 'When the number is less than 1024' do
      it 'returns false' do
        expect(instance.key_length_valid?(1023)).to be_falsey
        expect(instance.key_length_valid?(2)).to be_falsey
        expect(instance.key_length_valid?(64)).to be_falsey
        expect(instance.key_length_valid?(512)).to be_falsey
      end
    end

    context 'When the number is greater than 1024 but is not a power of 2' do
      it 'returns false' do
        expect(instance.key_length_valid?(1025)).to be_falsey
        expect(instance.key_length_valid?(6666)).to be_falsey
        expect(instance.key_length_valid?(8191)).to be_falsey
      end
    end

    context 'When the number is a power of 2, equal to or greater than 1024' do
      it 'returns true' do
        expect(instance.key_length_valid?(1024)).to be_truthy
        expect(instance.key_length_valid?(2048)).to be_truthy
        expect(instance.key_length_valid?(4096)).to be_truthy
        expect(instance.key_length_valid?(8192)).to be_truthy
      end
    end
  end

  describe '#dhparam_pem_valid?' do
    require 'tempfile'

    before(:each) do
      @dhparam_file = Tempfile.new('dhparam')
    end

    context 'When the dhparam.pem file does not exist' do
      it 'returns false' do
        expect(instance.dhparam_pem_valid?('/tmp/bad_filename')).to be_falsey
      end
    end

    context 'When the dhparam.pem file does exist, but does not contain a valid dhparam key' do
      it 'Throws an OpenSSL::PKey::DHError exception' do
        expect do
          @dhparam_file.puts('I_am_not_a_key_I_am_a_free_man')
          @dhparam_file.close
          instance.dhparam_pem_valid?(@dhparam_file.path)
        end.to raise_error(OpenSSL::PKey::DHError)
      end
    end

    context 'When the dhparam.pem file does exist, and does contain a vaild dhparam key' do
      it 'returns true' do
        @dhparam_file.puts(OpenSSL::PKey::DH.new(1024).to_pem)
        @dhparam_file.close
        expect(instance.dhparam_pem_valid?(@dhparam_file.path)).to be_truthy
      end
    end

    after(:each) do
      @dhparam_file.unlink
    end
  end

  describe '#key_file_valid?' do
    require 'tempfile'
    require 'openssl' unless defined?(OpenSSL)

    cipher = OpenSSL::Cipher::Cipher.new('des3')

    before(:each) do
      @keyfile = Tempfile.new('keyfile')
    end

    context 'When the key file does not exist' do
      it 'returns false' do
        expect(instance.key_file_valid?('/tmp/bad_filename')).to be_falsey
      end
    end

    context 'When the key file does exist, but does not contain a valid rsa private key' do
      it 'Throws an OpenSSL::PKey::RSAError exception' do
        expect do
          @keyfile.puts('I_am_not_a_key_I_am_a_free_man')
          @keyfile.close
          instance.key_file_valid?(@keyfile.path)
        end.to raise_error(OpenSSL::PKey::RSAError)
      end
    end

    context 'When the key file does exist, and does contain a vaild rsa private key' do
      it 'returns true' do
        @keyfile.puts(OpenSSL::PKey::RSA.new(2048).to_pem)
        @keyfile.close
        expect(instance.key_file_valid?(@keyfile.path)).to be_truthy
      end
    end

    context 'When a valid keyfile requires a passphrase, and an invalid passphrase is supplied' do
      it 'Throws an OpenSSL::PKey::RSAError exception' do
        expect do
          @keyfile.puts(OpenSSL::PKey::RSA.new(2048).to_pem(cipher, 'oink'))
          @keyfile.close
          instance.key_file_valid?(@keyfile.path, 'poml')
        end.to raise_error(OpenSSL::PKey::RSAError)
      end
    end

    context 'When a valid keyfile requires a passphrase, and a valid passphrase is supplied' do
      it 'returns true' do
        @keyfile.puts(OpenSSL::PKey::RSA.new(2048).to_pem(cipher, 'oink'))
        @keyfile.close
        expect(instance.key_file_valid?(@keyfile.path, 'oink')).to be_truthy
      end
    end

    after(:each) do
      @keyfile.unlink
    end
  end

  # Generators
  describe '#gen_dhparam' do
    context 'When given an invalid key length' do
      it 'Throws an ArgumentError' do
        expect do
          instance.gen_dhparam(2046, 2)
        end.to raise_error(ArgumentError)
      end
    end

    context 'When given an invalid generator id' do
      it 'Throws a TypeError' do
        expect do
          instance.gen_dhparam(2048, 'bob')
        end.to raise_error(TypeError)
      end
    end

    context 'When a proper key length and generator id are given' do
      it 'Generates a dhparam object' do
        expect(instance.gen_dhparam(1024, 2)).to be_kind_of(OpenSSL::PKey::DH)
      end
    end
  end

  describe '#gen_rsa_key' do
    context 'When given an invalid key length' do
      it 'Throws an ArgumentError' do
        expect do
          instance.gen_rsa_key(4093)
        end.to raise_error(ArgumentError)
      end
    end

    context 'When a proper key length is given' do
      it 'Generates an RSA key object' do
        expect(instance.gen_rsa_key(1024)).to be_kind_of(OpenSSL::PKey::RSA)
      end
    end
  end

  describe '#encrypt_rsa_key' do
    before(:all) do
      @rsa_key = OpenSSL::PKey::RSA.new(1024)
    end

    context 'When given anything other than an RSA key object to encrypt' do
      it 'Raises a TypeError' do
        expect do
          instance.encrypt_rsa_key('abcd', 'efgh', 'des3')
        end.to raise_error(TypeError)
      end
    end

    context 'When given anything other than a string as the passphrase' do
      it 'Raises a TypeError' do
        expect do
          instance.encrypt_rsa_key(@rsa_key, 1234, 'des3')
        end.to raise_error(TypeError)
      end
    end

    context 'When given anything other than a string as the cipher' do
      it 'Raises a TypeError' do
        expect do
          instance.encrypt_rsa_key(@rsa_key, '1234', 1234)
        end.to raise_error(TypeError)
      end
    end

    context 'When given an invalid cipher string' do
      it 'Raises an ArgumentError' do
        expect do
          instance.encrypt_rsa_key(@rsa_key, '1234', 'des3_bogus')
        end.to raise_error(ArgumentError)
      end
    end

    context 'When given a valid RSA key and a valid passphrase string' do
      it 'Generates a valid encrypted PEM' do
        @encrypted_key = instance.encrypt_rsa_key(@rsa_key, 'oink', 'des3')
        expect(@encrypted_key).to be_kind_of(String)
        expect(OpenSSL::PKey::RSA.new(@encrypted_key, 'oink', 'des3').private?).to be_truthy
      end
    end
  end
end
