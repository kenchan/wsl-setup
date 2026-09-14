define :aur_package do
  execute "paru -S #{params[:name]}" do
    # paru aborts when run as root; su - gives it the build user's HOME and PATH.
    command %Q(su - #{ENV['SUDO_USER']} -c "paru -S --noconfirm --needed #{params[:name]}")
    not_if "pacman -Q #{params[:name]} > /dev/null 2>&1"
  end
end
