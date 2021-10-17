#!/bin/bash
# Helpful to read output when debugging
set -x

# Load vfio device variables
source "/etc/libvirt/hooks/kvm.conf"

# Stop display manager
systemctl stop display-manager

# Unbind EFI-Framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

# Unload nvidia drivers
modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

# Unbind the GPU from display driver
virsh nodedev-detach $VFIO_GPU_VIDEO
virsh nodedev-detach $VFIO_GPU_AUDIO

# Load VFIO Kernel Module  
modprobe vfio-pci  
