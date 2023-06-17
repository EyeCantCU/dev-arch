distrobox-enter -n dev-arch -- '  paru -S aur/android-studio --noconfirm'
distrobox-enter -n dev-arch -- '  distrobox-export --app android-studio'

distrobox-enter -n dev-arch -- '  paru -S aur/clion --noconfirm'
distrobox-enter -n dev-arch -- '  distrobox-export --app clion'

distrobox-enter -n dev-arch -- '  paru -S aur/intellij-idea-ultimate-edition --noconfirm'
distrobox-enter -n dev-arch -- '  paru -S aur/intellij-idea-ultimate-edition-jre --noconfirm'
distrobox-enter -n dev-arch -- '  distrobox-export --app intellij-idea-ultimate-edition'

distrobox-enter -n dev-arch -- '  paru -S aur/pycharm-professional --noconfirm'
distrobox-enter -n dev-arch -- '  distrobox-export --app pycharm'

distrobox-enter -n dev-arch -- '  yes | paru -Sccd'
