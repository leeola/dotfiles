# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix flake-based dotfiles repository that manages system configurations for multiple machines (Linux/NixOS and macOS with nix-darwin).

## Architecture

The repository uses Nix flakes to declaratively configure entire systems:

- **`flake.nix`**: Main entry point defining all system configurations
- **`system/`**: Machine-specific configurations
  - Each machine has `configuration.nix` (system-level) and `home.nix` (user-level)
  - `desk`: Linux desktop with NVIDIA GPU
  - `closet`: Linux server
  - `mbp2023`: MacBook Pro M2
- **`home/`**: Shared home-manager modules
  - `term.nix`: Terminal tools and configs (linked to dotfiles)
  - `gui.nix`: GUI applications
- **Application configs**: Individual directories for each tool (helix, tmux, fish, etc.)

Configuration files in `home/<name>.nix.file` are symlinked to their expected locations at build time.

## Important Warnings

- Do not run any nix switching command. Ever.

## Build Commands

- Always use nixfmt before considering a change to `.nix` files done.
- Use `nix build .#` to build the default system configuration
- Use `nix build .#<system_name>` to build a specific system configuration
- Always use build commands to test configurations before considering them done
- Build nix on mac with `nix run nix-darwin -- build --flake .#mbp2023`
