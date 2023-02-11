execute 'install frgm' do
  command <<-EOS
    pushd /tmp &&
    curl -L https://github.com/k1LoW/frgm/releases/download/v0.10.0/frgm_v0.10.0_linux_amd64.tar.gz -o frgm.tar.gz
    tar -zxf frgm.tar.gz frgm &&
    mv frgm ~/.local/bin
    rm frgm.tar.gz
EOS
  not_if 'command -v frgm'
end
