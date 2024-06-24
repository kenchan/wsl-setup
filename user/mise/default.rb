directory "~/.local/bin"

execute 'curl https://mise.run | sh' do
  not_if 'test -f ~/.local/bin/mise'
end
