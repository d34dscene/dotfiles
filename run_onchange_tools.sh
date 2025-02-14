#!/bin/bash

# Helper for checking if binary is available
check() {
    command -v "$1" >/dev/null 2>&1
}

# Custom download function to get latest release
# ARGS: repository, match release name, output name
fetch() {
    URL="https://api.github.com/repos/${1}/releases/latest"
    MATCH="[.assets[] | select(.name | contains(\"${2}\")).browser_download_url][0]"
    LATEST=$(wget -qO- "${URL}" | jq -r "${MATCH}")
    EXTENSION="${LATEST##*.}"

    DLPATH="${HOME}/.local/bin"
    if [[ "${EXTENSION}" == "gz" ]]; then
        wget -O "${DLPATH}"/dl.tar.gz "${LATEST}"
        tar -xzf "${DLPATH}"/dl.tar.gz -C "${DLPATH}"
        rm "${DLPATH}"/dl.tar.gz
    elif [[ "${EXTENSION}" == "zip" ]]; then
        wget -O "${DLPATH}"/dl.zip "${LATEST}"
        unzip "${DLPATH}"/dl.zip -d "${DLPATH}"
        rm "${DLPATH}"/dl.zip
    else
        wget -O "${DLPATH}"/"${3}" "${LATEST}"
    fi

    # Cleanup
    chmod +x "${DLPATH}"/"${3}"
    rm -R -- */
    rm "${DLPATH}"/*.md "${DLPATH}"/LICENSE
}

py_tools=(
    mdformat
    codespell
)

node_tools=(
    prettier
    eslint_d
    corepack
    fixjson
    @fsouza/prettierd
)

rust_tools=(
    cargo-update
    cargo-cache
    topgrade
    rustscan
    stylua
    procs
    bat
    oha
    xh
)

if check "pip"; then
    for tool in ${py_tools[@]}; do
        pip install "$tool"
    done
fi

if check "npm"; then
    for tool in ${node_tools[@]}; do
        sudo npm install -g "$tool"
    done
    corepack enable
    corepack prepare pnpm@latest --activate
fi

if check "cargo"; then
    for tool in ${rust_tools[@]}; do
        cargo install "$tool"
    done
fi

if check "go"; then
    check "go-global-update" || go install github.com/Gelio/go-global-update@latest
    check "staticcheck" || go install honnef.co/go/tools/cmd/staticcheck@latest
    check "yamlfmt" || go install github.com/google/yamlfmt/cmd/yamlfmt@latest
    check "shfmt" || go install mvdan.cc/sh/v3/cmd/shfmt@latest
    check "goimports" || go install golang.org/x/tools/cmd/goimports@latest
    check "gomodifytags" || go install github.com/fatih/gomodifytags@latest
    check "payload-dumper-go" || go install github.com/ssut/payload-dumper-go@latest
    check "wormhole-william" || go install github.com/psanford/wormhole-william@latest
    check "flarectl" || go install github.com/cloudflare/cloudflare-go/cmd/flarectl@latest
    check "doggo" || go install github.com/mr-karan/doggo/cmd/doggo@latest
    check "k9s" || go install github.com/derailed/k9s@latest
    check "duf" || go install github.com/muesli/duf@latest
    check "ko" || go install github.com/google/ko@latest
fi
