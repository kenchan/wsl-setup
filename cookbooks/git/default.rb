file "#{ENV['HOME']}/.config/git/config.local" do
  action :create
  content <<-EOS
[credential]
    helper = /mnt/c/Program\\\\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe
EOS
end
