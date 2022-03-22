directory "#{ENV['HOME']}/.local/bin"

link "#{ENV['HOME']}/.local/bin/ssh" do
  to '/mnt/c/Windows/System32/OpenSSH/ssh.exe'
end
