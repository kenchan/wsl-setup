execute "go get x-motemen/ghq" do
  not_if "command -v ghq"
end
