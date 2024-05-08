link '/var/lib/portage/world' do
  to File.expand_path('../files/var/lib/portage/world', __FILE__)
  force true
end

link '/etc/portage/make.conf' do
  to File.expand_path('../files/etc/portage/make.conf', __FILE__)
  force true
end

directory '/etc/portage/package.use'

link '/etc/portage/package.use/zz-autounmask' do
  to File.expand_path('../files/etc/portage/package.use/zz-autounmask', __FILE__)
  force true
end

link '/etc/profile.d/makeopts.sh' do
  to File.expand_path('../files/etc/profile.d/makeopts.sh', __FILE__)
  force true
end
