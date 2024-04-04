%w(
  k1LoW/gh-grep
  seachicken/gh-poi
  kenchan/gh-furik
  github/gh-copilot
).each do |ext|
  execute "install #{ext}" do
    command "gh extension install #{ext}"
    not_if "gh extension list | grep -q #{ext}"
  end
end
