package 'eix'

include_recipe '00_portage_tree.rb'
include_recipe '01_eselect_repository.rb'
include_recipe '02_portage.rb'
include_recipe '../sudoers/default.rb'
include_recipe '../docker/default.rb'
