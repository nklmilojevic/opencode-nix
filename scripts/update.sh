#!/usr/bin/env bash

set -euo pipefail

PACKAGE_FILE="package.nix"

# Platform mappings
declare -A PLATFORMS=(
    ["linux-x64"]="x86_64-linux"
    ["linux-arm64"]="aarch64-linux"
    ["darwin-x64"]="x86_64-darwin"
    ["darwin-arm64"]="aarch64-darwin"
)

usage() {
    echo "Usage: $0 [--check | <version>]"
    echo ""
    echo "Options:"
    echo "  --check     Check if a new version is available"
    echo "  <version>   Update to a specific version (e.g., 1.1.28)"
    echo ""
    echo "Examples:"
    echo "  $0 --check"
    echo "  $0 1.1.28"
    exit 1
}

get_current_version() {
    grep 'version = ' "$PACKAGE_FILE" | head -1 | cut -d'"' -f2
}

get_latest_version() {
    curl -s https://registry.npmjs.org/opencode-ai/latest | \
        sed -n 's/.*"version":"\([^"]*\)".*/\1/p'
}

update_hash_for_platform() {
    local nix_system="$1"
    local new_hash="$2"
    local file="$3"

    # Use awk to find the platform block and update the hash
    awk -v system="$nix_system" -v hash="$new_hash" '
        $0 ~ "\"" system "\" = \\{" { in_block = 1 }
        in_block && /sha256 = / {
            sub(/sha256 = "[^"]*"/, "sha256 = \"" hash "\"")
            in_block = 0
        }
        { print }
    ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
}

if [ $# -eq 0 ]; then
    usage
fi

if [ "$1" = "--check" ]; then
    CURRENT_VERSION=$(get_current_version)
    LATEST_VERSION=$(get_latest_version)

    echo "Current version: $CURRENT_VERSION"
    echo "Latest version:  $LATEST_VERSION"

    if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
        echo "Already up to date!"
        exit 0
    else
        echo "New version available: $LATEST_VERSION"
        echo "Run './scripts/update.sh $LATEST_VERSION' to update"
        exit 1
    fi
fi

VERSION="$1"

echo "Updating to OpenCode version $VERSION..."

# Fetch hashes for all platforms
declare -A HASHES

for platform in "${!PLATFORMS[@]}"; do
    nix_system="${PLATFORMS[$platform]}"
    echo "Fetching SHA256 hash for $platform ($nix_system)..."
    URL="https://registry.npmjs.org/opencode-${platform}/-/opencode-${platform}-${VERSION}.tgz"
    HASH=$(nix-prefetch-url "$URL" 2>/dev/null || echo "")

    if [ -z "$HASH" ]; then
        echo "Error: Could not fetch hash for $platform version $VERSION"
        echo "The package might not exist or the version might be incorrect"
        exit 1
    fi

    HASHES[$nix_system]="$HASH"
    echo "  $nix_system: $HASH"
done

echo ""
echo "Updating $PACKAGE_FILE..."

# Update version
sed -i.bak 's/version = "[^"]*"/version = "'"$VERSION"'"/' "$PACKAGE_FILE"
rm -f "${PACKAGE_FILE}.bak"

# Update each platform hash
for nix_system in "${PLATFORMS[@]}"; do
    update_hash_for_platform "$nix_system" "${HASHES[$nix_system]}" "$PACKAGE_FILE"
done

echo "Testing build..."
if nix build --no-link; then
    echo "Build successful!"
    echo ""
    echo "Version $VERSION has been successfully updated."
    echo "Don't forget to:"
    echo "  1. Test the new version: nix run . -- --version"
    echo "  2. Commit your changes"
    echo "  3. Push to GitHub"
else
    echo "Build failed. Please check the error messages above."
    exit 1
fi
