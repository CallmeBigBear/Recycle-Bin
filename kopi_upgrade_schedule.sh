#!/bin/bash
# Automate Kopi Upgrade by NodesVault
clear
printf "\033[91mMADE BY NODESVAULT\033[0m"
read -p "

Script share vì cộng đồng. Có thể có rủi ro tiềm ẩn chưa kiểm soát.
Nhấn "y" để tiếp tục, hoặc phím bất kỳ để thoát: " confirm
if [[ $confirm != [yY] ]]; then
  echo "Aborting script."
  exit 1
fi
if command -v jq &> /dev/null; then
    echo "jq installed"
else
    echo "Installing jq..."
    apt update && apt install jq -y
fi
wget -O kopid https://github.com/kopi-money/kopi/releases/download/v9/kopid-v9-linux-amd64 && chmod +x kopid
rpc_port=$(grep -m 1 -oP '^laddr = "\K[^"]+' "$HOME/.kopid/config/config.toml" | cut -d ':' -f 3)
kopiloc=$(which kopid)
while :
do
  [ $(curl -s localhost:$rpc_port/status | jq -r .result.sync_info.latest_block_height) -ge 3938000 ] && mv kopid $kopiloc && systemctl restart kopid && break
  sleep 10
done
