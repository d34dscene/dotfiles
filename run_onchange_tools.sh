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
    stylua
    oha
    xh
)

if check "pip"; then
    for tool in "${py_tools[@]}"; do
        pip install --upgrade "$tool"
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
    corepack enable
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
            cargo install "$tool"
        fi
    done
fi

if check "go"; then
    go_tools=(
        github.com/Gelio/go-global-update
        honnef.co/go/tools/cmd/staticcheck
        github.com/google/yamlfmt/cmd/yamlfmt
        mvdan.cc/sh/v3/cmd/shfmt
        golang.org/x/tools/cmd/goimports
        github.com/fatih/gomodifytags
        github.com/ssut/payload-dumper-go
        github.com/mr-karan/doggo/cmd/doggo
        github.com/derailed/k9s
        github.com/muesli/duf
        github.com/google/ko
    )

    for tool in "${go_tools[@]}"; do
        binary_name=$(basename "$tool")
        check "$binary_name" || go install "$tool@latest"
    done
fi
