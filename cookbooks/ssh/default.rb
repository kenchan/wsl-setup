directory "/home/#{ENV['SUDO_USER']}/.local/bin" do
  user ENV['SUDO_USER']
end

link "/home/#{ENV['SUDO_USER']}/.local/bin/ssh" do
  user ENV['SUDO_USER']
  to '/mnt/c/Windows/System32/OpenSSH/ssh.exe'
end
