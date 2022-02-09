package 'fish' do
  user 'root'
end

execute 'install fisher' do
  command "curl https://git.io/fisher --create-dirs -sLo #{ENV['HOME']}/.config/fish/functions/fisher.fish"
  not_if "test -e #{ENV['HOME']}/.config/fish/functions/fisher.fish"
  notifies :run, 'execute[fish -c "fisher update"]'
end

execute 'fish -c "fisher update"' do
  action :nothing
end
