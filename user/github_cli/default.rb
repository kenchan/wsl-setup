%w(
  k1LoW/gh-grep
  k1LoW/gh-triage
  seachicken/gh-poi
  kenchan/gh-furik
  dlvhdr/gh-dash
).each do |ext|
  name = ext.split('/').last

  execute "install #{ext}" do
    command "gh extension install #{ext}"
    # gh extension list needs authentication; unauthenticated it lists nothing.
    not_if %Q(test -d "${XDG_DATA_HOME:-$HOME/.local/share}/gh/extensions/#{name}")
  end
end
