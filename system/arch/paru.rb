BUILD_USER = ENV['SUDO_USER']
PARU_BUILD_DIR = '/tmp/paru-bootstrap'

execute 'build and install paru' do
  # makepkg refuses to run as root, so the whole bootstrap runs through a login
  # shell of the invoking user to get a writable HOME for its build cache.
  command <<-EOS
    rm -rf #{PARU_BUILD_DIR} &&
    su - #{BUILD_USER} -c "git clone --depth 1 https://aur.archlinux.org/paru.git #{PARU_BUILD_DIR} && cd #{PARU_BUILD_DIR} && makepkg -si --noconfirm" &&
    rm -rf #{PARU_BUILD_DIR}
  EOS
  not_if 'command -v paru > /dev/null'
end
