execute "go get x-motement/ghq" do
  not_if "command -v ghq"
end
