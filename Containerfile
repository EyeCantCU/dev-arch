FROM docker.io/library/archlinux:latest

# Support nvidia-container-toolkit
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all

# Pacman Initialization
RUN sed -i 's/#Color/Color/g' /etc/pacman.conf && \
    printf "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" | tee -a /etc/pacman.conf && \
    sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/g' /etc/makepkg.conf && \
    pacman -Syu --noconfirm && \
    pacman -S \
        wget \
        base-devel \
        git \
        --noconfirm

# Create build user
RUN useradd -m --shell=/bin/bash build && usermod -L build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Distrobox Integration
USER build
WORKDIR /home/build
RUN git clone https://github.com/KyleGospo/xdg-utils-distrobox-arch.git --single-branch && \
    cd xdg-utils-distrobox-arch/trunk && \
    makepkg -si --noconfirm && \
    cd ../.. && \
    rm -drf xdg-utils-distrobox-arch
USER root
WORKDIR /
RUN git clone https://github.com/89luca89/distrobox.git --single-branch && \
    cp distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/firefox && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O distrobox/host-spawn && \
    cp distrobox/host-spawn /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf distrobox

# Install needed packages
RUN pacman -S \
        vulkan-radeon \
        lib32-vulkan-radeon \
        libva-mesa-driver \
        intel-media-driver \
        openal \
        pipewire \
        pipewire-pulse \
        pipewire-alsa \
        pipewire-jack \
        wireplumber \
        lib32-pipewire \
        lib32-pipewire-jack \
        lib32-libpulse \
        lib32-openal \
        --noconfirm && \
    pacman -S \
        bat \
        cosign \
        exa \
        fd \
        ghidra \
        glib2 \
        gdb \
        icu69 \
        ksshaskpass \
        libdbusmenu-glib \
        micro \
        nano \
        npm \
        org.freedesktop.secrets \
        skopeo \
        yarn \
        zsh \
        --noconfirm

# Add paru and install AUR packages
USER build
WORKDIR /home/build
RUN git clone https://aur.archlinux.org/paru-bin.git --single-branch && \
    cd paru-bin && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -drf paru-bin && \
    paru -S \
        aur/visual-studio-code-bin \
        --noconfirm
USER root
WORKDIR /

# Native march & tune. This is a gaming image and not something a user is going to compile things in with the intent to share.
# We do this last because it'll only apply to updates the user makes going forward. We don't want to optimize for the build host's environment.
RUN sed -i 's/-march=x86-64 -mtune=generic/-march=native -mtune=native/g' /etc/makepkg.conf

# Install git-peek
RUN npm install -g @jarred/git-peek

# Cleanup
RUN userdel -r build && \
    rm -drf /home/build && \
    sed -i '/build ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf \
        /tmp/* \
	/var/cache/pacman/pkg/*
