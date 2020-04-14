git 'install asdf' do
  repository 'https://github.com/asdf-vm/asdf.git'
  destination "#{ENV['HOME']}/.asdf"
  revision 'v0.7.8'
end
