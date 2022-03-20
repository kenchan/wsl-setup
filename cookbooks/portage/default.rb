link '/var/lib/portage/world' do
  to File.expand_path('../files/var/lib/portage/world', __FILE__)
  force true
end

link '/etc/portage/make.conf' do
  to File.expand_path('../files/etc/portage/make.conf', __FILE__)
  force true
end

remote_directory '/etc/portage/package.use' do
  source 'files/etc/portage/package.use'
end

link '/etc/profile.d/makeopts.sh' do
  to File.expand_path('../files/etc/profile.d/makeopts.sh', __FILE__)
  force true
end

directory '/var/db/repos/gentoo' do
  action :delete
  not_if "test -d /var/db/repos/gentoo/.git"
  notifies :run, 'execute[git clone portage tree]', :immediately
end

execute 'git clone portage tree' do
  action :nothing
  command 'git clone https://github.com/gentoo-mirror/gentoo.git /var/db/repos/gentoo'
end
