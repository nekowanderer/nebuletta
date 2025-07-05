#!/bin/bash
set -e

# Configurations
USER=ssm-user
AWS_REGION=
AWS_ACCOUNT=
AWS_SSO_START_URL=
AWS_SSO_ACCOUNT_NAME=
AWS_SSO_ROLE_NAME=
CLUSTER_NAME=my-cluster-001

if [ "$(whoami)" != "$USER" ]; then
  echo "Please run this script as ssm-user!"
  exit 1
fi

# Install essential packages
sudo yum update -y
sudo yum -y install zsh util-linux-user git curl wget jq

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

# Install kubectl
echo "Installing kubectl..."
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.33.0/2025-05-01/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin
mv ./kubectl $HOME/bin/kubectl

# Verify kubectl installation
export PATH=$PATH:$HOME/bin
if kubectl version --client; then
  echo "✅ kubectl installed successfully!"
else
  echo "❌ kubectl installation failed"
  exit 1
fi

# Install eksctl
echo "Installing eksctl..."
mkdir -p ~/tmp
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C ~/tmp
mv ~/tmp/eksctl $HOME/bin/eksctl
rm -rf tmp

# Verify eksctl installation
if eksctl version; then
  echo "✅ eksctl installed successfully!"
else
  echo "❌ eksctl installation failed"
  exit 1
fi

# Install Helm
echo "Installing Helm..."
curl -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f get_helm.sh  # Clean up script

# Verify Helm installation
if helm version; then
  echo "✅ Helm installed successfully!"
else
  echo "❌ Helm installation failed"
  exit 1
fi

# Update AWS CLI
echo "Updating AWS CLI..."
echo "Current AWS CLI version:"
aws --version || echo "AWS CLI not found"

# Remove old version and install latest
sudo rm -rf /usr/bin/aws
curl -o "awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/  # Clean up

# Verify AWS CLI installation
if aws --version; then
  echo "✅ AWS CLI updated successfully!"
else
  echo "❌ AWS CLI update failed"
  exit 1
fi

# Configure AWS CLI for SSO
echo "Configuring AWS CLI..."
mkdir -p ~/.aws

# Create AWS config file with SSO template
# Please uncomment the following code block and replace the variabkes with your actual values

# cat > ~/.aws/config << EOF
# [default]
# region = ${AWS_REGION}
# output = json

# [profile your-profile-name]
# sso_start_url = ${
# sso_region = ${AWS_REGION}
# sso_account_name = ${AWS_SSO_ACCOUNT_NAME}
# sso_account_id = ${AWS_ACCOUNT}
# sso_role_name = ${AWS_SSO_ROLE_NAME}
# region = ${AWS_REGION}
# credential_process = aws-sso-util credential-process --profile your-profile-name
# sso_auto_populated = true
# EOF

echo
echo "🔧 AWS CLI is ready for configuration."
echo "For IAM Identity Center (SSO), you have two options:"
echo "1. Use existing profile: aws sso login --profile your_profile_name"
echo "2. Or configure default profile with SSO settings in ~/.aws/config:"
echo "   [default]"
echo "   sso_start_url = https://your_domain.awsapps.com/start"
echo "   sso_region = ${AWS_REGION}"
echo "   sso_account_id = your_account_id"
echo "   sso_role_name = your_role_name"
echo "   region = ${AWS_REGION}"
echo "   Then run: aws sso login --profile default"
echo
echo "For AWS CLI configuration, you can run:"
echo "aws configure"
echo "AWS Access Key ID [None]: your_access_key_id"
echo "AWS Secret Access Key [None]: your_secret_access_key"
echo "Default region name [${AWS_REGION}]: ${AWS_REGION}"
echo "Default output format [json]: json"
echo

# Set environment variables for EKS
echo "Setting up environment variables..."
echo "export CLUSTER_NAME=${CLUSTER_NAME}" >> "$ZSHRC"
echo "export AWS_REGION=${AWS_REGION}" >> "$ZSHRC"
echo "export AWS_ACCOUNT=${AWS_ACCOUNT}" >> "$ZSHRC"

# Set for current session
export CLUSTER_NAME=${CLUSTER_NAME}
export AWS_REGION=${AWS_REGION}
export AWS_ACCOUNT=${AWS_ACCOUNT}

echo "✅ Environment variables set:"
echo "  CLUSTER_NAME=${CLUSTER_NAME}"
echo "  AWS_REGION=${AWS_REGION}"
echo "  AWS_ACCOUNT=${AWS_ACCOUNT}"
echo
echo "✅ Zsh and plugins installed! .zshrc has been updated for theme and plugins."
echo "✅ kubectl installed and configured!"
echo "✅ eksctl installed and configured!"
echo "✅ Helm installed and configured!"
echo "✅ AWS CLI updated successfully!"
echo
echo "📝 Note: After running 'p10k configure', you may need to add this to ~/.zshrc:"
echo "   export PATH=\$PATH:\$HOME/bin"
echo
echo "Please log out and log back in to use zsh as your default shell."
