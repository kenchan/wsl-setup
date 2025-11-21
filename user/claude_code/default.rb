directory "#{ENV['HOME']}/.local/bin"

execute 'curl -fsSL https://claude.ai/install.sh | bash' do
  not_if "test -f #{ENV['HOME']}/.local/bin/claude-code"
end
