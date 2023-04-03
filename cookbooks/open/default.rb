remote_file "/home/#{ENV['SUDO_USER']}/.local/bin/open" do
  owner ENV['SUDO_USER']
  mode '755'
  source 'files/open'
end
