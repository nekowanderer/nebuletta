#!/bin/bash
set -e

USER=ssm-user

if [ "$(whoami)" != "$USER" ]; then
  echo "Please run this script as ssm-user!"
  exit 1
fi

# Install essential packages
sudo yum update -y
sudo yum -y install zsh util-linux-user git curl wget

# Set zsh as default shell
sudo chsh -s $(which zsh) $USER

# Install Oh My Zsh (without auto-launching zsh)
export RUNZSH=no
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Set ZSH_CUSTOM path
export ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install theme and plugins
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-completions.git $ZSH_CUSTOM/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Automatically update .zshrc for theme and plugins
ZSHRC="$HOME/.zshrc"
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
  sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
else
  echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
fi

if grep -q '^plugins=' "$ZSHRC"; then
  sed -i 's/^plugins=.*/plugins=(git zsh-completions zsh-syntax-highlighting zsh-autosuggestions)/' "$ZSHRC"
else
  echo 'plugins=(git zsh-completions zsh-syntax-highlighting zsh-autosuggestions)' >> "$ZSHRC"
fi

echo
echo "✅ Zsh and plugins installed! .zshrc has been updated for theme and plugins."
echo "Please log out and log back in to use zsh as your default shell."
