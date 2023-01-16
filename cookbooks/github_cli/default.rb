%w(
  k1LoW/gh-grep
  seachicken/gh-poi
).each do |ext|
  execute "install #{ext}" do
    command "gh extension install #{ext}"
    not_if "gh extension list | grep -q #{ext}"
  end
end
