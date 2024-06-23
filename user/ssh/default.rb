directory "#{ENV['HOME']}/.local/bin"

execute 'download and setup wsl2-ssh-agent' do
  command <<-EOH
    curl -L -o ~/.local/bin/wsl2-ssh-agent https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
    chmod +x ~/.local/bin/wsl2-ssh-agent
  EOH
  not_if 'command -vq wsl2-ssh-agent'
end
