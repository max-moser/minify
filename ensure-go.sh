#!/bin/sh
# Install the official Go toolchain inside the build container.
# The distro golang package is too old for go.mod (and Red Hat builds
# set GOTOOLCHAIN=local, blocking automatic toolchain downloads).
# Keep GO_VERSION >= the "go" directive in go.mod.
set -eu
GO_VERSION=1.26.10

case "$(uname -m)" in
    x86_64)  GOARCH=amd64 ;;
    aarch64) GOARCH=arm64 ;;
    i686|i386) GOARCH=386 ;;
    *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac

curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${GOARCH}.tar.gz" -o /tmp/go.tgz
rm -rf /usr/local/go
tar -C /usr/local -xzf /tmp/go.tgz
# symlink into PATH: env changes in this script don't reach the caller's shell
ln -sf /usr/local/go/bin/go /usr/local/bin/go
ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt
go version
