execute 'apt-get update' do
  command 'apt-get update -yqq'
end

packages = %w(
  rcm
  fish
  tmux
  direnv
  global
  tig
).each do |pkg|
  package pkg do
    action :install
  end
end

