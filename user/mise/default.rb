directory "#{ENV['HOME']}/.local/bin"

execute 'curl https://mise.run | sh' do
  not_if 'command -vq mise'
end
