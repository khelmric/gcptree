#!/bin/bash

INSTALL_DIR="$HOME/.gcptree"

if [ ! -d "$INSTALL_DIR" ]; then
    git clone https://github.com/khelmric/gcptree.git "$INSTALL_DIR"
else
    echo "Directory $INSTALL_DIR already exists. Pulling latest changes."
    cd "$INSTALL_DIR" && git pull
fi

chmod +x "$INSTALL_DIR/gcptree.sh"

mkdir -p "$INSTALL_DIR/bin"

ln -sf "$INSTALL_DIR/gcptree.sh" "$INSTALL_DIR/bin/gcptree"

if ! grep -q "$INSTALL_DIR/bin" <<< "$PATH"; then
    echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$HOME/.bashrc"
    echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$HOME/.zshrc"
    echo "export PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$HOME/.profile"
    echo "Added $INSTALL_DIR/bin to PATH. Please run 'source ~/.bashrc' or 'source ~/.zshrc' or 'source ~/.profile' to update your PATH."
else
    echo "$INSTALL_DIR/bin is already in your PATH."
fi

echo ""
echo "Installation complete. You can now use the 'gcptree' command."
echo ""
echo "gcptree <ORGANIZATION_ID OR FOLDER_ID> [-v]"
echo ""