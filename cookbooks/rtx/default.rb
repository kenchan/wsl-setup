execute 'install rtx' do
  command <<-CMD
    curl https://rtx.jdxcode.com/rtx-latest-linux-x64 > #{ENV['HOME']}/.local/bin/rtx
    chmod +x #{ENV['HOME']}/.local/bin/rtx
CMD
  not_if "test -e #{ENV['HOME']}/.local/bin/rtx"
end

execute 'rtx install -a' do
  action :nothing
  subscribes :run, 'execute[install rtx]'
end
