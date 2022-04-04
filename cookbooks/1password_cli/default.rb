execute 'install 1Password CLI' do
  command <<-EOS
    pushd /tmp &&
    curl https://cache.agilebits.com/dist/1P/op2/pkg/v2.0.0/op_linux_amd64_v2.0.0.zip -o 1password.zip &&
    unzip 1password.zip op &&
    mv op ~/.local/bin
EOS
  not_if 'command -v op'
end

