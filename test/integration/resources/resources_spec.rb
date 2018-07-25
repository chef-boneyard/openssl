describe key_rsa('/etc/ssl_test/rsakey_des3.pem') do
  it { should be_private }
  its('key_length') { should eq 2048 }
end

describe key_rsa('/etc/ssl_test/rsakey_aes128cbc.pem') do
  it { should be_private }
  its('key_length') { should eq 1024 }
end

describe command('openssl ec -in /etc/ssl_test/eckey_prime256v1_des3.pem -text -noout -passin pass:"something"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /prime256v1/ }
end

describe command('openssl dhparam -in /etc/ssl_test/dhparam.pem -check -noout') do
  its('exit_status') { should eq 0 }
end

describe command('openssl rsa -in /etc/ssl_test/mycert.key -check -noout') do
  its('exit_status') { should eq 0 }
end

describe command('openssl x509 -in /etc/ssl_test/mycert.crt -noout') do
  its('exit_status') { should eq 0 }
end

describe command('openssl ec -in /etc/ssl_test/my_ec_request.key -text -noout') do
  its('exit_status') { should eq 0 }
end

describe command('openssl rsa -in /etc/ssl_test/my_rsa_request.key -check -noout') do
  its('exit_status') { should eq 0 }
end

describe command('openssl req -text -noout -verify -in /etc/ssl_test/my_ec_request.csr') do
  its('exit_status') { should eq 0 }
end

describe command('openssl req -text -noout -verify -in /etc/ssl_test/my_ec_request2.csr') do
  its('exit_status') { should eq 0 }
end

describe command('openssl req -text -noout -verify -in /etc/ssl_test/my_rsa_request.csr') do
  its('exit_status') { should eq 0 }
end

describe command('openssl req -text -noout -verify -in /etc/ssl_test/my_rsa_request2.csr') do
  its('exit_status') { should eq 0 }
end
