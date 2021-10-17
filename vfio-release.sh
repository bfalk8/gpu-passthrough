#!/bin/bash
# Helpful to read output when debugging
set -x

# Load vfio device variables
source "/etc/libvirt/hooks/kvm.conf"

modprobe -r vfio-pci

# Re-Bind GPU to Nvidia Driver
virsh nodedev-reattach $VFIO_GPU_VIDEO
virsh nodedev-reattach $VFIO_GPU_AUDIO

# Rebind EFI-Framebuffer
echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

# Reload nvidia modules
modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia

sleep 5

# Restart Display Manager
systemctl start display-manager
