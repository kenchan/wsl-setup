file '/etc/pacman.conf' do
  action :edit
  block do |content|
    content.gsub!(/^#Color/, "Color")
  end
end
