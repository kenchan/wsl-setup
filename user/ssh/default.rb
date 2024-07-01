directory "#{ENV['HOME']}/.local/bin"

execute 'download and setup wsl2-ssh-agent' do
  command <<-EOS
    curl -L -o #{ENV['HOME']}/.local/bin/wsl2-ssh-agent https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
    chmod +x #{ENV['HOME']}/.local/bin/wsl2-ssh-agent
  EOS
  not_if "test -f #{ENV['HOME']}/.local/bin/wsl2-ssh-agent"
end
