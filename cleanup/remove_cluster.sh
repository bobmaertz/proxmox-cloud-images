#!/bin/sh 

# Shutdown cluster manager
systemctl stop pve-cluster corosync

## Restart cluster fs in local mode 
pmxcfs -l

# Cleanup files / configuration 
rm -r /etc/corosync/*
rm /etc/pve/corosync.conf

# Kill Proxmox Cluster File System
killall pmxcfs

systemctl start pve-cluster 

