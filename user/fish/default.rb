execute 'fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update"' do
  not_if "test -f #{ENV['HOME']}/.config/fish/functions/fisher.fish"
end
