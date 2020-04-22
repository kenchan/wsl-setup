execute "import thoutbot's gpg key" do
  user "root"
  command "wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -"
  not_if "apt-key list | grep thoughtbot"
end

execute "add thoutbot's apt repository" do
  user "root"
  command "echo 'deb https://apt.thoughtbot.com/debian/ stable main' | tee /etc/apt/sources.list.d/thoughtbot.list"
  not_if "test -e /etc/apt/sources.list.d/thoughtbot.list"
end

package 'rcm' do
  user 'root'
end

DOTFILES_DIR = "#{ENV['HOME']}/src/github.com/kenchan/dotfiles"

git 'kenchan/dotfiles' do
  repository 'https://github.com/kenchan/dotfiles'
  destination DOTFILES_DIR
end

execute 'run rcup' do
  command "RCRC=#{DOTFILES_DIR}/rcrc rcup -f"
  not_if 'lsrc | grep -q dotfiles'
end
