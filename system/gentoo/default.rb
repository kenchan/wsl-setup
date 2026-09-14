package 'eix'

include_recipe '00_portage_tree.rb'
include_recipe '01_eselect_repository.rb'
include_recipe '02_portage.rb'
include_recipe '03_docker.rb'
include_recipe '../sudoers/default.rb'
