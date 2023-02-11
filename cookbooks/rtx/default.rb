
execute 'install rtx' do
  command <<-CMD
    curl https://rtx.jdxcode.com/rtx-latest-linux-x64 > #{ENV['HOME']}/.local/bin/rtx
    chmod +x #{ENV['HOME']}/.local/bin/rtx
CMD
  not_if 'command -v rtx'
end

execute 'rtx install -a'
