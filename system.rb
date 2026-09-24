include_recipe "system/#{node[:platform]}/default.rb"
include_recipe 'system/shell/default.rb'
include_recipe "system/systemd/recipe.rb"
