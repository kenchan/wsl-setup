package 'neovim'

execute 'install vim-plug' do
  command "curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  not_if "test -e ~/.local/share/nvim/site/autoload/plug.vim"
end
