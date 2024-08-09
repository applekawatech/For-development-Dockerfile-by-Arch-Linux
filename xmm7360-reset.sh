#!/bin/bash

XMM7360_PATH="/path/to/xmm7360-pci"  # xmm7360-pciのパスを適切に設定してください
PCI_ADDRESS=""  # XMM7360のPCIアドレスを設定します（例: "0000:00:14.3"）

# PCIアドレスを動的に検出する関数
find_pci_address() {
    PCI_ADDRESS=$(lspci | grep -i "XMM7360" | cut -d' ' -f1)
    if [ -z "$PCI_ADDRESS" ]; then
        echo "Error: XMM7360 PCI device not found."
        exit 1
    fi
}

# モデムをリセットする関数
reset_modem() {
    echo "Resetting XMM7360 modem..."
    echo 1 > /sys/bus/pci/devices/${PCI_ADDRESS}/reset
    sleep 5  # リセット後の安定化を待つ
}

case $1 in
    post)
        echo "Resuming XMM7360 after sleep..."

        # PCIアドレスを検出
        find_pci_address

        # モジュールをロード（必要な場合）
        if ! lsmod | grep -q "xmm7360"; then
            echo "Loading xmm7360 module..."
            modprobe xmm7360
        fi

        echo "Waiting for modem to initialize..."
        sleep 10  # モデムの初期化を待つ（必要に応じて調整）

        # モデムをリセット
        reset_modem

        echo "Opening xdata channel..."
        python3 $XMM7360_PATH/scripts/open_xdatachannel.py

        echo "XMM7360 resume complete."
        ;;
    *)
        # スリープ前やその他のケースでは何もしない
        ;;
esac
