# PRIVATE/PUBLIC KEYS

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

describe command('openssl ec -in /etc/ssl_test/eckey_prime256v1_des3.pem -passin pass:"something" -pubout -out /tmp/ec_pub && diff /etc/ssl_test/eckey_prime256v1_des3.pub /tmp/ec_pub') do
  its('exit_status') { should eq 0 }
end

describe command('openssl dhparam -in /etc/ssl_test/dhparam.pem -check -noout') do
  its('exit_status') { should eq 0 }
end

describe command('openssl rsa -in /etc/ssl_test/mycert.key -check -noout') do
  its('exit_status') { should eq 0 }
end

# X509 CERTIFICATES

# mycert.example.com private key

describe file('/etc/ssl_test/mycert.key') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe command('openssl rsa -in /etc/ssl_test/mycert.key -check -noout') do
  its('exit_status') { should eq 0 }
end

# mycert.example.com certificate

describe file('/etc/ssl_test/mycert.crt') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe x509_certificate('/etc/ssl_test/mycert.crt') do
  its('subject_dn') { should match '/C=UK/O=Test Kitchen Example/OU=Kitchens/CN=mycert.example.com' }
  its('issuer_dn') { should eq '/C=UK/O=Test Kitchen Example/OU=Kitchens/CN=mycert.example.com' }
  its('signature_algorithm') { should match /sha256WithRSAEncryption/ }
  its('validity_in_days') { should be <= 365 }
  its('validity_in_days') { should be >= 364 }
  its('version') { should eq 2 }
  its('extensions.basicConstraints') { should match ['critical', 'CA:TRUE'] }
  its('extensions.subjectAltName') { should include 'DNS:localhost.localdomain' }
  its('extensions.subjectAltName') { should include 'IP Address:127.0.0.1' }
end

# mycert2.example.com certificate

describe file('/etc/ssl_test/mycert2.crt') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe x509_certificate('/etc/ssl_test/mycert2.crt') do
  its('subject_dn') { should match '/C=UK/O=Test Kitchen Example/OU=Kitchens/CN=mycert2.example.com' }
  its('issuer_dn') { should eq '/C=UK/O=Test Kitchen Example/OU=Kitchens/CN=mycert2.example.com' }
  its('signature_algorithm') { should match /sha256WithRSAEncryption/ }
  its('validity_in_days') { should be <= 365 }
  its('validity_in_days') { should be >= 364 }
  its('version') { should eq 2 }
  its('extensions.basicConstraints') { should match ['critical', 'CA:TRUE'] }
end

# CA private key

describe file('/etc/ssl_test/my_ca.key') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe command('openssl rsa -in /etc/ssl_test/mycert.key -check -noout') do
  its('exit_status') { should eq 0 }
end

# CA certificate

describe file('/etc/ssl_test/my_ca.crt') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe x509_certificate('/etc/ssl_test/my_ca.crt') do
  its('subject_dn') { should match '/CN=CA' }
  its('issuer_dn') { should eq '/CN=CA' }
  its('signature_algorithm') { should match /sha256WithRSAEncryption/ }
  its('validity_in_days') { should be <= 3650 }
  its('validity_in_days') { should be >= 3649 }
  its('version') { should eq 2 }
  its('extensions.basicConstraints') { should match ['critical', 'CA:TRUE'] }
  its('extensions.keyUsage') { should match ['critical', 'Digital Signature', 'Key Encipherment', 'Certificate Sign', 'CRL Sign'] }
end

# mysignedcert.example.com private key

describe file('/etc/ssl_test/my_signed_cert.key') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe command('openssl rsa -in /etc/ssl_test/my_signed_cert.key -noout -check') do
  its('exit_status') { should eq 0 }
end

# mysignedcert.example.com cert

describe file('/etc/ssl_test/my_signed_cert.crt') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe x509_certificate('/etc/ssl_test/my_signed_cert.crt') do
  its('subject_dn') { should match 'CN=mysignedcert.example.com' }
  its('issuer_dn') { should eq '/CN=CA' }
  its('signature_algorithm') { should match /sha256WithRSAEncryption/ }
  its('validity_in_days') { should be <= 365 }
  its('validity_in_days') { should be >= 364 }
  its('version') { should eq 2 }
  its('extensions.extendedKeyUsage') { should match ['TLS Web Server Authentication'] }
  its('extensions.keyUsage') { should match ['critical', 'Digital Signature', 'Key Encipherment'] }
  its('extensions.subjectAltName') { should include 'DNS:localhost.localdomain' }
  its('extensions.subjectAltName') { should include 'IP Address:127.0.0.1' }
end

# CA2 private key

describe file('/etc/ssl_test/my_ca2.key') do
  it { should exist }
  its('mode') { should cmp '0400' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe command('openssl ec -in /etc/ssl_test/my_ca2.key -noout -text') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /secp521r1/ }
end

# CA2 certificate

describe file('/etc/ssl_test/my_ca2.crt') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe x509_certificate('/etc/ssl_test/my_ca2.crt') do
  its('subject_dn') { should match 'CN=CA2' }
  its('issuer_dn') { should eq '/CN=CA2' }
  its('signature_algorithm') { should match /ecdsa-with-SHA256/ }
  its('validity_in_days') { should be <= 3650 }
  its('validity_in_days') { should be >= 3649 }
  its('version') { should eq 2 }
  its('extensions.keyUsage') { should match ['critical', 'Digital Signature', 'Key Encipherment', 'Certificate Sign', 'CRL Sign'] }
  its('extensions.basicConstraints') { should match ['critical', 'CA:TRUE'] }
end

# mysignedcert2.example.com private key

describe file('/etc/ssl_test/my_signed_cert2.key') do
  it { should exist }
  its('mode') { should cmp '0640' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe command('openssl ec -in /etc/ssl_test/my_signed_cert2.key -noout -text') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /prime256v1/ }
end

# mysignedcert2.example.com certificate

describe file('/etc/ssl_test/my_signed_cert2.crt') do
  it { should exist }
  its('mode') { should cmp '0644' }
  its('group') { should eq 'root' }
  its('owner') { should eq 'root' }
end

describe x509_certificate('/etc/ssl_test/my_signed_cert2.crt') do
  its('subject_dn') { should match 'C=UK/O=Test Kitchen Example/OU=Kitchens/CN=mysignedcert2.example.com' }
  its('issuer_dn') { should eq '/CN=CA2' }
  its('signature_algorithm') { should match /ecdsa-with-SHA256/ }
  its('validity_in_days') { should be <= 365 }
  its('validity_in_days') { should be >= 364 }
  its('version') { should eq 2 }
  its('extensions.extendedKeyUsage') { should match ['TLS Web Server Authentication'] }
  its('extensions.keyUsage') { should match ['critical', 'Digital Signature', 'Key Encipherment'] }
  its('extensions.subjectAltName') { should include 'DNS:localhost.localdomain' }
  its('extensions.subjectAltName') { should include 'IP Address:127.0.0.1' }
end

# X509 CRL
describe command('openssl crl -in /etc/ssl_test/my_ca2.crl -text -noout | grep Serial') do
  its('exit_status') { should eq 0 }
  its('stdout') { should match /C7BCB6602A2E4251EF4E2827A228CB52BC0CEA2F/ }
end

# X509 REQUESTS

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
