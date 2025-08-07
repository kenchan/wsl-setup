%w(
  k1LoW/gh-grep
  k1LoW/gh-triage
  seachicken/gh-poi
  kenchan/gh-furik
  github/gh-copilot
  dlvhdr/gh-dash
).each do |ext|
  execute "install #{ext}" do
    command "gh extension install #{ext}"
    not_if "gh extension list | grep -q #{ext}"
  end
end
