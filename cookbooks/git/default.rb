file "#{ENV['HOME']}/.config/git/config.local" do
  action :create
  content <<-EOS
[credential]
    helper = /mnt/c/Program\\\\ Files/Git/mingw64/bin/git-credential-manager.exe
EOS
end
