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

execute 'trust dotfiles mise config' do
  command 'mise trust mise.toml'
  cwd DOTFILES_DIR
end

execute 'apply dotfiles with mise' do
  command 'mise dotfiles apply --yes'
  cwd DOTFILES_DIR
end
