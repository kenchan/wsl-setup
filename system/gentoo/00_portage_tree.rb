package 'dev-vcs/git'
package 'eselect-repository'

execute 'convert portage tree to git' do
  command <<-EOS
    eselect repository remove gentoo &&
    eselect repository enable gentoo &&
    rm -r /var/db/repos/gentoo &&
    emaint sync -r gentoo
  EOS

  not_if 'test -d /var/db/repos/gentoo/.git'
end
