packages = %w(
  kubectl
  peco
  ripgrep
  tmux
  unzip
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

execute 'install aws-cli v2' do
  cwd '/tmp'
  user 'root'
  command <<-EOS
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";
    unzip awscliv2.zip;
    ./aws/install;
    rm awscliv2.zip;
  EOS
  not_if 'command -v aws'
end

