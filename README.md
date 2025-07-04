# Project Nebuletta

> _The seed of a cloud-borne civilization,  
> shaped in code, summoned into existence._

## Introduction

**Nebuletta** is an experimental Infrastructure-as-Code (IaC) project designed to rapidly provision self-managed cloud infrastructure using [Terraform](https://www.terraform.io/) on public cloud platforms.

This project is built with **AWS** as the default cloud provider. It includes a set of composable, self-contained modules that can be flexibly assembled based on different deployment scenarios.

To manage orchestration, **[Terramate](https://terramate.io/)** is used instead of introducing additional domain-specific frameworks like Terragrunt. This choice keeps the entire infrastructure stack purely in Terraform's native language, ensuring simplicity and consistency.
  
The project documentation is maintained in a separate repository, [click here to view the documentation](https://github.com/nekowanderer/nebuletta-notes).

## Prerequisites

### Required Tools
- AWS CLI (>= 2.27.16) installed on your local machine
- Terraform (>= 1.11.4)
- Terramate (>= 0.13.1)

### Required Providers
- AWS Provider (~> 5.97)
- Random Provider (~> 3.1.0)

### Required Access
- An AWS account with sufficient permissions/roles/policies for executing the tasks defined in the Terraform scripts

## How It Works

```shell
.
└── terraform
    ├── modules
    │   ├── compute
    │   │   ├── ec2
    │   │   │   ├── private
    │   │   │   └── public
    │   │   └── fargate
    │   │       ├── service
    │   │       └── task
    │   ├── networking
    │   ├── random-id-generator
    │   └── state-storage
    └── stacks
        └── dev
        │   ├── compute
        │   │   └── ec2
        │   │       ├── private
        │   │       └── public
        │   ├── networking
        │   └── state-storage
        └── random-id-generator
```

In this project, Terramate stacks are defined under the `terraform/stacks` folder. For example, `dev`/`staging`/`production` folders represent dedicated stacks/environments that leverage the modules under the `terraform/modules` folder. 

You can compose the stack according to your requirements by adding different subfolders under the specific stack folder and writing the appropriate `stack.tm.hcl` file for each module.

## Basic Commands

### List Stacks
Navigate to the project root and execute:
```shell
terramate list
```
This will show you the stacks that exist in this project.

### Create a new stack
Please adjust the path in the following command according to your current path:
```shell
terramate create path/to/stack
```
This will help to generate the `stack.tm.hcl` under the created stack folder.

### Generate .tf Files for Stacks
Navigate to the project root and execute:
```shell
terramate generate
```
This will generate all the Terraform files defined in the stack.tm.hcl for each stack.

### Initialize the Project
Navigate to the project root or the specific stack you would like to initialize, and execute:
```shell
terramate run --tags networking -- terraform init
```

⚠️ **Warning**: For init/plan/apply via Terramate, ensure you don't have any unstaged changes in your version control system (like Git). Otherwise, you'll see a message like:

```
On branch xxx
Your branch is up to date with 'origin/xxx'.

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   unstaged_file
```

For this situation, please stage/commit the changes first before continuing.

### Plan a Specific Stack
It's a good practice to plan stacks by tags. For example, to plan the networking module, execute the following command under the project root:
```shell
terramate run --tags networking -- terraform plan
```
This is equivalent to performing the `terraform plan` command under the networking module independently.

### Apply a Specific Stack
Similar to the plan command, to apply the networking module, execute the following command under the project root:
```shell
terramate run --tags networking -- terraform apply
```
This is equivalent to performing the `terraform apply` command under the networking module independently.

You'll then see the following message in the terminal:
```shell
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

Type `yes` if you're sure all the planned resources meet your requirements. Otherwise, cancel the apply operation by typing any other word and adjust the script.

After the apply operation, check the message which should look like:
```shell
Apply complete! Resources: xx added, 0 changed, 0 destroyed.

Outputs:

...
...
...
```

Verify that all resources are arranged as desired.

### Destroy a Specific Stack
Again, using the networking module as an example, to destroy it, execute:
```shell
terramate run --tags networking -- terraform destroy
```
This is equivalent to performing the `terraform destroy` command under the networking module independently.

Like the apply operation, it will prompt for confirmation before destroying the specified resources. Type `yes` if you have carefully reviewed the details.

After the destroy operation, check the message and log into your public cloud interface (like AWS Console) to double-check the resource allocation status.

### Install Oh-My-Zsh on AWS EC2 Instance

```bash
sudo yum update

sudo yum -y install zsh util-linux-user git curl wget

sudo chsh -s $(which zsh) $(whoami)

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

```

Update `~/.zshrc`:
```bash

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

DEFAULT_USER="clu"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir dir_writable vcs prompt_char)
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1

plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export USER=ssm-user

alias refresh='source ~/.zshrc'
alias kubectl='minikube kubectl -- '
alias start_docker='sudo service docker start'
alias start_minikube='minikube start --driver docker'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
```
