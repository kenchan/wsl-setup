execute 'apt-get update' do
  user "root"
  command 'apt-get update -yqq'
end

packages = %w(
  rcm
  fish
  tmux
).each do |pkg|
  package pkg do
    user "root"
    action :install
  end
end

