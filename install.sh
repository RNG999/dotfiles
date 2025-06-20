#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
GITHUB_USER="RNG999"
REPO_NAME="dotfiles"
BRANCH="main"
DOTFILES_DIR="$HOME/.dotfiles"

echo -e "${BLUE}🚀 Claude Configuration Installer${NC}"
echo -e "   GitHub: ${GITHUB_USER}/${REPO_NAME}"
echo -e "   Target: ${DOTFILES_DIR}"
echo ""


# Function to download file
download_file() {
    local url=$1
    local target=$2
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Download file
    if curl -fsSL "$url" -o "$target"; then
        echo -e "${GREEN}✓ Downloaded $(basename "$target")${NC}"
        return 0
    else
        echo -e "${RED}❌ Failed to download $(basename "$target")${NC}"
        return 1
    fi
}

# Check for required commands
for cmd in git curl; do
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}❌ Error: $cmd is not installed${NC}"
        exit 1
    fi
done

# Clone or update dotfiles repository
if [ -d "$DOTFILES_DIR/.git" ]; then
    echo -e "${BLUE}📂 Updating existing dotfiles repository...${NC}"
    cd "$DOTFILES_DIR" && git pull
else
    echo -e "${BLUE}📂 Cloning dotfiles repository...${NC}"
    if [ -d "$DOTFILES_DIR" ]; then
        echo -e "${YELLOW}⚠️  Removing existing $DOTFILES_DIR${NC}"
        rm -rf "$DOTFILES_DIR"
    fi
    git clone "https://github.com/${GITHUB_USER}/${REPO_NAME}.git" "$DOTFILES_DIR"
fi

# Install Claude configuration
echo ""
echo -e "${BLUE}📋 Installing Claude configuration...${NC}"

# Create ~/.claude directory if it doesn't exist
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.claude/commands"

# Function to copy file
copy_file() {
    local source=$1
    local target=$2
    
    # Remove existing file/link if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -f "$target"
    fi
    
    # Copy file
    cp "$source" "$target"
    echo -e "${GREEN}✓ Copied $(basename "$target")${NC}"
}

# Copy CLAUDE.md
if [ -f "$DOTFILES_DIR/.claude/CLAUDE.md" ]; then
    copy_file "$DOTFILES_DIR/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
else
    echo -e "${YELLOW}⚠️  CLAUDE.md not found in repository${NC}"
fi

# Copy command files
if [ -d "$DOTFILES_DIR/.claude/commands" ]; then
    for cmd_file in "$DOTFILES_DIR/.claude/commands"/*.md; do
        if [ -f "$cmd_file" ]; then
            filename=$(basename "$cmd_file")
            copy_file "$cmd_file" "$HOME/.claude/commands/$filename"
        fi
    done
else
    echo -e "${YELLOW}⚠️  No commands directory found in repository${NC}"
fi

echo ""
echo -e "${GREEN}✨ Installation complete!${NC}"
echo ""
echo "To update your configuration later, run:"
echo -e "  ${BLUE}curl -fsSL https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/${BRANCH}/install.sh | bash${NC}"