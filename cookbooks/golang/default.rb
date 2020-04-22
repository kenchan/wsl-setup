execute 'add-apt-respository ppa:longsleep/golang-backports' do
  user 'root'
  not_if 'apt-cache policy | grep -q ppa:longsleep/golang-backports'
end

package 'golang-go' do
  user 'root'
end
