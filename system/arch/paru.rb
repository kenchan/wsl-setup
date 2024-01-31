git 'https://aur.archlinux.org/paru.git' do
  user ENV['SUDO_USER']
  destination '/tmp/paru'
  repository 'https://aur.archlinux.org/paru.git'
  notifies :run, 'execute[makepkg -si --noconfirm]', :immediately
  not_if 'command -v paru > /dev/null'
end

execute 'makepkg -si --noconfirm' do
  action :nothing
  user ENV['SUDO_USER']
  cwd '/tmp/paru'
end

module Paru
  def check_is_installed(package,version=nil)
    if version
      grep = version.include?('-') ? "^#{escape(version)}$" : "^#{escape(version)}-"
      "paru -Q #{escape(package)} | awk '{print $2}' | grep '#{grep}'"
    else
      "paru -Q #{escape(package)} || paru -Qg #{escape(package)}"
    end
  end

  def get_version(package, opts=nil)
    "paru -Qi #{package} | grep Version | awk '{print $3}'"
  end

  def install(package, version=nil, option='')
    "paru -S --noconfirm #{option} #{package}"
  end

  def sync_repos
    "paru -Syy"
  end

  def remove(package, option='')
    "pacman -R --noconfirm #{option} #{package}"
  end
end

Specinfra::Command::Arch::Base::Package.extend Paru
