# 🪟 Windows Server 2025 Autoinstall for Proxmox

### Fully Automated Windows Server 2025 Installation ISO Builder  
**Built by [Sunil Kumar (@sudo0xsunil)](https://github.com/sudo0xsunil)**

---

## 🧠 Overview

This project provides a **Bash-based automation toolkit** that builds a **fully unattended Windows Server 2025 ISO** and prepares it for instant deployment inside **Proxmox VE**.

The script automatically:
- Installs required utilities (`mkisofs`, `curl`, etc.)
- Creates an **Autounattend.xml** file
- Embeds VirtIO drivers for Proxmox  
- Skips all installation dialogs (EULA, user setup, network prompts)
- Automatically sets Administrator password, enables RDP, and allows firewall rules  
- Builds a **secondary ISO** that acts as your autoinstall seed

Once attached to a Windows Server VM in Proxmox, the OS installs **completely hands-free**.  

---

## ⚡ Key Features

| Feature | Description |
|----------|-------------|
| 🚀 **100% Hands-Free Setup** | Automatically installs Windows Server 2025 |
| 🔐 **Admin Password Auto-Set** | Pre-defined Administrator credentials |
| 🖥️ **RDP Auto-Enabled** | Remote Desktop enabled and firewall opened |
| 💾 **VirtIO Drivers Included** | Automatic driver detection for Proxmox disks |
| 🕒 **Timezone Configurable** | Defaults to India Standard Time |
| 🧩 **No Manual Input** | EULA, partition, and locale all skipped |
| 🧱 **Proxmox-Ready ISO** | Works seamlessly with VirtIO and UEFI BIOS |
| ⚙️ **Customizable XML** | Adjust any field easily before build |

---

## 🧰 Requirements

- **Proxmox VE 8+**
- **Windows Server 2025 Evaluation ISO** (build 26100.1742 or later)
- Internet connectivity
- ~10 GB of free disk space in `/var/lib/vz/template/iso`
- Root or sudo access

---

## ⚙️ Usage Guide

### 1️⃣ Save the Script

Create the builder file:

```bash
nano /root/make-win2025-autoinstall.sh
