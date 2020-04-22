execute 'add-apt-repository -y ppa:longsleep/golang-backports' do
  user 'root'
  not_if 'apt-cache policy | grep -q longsleep/golang-backports'
end

package 'golang-go' do
  user 'root'
end
