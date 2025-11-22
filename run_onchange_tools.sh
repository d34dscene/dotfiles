#!/usr/bin/env bash

set -euo pipefail

# Helper for checking if binary is available
check() {
   command -v "$1" >/dev/null 2>&1
}

py_tools=(
   mdformat
   codespell
   rsyncy
)

node_tools=(
   corepack
   @bufbuild/protoc-gen-es
)

rust_tools=(
   cargo-update
   cargo-cache
   stylua
   oha
   xh
)

if check "pipx"; then
   for tool in "${py_tools[@]}"; do
      if ! check "$tool"; then
         pipx install "$tool"
      fi
   done
fi

if check "npm"; then
   for tool in "${node_tools[@]}"; do
      if npm list -g "$tool" >/dev/null 2>&1; then
         sudo npm update -g "$tool"
      else
         sudo npm install -g "$tool"
      fi
   done
   corepack enable --install-directory "$HOME/.local/bin"
   corepack prepare pnpm@latest --activate
fi

if check "cargo"; then
   # Ensure cargo-update is installed first
   if ! check "cargo-install-update"; then
      cargo install cargo-update
   fi

   for tool in "${rust_tools[@]}"; do
      if cargo install --list | grep -q "^$tool "; then
         cargo install-update -a
      else
         if ! check "$tool"; then
            cargo install "$tool"
         fi
      fi
   done
fi

if check "go"; then
   go_tools=(
      github.com/Gelio/go-global-update
      github.com/google/yamlfmt/cmd/yamlfmt
      mvdan.cc/sh/v3/cmd/shfmt
      github.com/fatih/gomodifytags
      github.com/jondot/goweight
      github.com/ssut/payload-dumper-go
      github.com/mr-karan/doggo/cmd/doggo
      github.com/derailed/k9s
      github.com/muesli/duf
      github.com/google/ko
      golang.org/x/tools/cmd/deadcode
      github.com/sigstore/cosign/v3/cmd/cosign
      github.com/go-task/task/v3/cmd/task
      github.com/sqlc-dev/sqlc/cmd/sqlc
      github.com/bufbuild/buf/cmd/buf
      google.golang.org/protobuf/cmd/protoc-gen-go
      connectrpc.com/connect/cmd/protoc-gen-connect-go
      github.com/sudorandom/protoc-gen-connect-openapi
   )

   for tool in "${go_tools[@]}"; do
      binary_name=$(basename "$tool")
      ! check "$binary_name" || go install "$tool@latest"
   done
fi

# Random install scripts
if ! check "oh-my-posh"; then
   curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi
if ! check "grype"; then
   curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sudo sh -s -- -b /usr/local/bin
fi
