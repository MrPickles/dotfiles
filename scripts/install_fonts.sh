#!/bin/bash
set -euo pipefail

# Determine font directory based on OS
case "$(uname)" in
  "Darwin")
    FONT_DIR="$HOME/Library/Fonts"
    ;;
  "Linux")
    FONT_DIR="$HOME/.local/share/fonts"
    ;;
  *)
    echo "Unsupported OS: $(uname)" >&2
    exit 1
    ;;
esac

mkdir -p "$FONT_DIR"

URLS=(
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

for url in "${URLS[@]}"; do
  filename=$(basename "$url" | sed 's/%20/ /g')
  echo "Downloading $filename..."
  curl -fLo "$FONT_DIR/$filename" "$url"
done

# Refresh font cache on Linux
if [ "$(uname)" = "Linux" ]; then
  echo "Refreshing font cache..."
  fc-cache -f "$FONT_DIR"
fi

echo "Font installation complete."
