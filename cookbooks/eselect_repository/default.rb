include_recipe 'define.rb'

package 'eselect-repository' do
  user 'root'
end

eselect_repository 'guru'
