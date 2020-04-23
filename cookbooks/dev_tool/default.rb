packages = %w(
  tmux
  peco
  kubectl
).each do |pkg|
  package pkg do
    user "root"
  end
end

directory "#{ENV['HOME']}/bin"

git 'https://github.com/starship/starship' do
  repository 'https://github.com/starship/starship'
  destination "#{ENV['HOME']}/src/github.com/starship/starship"
end

execute 'install starship' do
  command "install/install.sh -y -b #{ENV['HOME']}/bin"
  cwd "#{ENV['HOME']}/src/github.com/starship/starship"
  subscribes :run, 'git[https://github.com/starship/starship]'
  action :nothing
end
