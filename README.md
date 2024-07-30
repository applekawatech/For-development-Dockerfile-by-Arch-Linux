# For-development-Dockerfile-by-Arch-Linux

## English

## Overview
This project provides a Dockerfile to create a development environment based on Arch Linux. It includes Anaconda, yay (AUR helper), and Visual Studio Code Server. The setup allows for interactive user creation, secure Git credential storage, and automatic repository cloning on the first boot.

## Features
- Arch Linux base environment
- Anaconda installation via yay
- Visual Studio Code Server setup
- Interactive user creation on the first boot
- Secure storage of Git credentials
- Automatic cloning of a Git repository on the first boot
- Persistent data storage using Docker volumes

## Usage
1. **Build the Docker image:**
   ```bash
   docker build -t arch-anaconda-vscode .
   ```

2. **Run the Docker container with a specific name:**
   ```bash
   docker run -it --name my-container-name -p 8080:8080 \
     -v $(pwd)/workspace:/workspace \
     -v arch-anaconda-vscode-data:/home \
     arch-anaconda-vscode
   ```

3. **Access Visual Studio Code Server:**
   Open a web browser and navigate to `http://localhost:8080`.

4. **First boot:**
   - You will be prompted to create a new user.
   - You will be prompted to enter Git credentials and a repository URL to clone.

---
## Japanese

## 概要
このプロジェクトは、Arch Linuxをベースにした開発環境を作成するためのDockerfileを提供します。Anaconda、yay（AURヘルパー）、およびVisual Studio Code Serverが含まれています。このセットアップにより、初回起動時に対話的なユーザー作成、Git認証情報の安全な保存、およびリポジトリの自動クローンが可能です。

## できること
- Arch Linuxベースの環境
- yayを使用したAnacondaのインストール
- Visual Studio Code Serverのセットアップ
- 初回起動時の対話的なユーザー作成
- Git認証情報の安全な保存
- 初回起動時のGitリポジトリの自動クローン
- Dockerボリュームを使用したデータの永続化

## 使い方
1. **Dockerイメージをビルド:**
   ```bash
   docker build -t arch-anaconda-vscode .
   ```

2. **特定の名前でDockerコンテナを実行:**
   ```bash
   docker run -it --name my-container-name -p 8080:8080 \
     -v $(pwd)/workspace:/workspace \
     -v arch-anaconda-vscode-data:/home \
     arch-anaconda-vscode
   ```

3. **Visual Studio Code Serverにアクセス:**
   ウェブブラウザを開き、`http://localhost:8080`にアクセスします。

4. **初回起動:**
   - 新しいユーザーを作成するように求められます。
   - Gitの認証情報とクローンするリポジトリのURLを入力するように求められます。
