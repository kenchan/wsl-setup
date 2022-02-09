define :eselect_repository, action: :enable do
  case params[:action]
  when :enable
    execute "eselect repository enable #{params[:name]}" do
      not_if "eselect repository list -i | grep -q #{params[:name]}"
      user 'root'
    end
  when :disable
    execute "sudo eselect repository disable #{params[:name]}" do
      only_if "eselect repository list -i | grep -q #{params[:name]}"
      user 'root'
    end
  else
    raise "undefined action #{params[:action]}"
  end
end
