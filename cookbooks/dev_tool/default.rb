packages = %w(
  build-essential
  rcm
  fish
  tmux
  peco
).each do |pkg|
  package pkg do
    user "root"
    action :install
  end
end

