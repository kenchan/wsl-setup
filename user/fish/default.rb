execute 'install fisher and the fish plugins' do
  # fisher reads stdin, which blocks forever when provisioning runs unattended.
  command 'fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update" < /dev/null'
  not_if "test -f #{ENV['HOME']}/.config/fish/functions/fisher.fish"
end
