# opencode-nix

Always up-to-date Nix package for [OpenCode](https://github.com/anomalyco/opencode) - AI-powered coding assistant in your terminal.

**Automatically updated hourly** to ensure you always have the latest OpenCode version.

## Why this package?

### Primary Goal: Always Up-to-Date OpenCode for Nix Users

This flake provides immediate access to the latest OpenCode versions with:

1. **Hourly Automated Updates**: New OpenCode versions available within 1 hour of release
2. **Dedicated Maintenance**: Focused repository for quick fixes when OpenCode changes
3. **Flake-First Design**: Direct flake usage with Cachix binary cache
4. **Pre-built Binaries**: Multi-platform builds (Linux & macOS) cached for instant installation
5. **Node.js 22 LTS**: Latest long-term support version for better performance and security

### Why Not Just Use npm Global?

While `npm install -g opencode-ai` works, it has critical limitations:
- **Disappears on Node.js Switch**: When projects use different Node.js versions (via asdf/nvm), OpenCode becomes unavailable
- **Must Reinstall Per Version**: Need to install OpenCode separately for each Node.js version
- **Not Declarative**: Can't be managed in your Nix configuration
- **Not Reproducible**: Different Node.js versions can cause inconsistencies
- **Outside Nix**: Doesn't integrate with Nix's dependency management

**Example Problem**: You're working on a legacy project that uses Node.js 16 via asdf. When you switch to that project, your globally installed OpenCode (from Node.js 22) disappears from your PATH. This flake solves this by bundling Node.js with OpenCode.

### Comparison Table

| Feature | npm global | This Flake |
|---------|------------|------------|
| **Latest Version** | Always | Hourly checks |
| **Node.js Version** | Per Node install | Node.js 22 LTS |
| **Survives Node Switch** | Lost on switch | Always available |
| **Binary Cache** | None | Cachix |
| **Declarative Config** | None | Yes |
| **Version Pinning** | Manual | Flake lock |
| **Update Frequency** | Immediate | <= 1 hour |
| **Reproducible** | No | Yes |
| **CI/CD Ready** | No | Yes |

## Quick Start

### Fastest Installation (Try it now!)

```bash
# Run OpenCode directly without installing
nix run github:nklmilojevic/opencode-nix
```

### Install to Your System

```bash
# Using nix profile (recommended for Nix 2.4+)
nix profile install github:nklmilojevic/opencode-nix

# Or using nix-env (legacy)
nix-env -if github:nklmilojevic/opencode-nix
```

### Optional: Enable Binary Cache for Faster Installation

To download pre-built binaries instead of compiling:

```bash
# Install cachix if you haven't already
nix-env -iA cachix -f https://cachix.org/api/v1/install

# Add the opencode-nix-cache cache
cachix use opencode-nix-cache
```

Or add to your Nix configuration:

```nix
{
  nix.settings = {
    substituters = [ "https://opencode-nix-cache.cachix.org" ];
    trusted-public-keys = [ "opencode-nix-cache.cachix.org-1:Wq9yk7XD0pg457w4D5HV2OJVj++tl70tfzde1SrfYX8=" ];
  };
}
```

## Using with Nix Flakes

### In your flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    opencode-nix.url = "github:nklmilojevic/opencode-nix";
  };

  outputs = { self, nixpkgs, opencode-nix }:
    let
      system = "x86_64-linux"; # or your system
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          opencode-nix.packages.${system}.default
        ];
      };
    };
}
```

### Using with NixOS

Add to your system configuration:

```nix
{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.opencode-nix.packages.${pkgs.system}.default
  ];
}
```

### Using with Home Manager

Add to your Home Manager configuration:

```nix
{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.opencode-nix.packages.${pkgs.system}.default
  ];
}
```

## Technical Details

### Package Architecture

Our custom `package.nix` implementation:

1. **Pre-fetches npm tarball**: Uses Nix's Fixed Output Derivation (FOD) for reproducible, offline builds
2. **Bundles Node.js 22 LTS**: Ensures consistent runtime environment across all systems
3. **Custom wrapper script**: Handles PATH, environment variables, and OpenCode-specific requirements
4. **Multi-platform builds**: CI builds and caches for both Linux and macOS
5. **Sandbox compatible**: All network fetching happens during the FOD phase, not build phase

### Runtime Environment

Currently using **Node.js 22 LTS** because:
- Long-term stability and support until April 2027
- Better performance than older Node.js versions
- Latest LTS with all security updates
- Consistent behavior across all platforms

### Features

- **Bundled Node.js Runtime**: Ships with Node.js v22 LTS for maximum compatibility
- **No Global Dependencies**: Works independently of system Node.js installations
- **Version Pinning**: Ensures consistent behavior across different environments
- **Offline Installation**: Pre-fetches npm packages for reliable builds
- **Auto-update Protection**: Prevents unexpected updates that might break your workflow
- **Cross-platform Support**: Pre-built binaries for Linux and macOS

## Development

```bash
# Clone the repository
git clone https://github.com/nklmilojevic/opencode-nix
cd opencode-nix

# Build locally
nix build

# Test the build
./result/bin/opencode --version

# Enter development shell
nix develop
```

## Updating OpenCode Version

### Automated Updates

This repository uses GitHub Actions to automatically check for new OpenCode versions hourly. When a new version is detected:

1. A pull request is automatically created with the version update
2. The tarball hash is automatically calculated
3. Tests run on both Linux and macOS to verify the build
4. The PR auto-merges if all checks pass

The automated update workflow runs:
- Every hour (on the hour) UTC
- On manual trigger via GitHub Actions UI

### Manual Updates

For manual updates:

1. Check for new versions:
   ```bash
   ./scripts/update.sh --check
   ```
2. Update to latest version:
   ```bash
   # Get the latest version number from the check above
   ./scripts/update.sh 1.1.28  # Replace with actual version
   ```
3. Test the build:
   ```bash
   nix build
   ./result/bin/opencode --version
   ```

### Push to Cachix manually
```bash
nix build .#opencode
cachix push opencode-nix-cache ./result
```

## Troubleshooting

### Command not found
Make sure the Nix profile bin directory is in your PATH:
```bash
export PATH="$HOME/.nix-profile/bin:$PATH"
```

### Permission issues on macOS

On macOS, OpenCode may ask for permissions after each Nix update because the binary path changes. To fix this:

1. Create a stable symlink:
   ```bash
   mkdir -p ~/.local/bin
   ln -sf $(which opencode) ~/.local/bin/opencode
   ```
2. Add `~/.local/bin` to your PATH
3. Always run `opencode` from `~/.local/bin/opencode`

The wrapper script sets a consistent executable path to help prevent macOS permission resets.

### SSL certificate errors
The package automatically configures SSL certificates from the Nix store.

## Repository Settings

This repository requires specific GitHub settings for automated updates. See [Repository Settings Documentation](.github/REPOSITORY_SETTINGS.md) for configuration details.

## License

This Nix packaging is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

OpenCode itself is licensed under the MIT License - see [OpenCode's repository](https://github.com/anomalyco/opencode) for details.

## Contributing

Contributions are welcome! Please submit pull requests or issues on GitHub.

## Related Projects

- [codex-cli-nix](https://github.com/sadjow/codex-cli-nix) - Similar packaging for OpenAI's Codex CLI
- [nixpkgs](https://github.com/NixOS/nixpkgs) - The Nix Packages collection
