execute "go get github.com/x-motemen/ghq" do
  not_if "command -v ghq"
end
