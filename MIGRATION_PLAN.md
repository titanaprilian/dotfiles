# Fedora to Omarchy Migration Plan (Mobile Quick Reference)

Zero-risk, side-by-side dual-boot migration guide from Fedora 44 to Omarchy (Arch Linux). Keep this page open on your mobile phone during installation.

---

## Hardware & Baseline Status

- **Device**: ASUS VivoBook X415JP
- **Boot Menu Key**: `Esc` (repeatedly tap on restart)
- **BIOS Setup Key**: `F2`
- **Secure Boot**: Disabled (verified)
- **Drive**: 512 GB NVMe SSD (`/dev/nvme0n1`)
- **ISO on Ventoy USB**:
  1. `Fedora-Workstation-Live-44-1.7.x86_64.iso` (Used for safe GParted shrinking)
  2. `omarchy-4.0.6.iso` (Used for Arch/Omarchy installation)
- **Backup Location on USB**: `/fedora_migration_backup/`

```
Current Partition Map:
nvme0n1 (476.9 GiB)
├─nvme0n1p1   600M   vfat   /boot/efi       [KEEP - DO NOT FORMAT]
├─nvme0n1p2     2G   ext4   /boot           [Fedora boot - KEEP]
├─nvme0n1p3 380.9G   btrfs  / and /home     [Fedora data - SHRINK by 100G]
├─nvme0n1p4    16M          MS Reserved
├─nvme0n1p5  92.6G   ntfs   Unmounted NTFS
└─nvme0n1p6   845M   ntfs   Windows Recovery
```

---

## Why We Must Shrink via Live USB (Not From Inside Running Fedora)

While Btrfs can shrink its filesystem while running, the underlying disk partition table (`/dev/nvme0n1p3`) cannot be resized while the root OS is running on it. The Linux kernel locks the partition table (`device or resource busy`). If the partition table is not resized, the Omarchy installer will see **0 GB unallocated space**.

Because Omarchy's ISO boots directly into the installer (without a GUI desktop/GParted), the cleanest and safest method uses the **Fedora Live ISO already on your Ventoy USB**.

---

## Step 1: Boot Fedora Live to Shrink (3 Minutes)

1. Reboot your PC:
   ```bash
   systemctl reboot
   ```
2. As soon as the screen turns off, repeatedly tap **`Esc`** until the ASUS Boot Menu appears.
3. Select **`UEFI: Ventoy ...`**.
4. In the Ventoy menu, select **`Fedora-Workstation-Live-44-1.7.x86_64.iso`**.
5. Select **"Try Fedora"** to reach the live desktop.
6. Open **GParted** (or **Disks**):
   - Select `/dev/nvme0n1` (top right).
   - Right-click `/dev/nvme0n1p3` (380.9 GB Btrfs) -> **Resize/Move**.
   - Under **Free space following (MiB)**, enter: `102400` (100 GB).
   - Click **Resize/Move**, then click the green checkmark **Apply (✓)**.
7. Once finished, you will see **100 GB Unallocated Space**.
8. Reboot the laptop:
   ```bash
   reboot
   ```

---

## Step 2: Boot Omarchy & Install

1. Tap **`Esc`** during reboot to open the ASUS Boot Menu again.
2. Select **`UEFI: Ventoy ...`** -> choose **`omarchy-4.0.6.iso`**.
3. In the Omarchy / Arch installer:
   - When asked for disk layout, select the drive: `/dev/nvme0n1`.
   - Choose **Use free space** (or manual partition):
     - Target the **100 GB unallocated space** for `/` (root filesystem: `btrfs` or `ext4`).
     - For EFI: Select `/dev/nvme0n1p1` (600 MB) and mount at `/boot` or `/boot/efi`. **DO NOT FORMAT IT**.
   - Set username to `titanic` and assign your password.
4. Complete the installation and reboot.

---

## Step 3: First Boot into Omarchy & Restore Secrets

When Omarchy boots, log in and plug your Ventoy flash drive back in:

### 3.1. Restore SSH, GitHub CLI, and Cloud Credentials
```bash
# Find USB mount point
USB_PATH="/run/media/titanic/Ventoy"

# Extract credentials
tar -xzvf "$USB_PATH/fedora_migration_backup/credentials.tar.gz" -C ~

# Secure SSH permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_* ~/.ssh/google_compute_engine 2>/dev/null
chmod 644 ~/.ssh/*.pub ~/.ssh/config ~/.ssh/known_hosts 2>/dev/null

# Test connection
ssh -T git@github.com
```

### 3.2. Clone Your Dotfiles
```bash
git clone git@github.com:titanaprilian/dotfiles.git ~/.dotfiles
```

### 3.3. Mount Old Fedora Home & Restore Work
Your original Fedora files are completely intact on `nvme0n1p3`:

```bash
sudo mkdir -p /mnt/fedora
sudo mount -o ro,subvol=home /dev/nvme0n1p3 /mnt/fedora

# Copy Projects and Development directories:
cp -a /mnt/fedora/titanic/Projects ~/Projects
cp -a /mnt/fedora/titanic/Development ~/Development

# Unmount when done:
sudo umount /mnt/fedora
```

### 3.4. Restore All 30 Project `.env` Files
```bash
tar -xzvf "$USB_PATH/fedora_migration_backup/env_files.tar.gz" -C ~
```

---

## Step 4: Safety Period & Final Drive Reclamation

- Keep Fedora installed for **1 to 2 weeks** as a fallback.
- Whenever you reboot, you can pick Fedora from GRUB/systemd-boot if you need to check something.
- Once completely satisfied with Omarchy:
  1. Boot the Live USB one last time.
  2. Open GParted and delete `/dev/nvme0n1p2` and `/dev/nvme0n1p3` (Fedora).
  3. Expand the Omarchy partition across the entire free space.
