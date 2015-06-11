require 'spec_helper'
require_relative '../../../libraries/random_password'

describe OpenSSLCookbook::RandomPassword do
  let(:instance) do
    Class.new { include OpenSSLCookbook::RandomPassword }.new
  end

  describe '.included' do
    it 'requires securerandom' do
      instance
      expect(defined?(SecureRandom)).to_not be(false)
    end
  end

  describe '#random_password' do
    context 'with no options' do
      it 'returns a random hex password' do
        expect(instance.random_password).to match(/[a-z0-9]{20}/)
      end
    end

    context 'with the :length option' do
      it 'returns a password with the given length' do
        expect(instance.random_password(length: 50).size).to eq(50)
      end
    end

    context 'with the :mode option' do
      it 'returns a :hex password with :hex' do
        expect(instance.random_password(mode: :hex)).to match(/[a-z0-9]{20}/)
      end

      it 'returns a :base64 password with :base64' do
        expect(instance.random_password(mode: :base64).size).to eq(20)
      end

      it 'returns a :random_bytes password with :random_bytes' do
        # There's nothing to really assert here, since the length can vary
        # depending on the encoding and whatnot...
        expect { instance.random_password(mode: :random_bytes) }.to_not raise_error
      end
    end

    context 'with the :encoding option' do
      it 'returns a password with the forced encoding' do
        expect(instance.random_password(encoding: 'ASCII').encoding.to_s).to eq('US-ASCII')
      end
    end
  end
end
