#
# Cookbook:: test
# Recipe:: resource_dhparam
#
# Copyright:: 2015-2017, Chef Software, Inc. <legal@chef.io>
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

%w(
  /etc/ssl_test/rsakey_des3.pem
  /etc/ssl_test/rsakey_aes128cbc.pem
  /etc/ssl_test/dhparam.pem
  /etc/ssl_test/mycert.crt
  /etc/ssl_test/mycert.key
  /etc/ssl_test/mycert2.crt
).each do |f|
  file "delete existing test file #{f}" do
    path f
    action :delete
  end
end

# Create directory if not already present
directory '/etc/ssl_test' do
  recursive true
end

#
# DHPARAM HERE
#

# Generate new key and certificate
openssl_dhparam '/etc/ssl_test/dhparam.pem' do
  key_length 1024
  action :create
end

#
# RSA KEYS HERE
#

# Generate new key with des3 cipher using the new resource name
openssl_rsa_private_key '/etc/ssl_test/rsakey_des3.pem' do
  key_length 2048
  action :create
end

# Generate new key with aes-128-cbc cipher with the old resource name
openssl_rsa_key '/etc/ssl_test/rsakey_aes128cbc.pem' do
  key_length 1024
  key_cipher 'aes-128-cbc'
  action :create
end

openssl_rsa_public_key '/etc/ssl_test/rsakey_des3.pub' do
  private_key_path '/etc/ssl_test/rsakey_des3.pem'
  private_key_pass 'something'
  action :create
end

openssl_rsa_public_key '/etc/ssl_test/rsakey_2.pub' do
  private_key_pass 'something'
  private_key_content "-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: DES-EDE3-CBC,5EE0AE9A5FE3342E\n\nyb930kj5/4/nd738dPx6XdbDrMCvqkldaz0rHNw8xsWvwARrl/QSPwROG3WY7ROl\nEUttVlLaeVaqRPfQbmTUfzGI8kTMmDWKjw52gJUx2YJTYRgMHAB0dzYIRjeZAaeS\nypXnEfouVav+jKTmmehr1WuVKbzRhQDBSalzeUwsPi2+fb3Bfuo1dRW6xt8yFuc4\nAkv1hCglymPzPHE2L0nSGjcgA2DZu+/S8/wZ4E63442NHPzO4VlLvpNvJrYpEWq9\nB5mJzcdXPeOTjqd13olNTlOZMaKxu9QShu50GreCTVsl8VRkK8NtwbWuPGBZlIFa\njzlS/RaLuzNzfajaKMkcIYco9t7gN2DwnsACHKqEYT8248Ii3NQ+9/M5YcmpywQj\nWGr0UFCSAdCky1lRjwT+zGQKohr+dVR1GaLem+rSZH94df4YBxDYw4rjsKoEhvXB\nv2Vlx+G7Vl2NFiZzxUKh3MvQLr/NDElpG1pYWDiE0DIG13UqEG++cS870mcEyfFh\nSF2SXYHLWyAhDK0viRDChJyFMduC4E7a2P9DJhL3ZvM0KZ1SLMwROc1XuZ704GwO\nYUqtCX5OOIsTti1Z74jQm9uWFikhgWByhVtu6sYL1YTqtiPJDMFhA560zp/k/qLO\nFKiM4eUWV8AI8AVwT6A4o45N2Ru8S48NQyvh/ADFNrgJbVSeDoYE23+DYKpzbaW9\n00BD/EmUQqaQMc670vmI+CIdcdE7L1zqD6MZN7wtPaRIjx4FJBGsFoeDShr+LoTD\nrwbadwrbc2Rf4DWlvFwLJ4pvNvdtY3wtBu79UCOol0+t8DVVSPVASsh+tp8XncDE\nKRljj88WwBjX7/YlRWvQpe5y2UrsHI0pNy8TA1Xkf6GPr6aS2TvQD5gOrAVReSse\n/kktCzZQotjmY1odvo90Zi6A9NCzkI4ZLgAuhiKDPhxZg61IeLppnfFw0v3H4331\nV9SMYgr1Ftov0++x7q9hFPIHwZp6NHHOhdHNI80XkHqtY/hEvsh7MhFMYCgSY1pa\nK/gMcZ/5Wdg9LwOK6nYRmtPtg6fuqj+jB3Rue5/p9dt4kfom4etCSeJPdvP1Mx2I\neNmyQ/7JN9N87FsfZsIj5OK9OB0fPdj0N0m1mlHM/mFt5UM5x39u13QkCt7skEF+\nyOptXcL629/xwm8eg4EXnKFk330WcYSw+sYmAQ9ZTsBxpCMkz0K4PBTPWWXx63XS\nc4J0r88kbCkMCNv41of8ceeGzFrC74dG7i3IUqZzMzRP8cFeps8auhweUHD2hULs\nXwwtII0YQ6/Fw4hgGQ5//0ASdvAicvH0l1jOQScHzXC2QWNg3GttueB/kmhMeGGm\nsHOJ1rXQ4oEckFvBHOvzjP3kuRHSWFYDx35RjWLAwLCG9odQUApHjLBgFNg9yOR0\njW9a2SGxRvBAfdjTa9ZBBrbjlaF57hq7mXws90P88RpAL+xxCAZUElqeW2Rb2rQ6\nCbz4/AtPekV1CYVodGkPutOsew2zjNqlNH+M8XzfonA60UAH20TEqAgLKwgfgr+a\nc+rXp1AupBxat4EHYJiwXBB9XcVwyp5Z+/dXsYmLXzoMOnp8OFyQ9H8R7y9Y0PEu\n-----END RSA PRIVATE KEY-----\n"
  action :create
end

#
# X509 HERE
#

# Pass the key as as a string
openssl_x509 '/etc/ssl_test/rsakey_des3.crt' do
  common_name 'mycert.example.com'
  org 'Test Kitchen Example'
  org_unit 'Kitchens'
  country 'UK'
  private_key_content "-----BEGIN RSA PRIVATE KEY-----\nProc-Type: 4,ENCRYPTED\nDEK-Info: DES-EDE3-CBC,5EE0AE9A5FE3342E\n\nyb930kj5/4/nd738dPx6XdbDrMCvqkldaz0rHNw8xsWvwARrl/QSPwROG3WY7ROl\nEUttVlLaeVaqRPfQbmTUfzGI8kTMmDWKjw52gJUx2YJTYRgMHAB0dzYIRjeZAaeS\nypXnEfouVav+jKTmmehr1WuVKbzRhQDBSalzeUwsPi2+fb3Bfuo1dRW6xt8yFuc4\nAkv1hCglymPzPHE2L0nSGjcgA2DZu+/S8/wZ4E63442NHPzO4VlLvpNvJrYpEWq9\nB5mJzcdXPeOTjqd13olNTlOZMaKxu9QShu50GreCTVsl8VRkK8NtwbWuPGBZlIFa\njzlS/RaLuzNzfajaKMkcIYco9t7gN2DwnsACHKqEYT8248Ii3NQ+9/M5YcmpywQj\nWGr0UFCSAdCky1lRjwT+zGQKohr+dVR1GaLem+rSZH94df4YBxDYw4rjsKoEhvXB\nv2Vlx+G7Vl2NFiZzxUKh3MvQLr/NDElpG1pYWDiE0DIG13UqEG++cS870mcEyfFh\nSF2SXYHLWyAhDK0viRDChJyFMduC4E7a2P9DJhL3ZvM0KZ1SLMwROc1XuZ704GwO\nYUqtCX5OOIsTti1Z74jQm9uWFikhgWByhVtu6sYL1YTqtiPJDMFhA560zp/k/qLO\nFKiM4eUWV8AI8AVwT6A4o45N2Ru8S48NQyvh/ADFNrgJbVSeDoYE23+DYKpzbaW9\n00BD/EmUQqaQMc670vmI+CIdcdE7L1zqD6MZN7wtPaRIjx4FJBGsFoeDShr+LoTD\nrwbadwrbc2Rf4DWlvFwLJ4pvNvdtY3wtBu79UCOol0+t8DVVSPVASsh+tp8XncDE\nKRljj88WwBjX7/YlRWvQpe5y2UrsHI0pNy8TA1Xkf6GPr6aS2TvQD5gOrAVReSse\n/kktCzZQotjmY1odvo90Zi6A9NCzkI4ZLgAuhiKDPhxZg61IeLppnfFw0v3H4331\nV9SMYgr1Ftov0++x7q9hFPIHwZp6NHHOhdHNI80XkHqtY/hEvsh7MhFMYCgSY1pa\nK/gMcZ/5Wdg9LwOK6nYRmtPtg6fuqj+jB3Rue5/p9dt4kfom4etCSeJPdvP1Mx2I\neNmyQ/7JN9N87FsfZsIj5OK9OB0fPdj0N0m1mlHM/mFt5UM5x39u13QkCt7skEF+\nyOptXcL629/xwm8eg4EXnKFk330WcYSw+sYmAQ9ZTsBxpCMkz0K4PBTPWWXx63XS\nc4J0r88kbCkMCNv41of8ceeGzFrC74dG7i3IUqZzMzRP8cFeps8auhweUHD2hULs\nXwwtII0YQ6/Fw4hgGQ5//0ASdvAicvH0l1jOQScHzXC2QWNg3GttueB/kmhMeGGm\nsHOJ1rXQ4oEckFvBHOvzjP3kuRHSWFYDx35RjWLAwLCG9odQUApHjLBgFNg9yOR0\njW9a2SGxRvBAfdjTa9ZBBrbjlaF57hq7mXws90P88RpAL+xxCAZUElqeW2Rb2rQ6\nCbz4/AtPekV1CYVodGkPutOsew2zjNqlNH+M8XzfonA60UAH20TEqAgLKwgfgr+a\nc+rXp1AupBxat4EHYJiwXBB9XcVwyp5Z+/dXsYmLXzoMOnp8OFyQ9H8R7y9Y0PEu\n-----END RSA PRIVATE KEY-----\n"
  private_key_pass 'something'
  subject_alt_name ['IP:127.0.0.1', 'DNS:localhost.localdomain']
end

# Pass the key as a path
openssl_x509 '/etc/ssl_test/mycert2.crt' do
  common_name 'mycert2.example.com'
  org 'Test Kitchen Example'
  org_unit 'Kitchens'
  country 'UK'
  private_key_path '/etc/ssl_test/rsakey_aes128cbc.pem'
end
