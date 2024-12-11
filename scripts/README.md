Installation scripts should be started in next sequence:
  1. `install_base_software.sh`
  2. `install_compilers.sh`
  3. `install_dev_software.sh`
  4. `install_golang.sh`
  5. `install_rust.sh` (do not run as root)
  6. `build_cmake.sh`
  7. `build_cppcheck.sh`
  8. `build_ctags.sh`
  9. `build_vim.sh`
 10. `set_settings.sh` (do not run as root)


__NOTE:__ build_* scripts doesn't install anything, they are building deb
packages that you can later install with `dpkg`. You can find them in
[packages dir](../packages)
