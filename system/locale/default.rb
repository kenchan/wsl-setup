remote_file '/etc/locale.gen' do
  source 'files/etc/locale.gen'
  mode '644'
  notifies :run, 'execute[locale-gen]'
end

execute 'locale-gen' do
  action :nothing
end
