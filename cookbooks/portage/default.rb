link '/var/lib/portage/world' do
  to File.expand_path('../files/var/lib/portage/world', __FILE__)
  force true
  user 'root'
end

execute 'emerge -uDN @world' do
  user 'root'
end
