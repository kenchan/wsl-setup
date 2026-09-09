unless node[:platform] == 'arch'
  ENV['PATH'] = "#{ENV['HOME']}/.local/bin:#{ENV['PATH']}"

  directory "#{ENV['HOME']}/.local/bin"

  execute 'curl https://mise.run | sh' do
    not_if "test -f #{ENV['HOME']}/.local/bin/mise"
  end
end
