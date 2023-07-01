# dev-arch

[![build-dev-arch](https://github.com/EyeCantCU/dev-arch/actions/workflows/build.yml/badge.svg)](https://github.com/EyeCantCU/dev-arch/actions/workflows/build.yml)

These images are not meant to be used as a host operating system. Please see [BlueWhaleOS](https://github.com/eyecantcu/BlueWhaleOS/) for more information.

## Usage

If you use distrobox:

    distrobox create -i ghcr.io/eyecantcu/dev-arch -n dev-arch
    distrobox enter dev-arch

If you use toolbox:

    toolbox create -i ghcr.io/eyecantcu/dev-arch -c dev-arch
    toolbox enter dev-arch

## Verification

These images are signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/overview/). You can verify the signature by downloading the `cosign.pub` key from this repo and running the following command:

    cosign verify --key cosign.pub ghcr.io/eyecantcu/dev-arch
