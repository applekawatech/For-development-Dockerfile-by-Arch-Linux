#!/bin/bash

# Function to create a new user interactively
create_user() {
    echo "Creating a new user"
    read -p "Enter username: " USERNAME
    read -s -p "Enter password: " PASSWORD
    echo
    useradd -m -G wheel "$USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd
    echo "$USERNAME ALL=(ALL) ALL" >> /etc/sudoers
    echo "User $USERNAME has been created"
}

# Function to set up Git credentials
setup_git_credentials() {
    read -p "Enter Git username: " GIT_USERNAME
    read -s -p "Enter Git password or API key: " GIT_PASSWORD
    echo

    # Set up Git credential store
    git config --global credential.helper store
    echo "https://$GIT_USERNAME:$GIT_PASSWORD@github.com" > /home/$USERNAME/.git-credentials
    echo "https://$GIT_USERNAME:$GIT_PASSWORD@gitlab.com" >> /home/$USERNAME/.git-credentials
    chmod 600 /home/$USERNAME/.git-credentials
    chown $USERNAME:$USERNAME /home/$USERNAME/.git-credentials

    echo "Git credentials have been securely stored"
}

# Function to clone a Git repository
clone_repository() {
    read -p "Enter Git repository URL: " REPO_URL

    # Extract repository name from URL
    REPO_NAME=$(basename -s .git "$REPO_URL")

    # Clone the repository
    cd /workspace
    sudo -u $USERNAME git clone "$REPO_URL"

    echo "Repository $REPO_NAME has been cloned to /workspace/$REPO_NAME"
}

# Check if a user has been created
if [ ! -f /etc/user_created ]; then
    create_user
    touch /etc/user_created
else
    USERNAME=$(ls /home | head -n1)
    echo "Using existing user: $USERNAME"
fi

# Check if Git credentials have been set up
if [ ! -f /home/$USERNAME/.git-credentials ]; then
    setup_git_credentials
else
    echo "Git credentials already set up"
fi

# Check if a repository has been cloned
if [ ! -f /workspace/.repo_cloned ]; then
    clone_repository
    touch /workspace/.repo_cloned
else
    echo "Repository already cloned"
fi

# Start VS Code Server as the created user
exec sudo -u $USERNAME code-server --bind-addr 0.0.0.0:8080 --auth none /workspace
