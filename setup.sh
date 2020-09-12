#!/bin/bash

echo "Adding VMware scripts for convenience..."

## Mount Shared Folders
file=/usr/local/sbin/mount-shared-folders
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
vmware-hgfsclient | while read folder; do
  echo "[i] Mounting \${folder}   (/mnt/hgfs/\${folder})"
  mkdir -p "/mnt/hgfs/\${folder}"
  umount -f "/mnt/hgfs/\${folder}" 2>/dev/null
  vmhgfs-fuse -o allow_other -o auto_unmount ".host:/\${folder}" "/mnt/hgfs/\${folder}"
done
sleep 2s
EOF
chmod +x "${file}"
ln -sf "${file}" /home/analyst/Desktop/mount-shared-folders.sh
chown analyst:analyst /home/analyst/Desktop/mount-shared-folders.sh

## Restart Open-VM-Tools
file=/usr/local/sbin/restart-vm-tools
cat <<EOF > "${file}" \
  || echo -e ' '${RED}'[!] Issue with writing file'${RESET} 1>&2
#!/bin/bash
killall -q -w vmtoolsd
vmware-user-suid-wrapper vmtoolsd -n vmusr 2>/dev/null
vmtoolsd -b /var/run/vmroot 2>/dev/null
EOF
chmod +x "${file}"
ln -sf "${file}" /home/analyst/Desktop/restart-vm-tools.sh
chown analyst:analyst /home/analyst/Desktop/restart-vm-tools.sh


echo "Preparing containers..."

docker pull chrisbensch/docker-manalyzer
docker pull chrisbensch/docker-plaso
docker pull chrisbensch/docker-volatility

echo "Complete"
