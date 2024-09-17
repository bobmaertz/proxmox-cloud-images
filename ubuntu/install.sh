#!/bin/sh


## References: https://austinsnerdythings.com/2023/01/10/proxmox-ubuntu-22-04-jammy-lts-cloud-image-script/
#
#

REPO="https://cloud-images.ubuntu.com/jammy/current"
IMAGE="jammy-server-cloudimg-amd64.img"
CHECKSUMS="SHA256SUMS" 
VM_ID=8002 

wget "$REPO/$IMAGE"

wget "$REPO/$CHECKSUMS"
## TODO: Verify checksum o

##TODO: Name
sudo virt-customize -a jammy-server-cloudimg-amd64.img --install qemu-guest-agent

sudo qm destroy $VM_ID

##TODO: Change name
sudo qm create $VM_ID --name "ubuntu-2204-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
## TOOD: Resize Disk
sudo qm importdisk $VM_ID jammy-server-cloudimg-amd64.img vm_pool

## Set for console access
sudo qm set $VM_ID --serial0 socket --vga serial0

## TODO: scsi disk might be incorrect. SHould defualt to zero 
sudo qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 vm_pool:vm-$VM_ID-disk-2

sudo qm set $VM_ID --boot c --bootdisk scsi0
sudo qm set $VM_ID --ide2 vm_pool:cloudinit
sudo qm set $VM_ID --agent enabled=1

sudo qm template $VM_ID
