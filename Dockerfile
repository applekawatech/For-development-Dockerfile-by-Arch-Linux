# Use Arch Linux as the base image
FROM archlinux:latest

# Update the system and install necessary packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm base-devel git sudo curl

# Create a non-root user for building packages
RUN useradd -m -G wheel builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install yay (AUR helper)
RUN su - builder -c "git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm"

# Configure pacman to be similar to standard Arch Linux
RUN sed -i 's/#Color/Color/' /etc/pacman.conf && \
    sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf && \
    sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf

# Update the system after pacman configuration changes
RUN pacman -Syu --noconfirm

# Install Miniconda using yay
RUN su - builder -c "yay -S --noconfirm miniconda3"

# Initialize Miniconda
RUN echo 'source /opt/miniconda3/bin/activate' >> /etc/bash.bashrc

# Install Visual Studio Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a workspace directory
RUN mkdir /workspace
WORKDIR /workspace

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose VS Code Server port
EXPOSE 8080

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
