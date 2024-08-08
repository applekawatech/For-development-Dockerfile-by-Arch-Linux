#!/bin/bash

# ネットワークインターフェースを取得（Wi-Fi、Ethernet、WWAN）
interface=$(ip route | grep default | awk '{print $5}' | head -n1)

if [ -n "$interface" ]; then
    # IPアドレスを取得
    ip_address=$(ip addr show $interface | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
    
    # Wi-Fiの場合、SSIDも取得
    if [[ $interface == wl* ]]; then
        ssid=$(iwgetid -r)
        echo "$ssid ($ip_address)"
    # WWANの場合
    elif [[ $interface == wwan* ]]; then
        echo "WWAN ($ip_address)"
    else
        echo "$interface ($ip_address)"
    fi
else
    echo "Not connected"
fi
