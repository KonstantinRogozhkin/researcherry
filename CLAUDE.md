# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ResearcherryAI is a fork of VSCode/VSCodium designed as a platform for creating AI agents focused on customer research. The project is primarily in Russian and targets researchers and product teams who want to build AI agents for analyzing customer communications, interviews, and product research.

## Development Commands

### Build Commands

**Development Build:**
```bash
./dev/build.sh                    # Standard development build
./dev/build.sh -i                 # Build insider version
./dev/build.sh -l                 # Build with latest VSCode version
./dev/build.sh -o                 # Skip build step
./dev/build.sh -p                 # Generate packages/assets/installers
./dev/build.sh -s                 # Skip source retrieval
```

**CI/Production Build:**
```bash
export SHOULD_BUILD="yes"
export CI_BUILD="no"
export OS_NAME="linux"           # or "osx", "windows"
export VSCODE_ARCH="x64"         # or "arm64"
export VSCODE_QUALITY="stable"   # or "insider"
. get_repo.sh
. build.sh
```

**Build Environment Setup:**
```bash
./prepare_vscode.sh              # Prepare VSCode source with patches
./version.sh                     # Set version variables
```

### Icon and Asset Management
```bash
./icons/build_icons.sh           # Build application icons
./icons/build_researcherry_icons.sh  # Build Researcherry-specific icons
./clear_icon_cache.sh            # Clear system icon cache
./update_icon.sh                 # Update icons across the project
```

### Patch Management
```bash
./dev/patch.sh <patch-name>      # Apply specific patch manually
./dev/update_patches.sh          # Update all patches (semi-automated)
```

## Architecture

### Core Components

**Base Architecture:**
- Built on VSCode/VSCodium foundation
- Customized for research workflows
- Russian localization built-in
- Custom branding and welcome pages

**Key Directories:**
- `src/stable/` - Stable version resources and customizations
- `src/insider/` - Insider version resources
- `src/profiles/` - User profiles (researcher.code-profile, developer.code-profile)
- `patches/` - All patches applied to VSCode base
- `icons/` - Application icons and branding assets
- `docs/` - Russian documentation

**Profile System:**
The project includes a built-in profile system with two predefined profiles:
- **Researcher Profile**: Simplified interface for non-technical researchers
- **Developer Profile**: Full development environment

### Patch System

The project uses an extensive patch system to customize VSCode:

**Core Patches:**
- `brand.patch` - Rebranding from VSCode to Researcherry
- `profiles.patch` / `profiles-feature.patch` - User profile functionality
- `force-russian-locale.patch` - Russian localization
- `researcherry-welcome-page.patch` - Custom welcome page
- `disable-cloud.patch` - Remove Microsoft cloud features
- `chat.patch` - Custom chat/AI features

**Platform-specific patches:**
- `linux/` - Linux-specific modifications
- `osx/` - macOS-specific modifications  
- `windows/` - Windows-specific modifications

### Build Process

1. **Source Preparation:** `get_repo.sh` downloads VSCode source
2. **Patching:** `prepare_vscode.sh` applies all patches in sequence
3. **Compilation:** `build.sh` compiles with customizations
4. **Asset Generation:** Icon and installer creation

## Important Notes

- The project is primarily developed in Russian
- Built on VSCodium (open-source VSCode) rather than Microsoft VSCode
- Uses Open VSX Registry instead of Visual Studio Marketplace
- Custom user profiles are a key differentiator
- Extensive patch system requires careful management when updating VSCode base

## Dependencies

- Node.js 20.18
- Python 3.11
- Git, jq, rustup
- Platform-specific build tools (see docs/howto-build.md)

## Testing

- Use `npm run watch` during development
- Run `./script/code.sh` to test the application
- Verify patches work after VSCode updates