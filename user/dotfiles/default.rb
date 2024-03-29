DOTFILES_DIR = "#{ENV['HOME']}/src/github.com/kenchan/dotfiles"

git 'kenchan/dotfiles' do
  repository 'https://github.com/kenchan/dotfiles'
  destination DOTFILES_DIR
  revision 'master'
end

execute 'git switch master' do
  command 'git switch master && git branch -d deploy'
  cwd DOTFILES_DIR
  only_if 'git branch --show-current | grep -q deploy'
end

execute 'run rcup' do
  command "RCRC=#{DOTFILES_DIR}/rcrc rcup -f"
  not_if 'lsrc | grep -q dotfiles'
end
