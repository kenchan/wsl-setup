%w(
  app-containers/docker
  app-containers/slirp4netns
  sys-apps/rootlesskit
).each do |pkg|
  package pkg
end

include_recipe '../docker/default.rb'
