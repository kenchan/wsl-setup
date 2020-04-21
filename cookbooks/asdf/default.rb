ASDF_INIT = "/bin/bash -c '. #{ENV['HOME']}/.asdf/asdf.sh;"

git 'install asdf' do
  repository 'https://github.com/asdf-vm/asdf.git'
  destination "#{ENV['HOME']}/.asdf"
  revision 'v0.7.8'
end

IO.read("#{ENV['HOME']}/.tool-versions").split.each_slice(2) do |lang, version|
  execute "asdf plugin add #{lang}" do
    command "#{asdf_init} asdf plugin add #{lang}'"
    not_if "#{asdf_init} asdf plugin list | grep -q #{lang}'"
  end

  execute "asdf install #{lang} #{version}" do
    command "#{asdf_init} asdf install #{lang} #{version}'"
    not_if "#{asdf_init} asdf list #{lang} | grep -q #{version}'"
  end
end

execute 'install nodejs keyring' do
  command "bash #{ENV['HOME']}/.asdf/plugins/nodejs/bin/import-release-team-keyring"
  action :nothing
  subscribes :run, 'execute[asdf plugin add nodejs]', :immediately
end

execute 'install ghq' do
  command "#{asdf_init} go get github.com/x-motemen/ghq'"
end
