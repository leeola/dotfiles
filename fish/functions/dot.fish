# A convenience wrapper for dotfiles-related commands.
#
# Usage:
#   dot --help         # Show help information
#   dot build          # Builds system config for current platform
#   dot switch         # Applies system config for current platform
function dot
    # Check for subcommand
    if test (count $argv) -eq 0
        echo "Error: No subcommand specified. Try 'dot --help' for usage information."
        return 1
    end

    # Handle subcommands
    switch $argv[1]
        case build
            # Platform-specific build command
            if test (uname) = Darwin
                echo "Building Darwin configuration..."
                # Using hardcoded hostname 'mbp2023' due to known issue where
                # hostname isn't being properly set from nix on macOS - to fix in future
                nix run nix-darwin -- build --flake .#mbp2023
            else
                echo "Building NixOS configuration..."
                nixos-rebuild build --flake .
            end
        case switch
            # Platform-specific switch command
            if test (uname) = Darwin
                echo "Switching Darwin configuration..."
                # Using hardcoded hostname 'mbp2023' due to known issue where
                # hostname isn't being properly set from nix on macOS - to fix in future
                nix run nix-darwin -- switch --flake .#mbp2023
            else
                echo "Switching NixOS configuration..."
                nixos-rebuild switch --flake .
            end
        case --help
            echo "dot: Dotfiles convenience commands"
            echo ""
            echo "Available subcommands:"
            echo "  build    - Build configuration for current platform"
            echo "             (nixos-rebuild on Linux, nix-darwin on macOS)"
            echo "  switch   - Apply configuration for current platform"
            echo "             (nixos-rebuild on Linux, nix-darwin on macOS)"
            echo ""
            echo "For standard nix commands, use the regular nix command:"
            echo "  nix flake update"
            echo "  nix shell nixpkgs#python"
            return 0
        case '*'
            echo "Unknown subcommand: $argv[1]"
            echo "Run 'dot --help' without arguments for help"
            return 1
    end
end
