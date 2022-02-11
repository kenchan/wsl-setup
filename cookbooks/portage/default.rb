link '/var/lib/portage/world' do
  to File.expand_path('../files/var/lib/portage/world', __FILE__)
  force true
  user 'root'
end

link '/etc/portage/make.conf' do
  to File.expand_path('../files/etc/portage/make.conf', __FILE__)
  force true
  user 'root'
end

remote_directory '/etc/portage/package.use' do
  source 'files/etc/portage/package.use'
  user 'root'
end

link '/etc/profile.d/makeopts.sh' do
  to File.expand_path('../files/etc/profile.d/makeopts.sh', __FILE__)
  force true
  user 'root'
end

execute 'emerge -uDN @world' do
  user 'root'
end
