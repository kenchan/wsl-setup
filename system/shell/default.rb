package(node[:platform] == 'gentoo' ? 'app-shells/fish' : 'fish')

user 'kenchan' do
  shell '/usr/bin/fish'
end
