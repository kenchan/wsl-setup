%w(
  k1LoW/gh-grep
  seachicken/gh-poi
  kenchan/gh-furik
).each do |ext|
  execute "install #{ext}" do
    user ENV['SUDO_USER']
    command "gh extension install #{ext}"
    not_if "gh extension list | grep -q #{ext}"
  end
end
