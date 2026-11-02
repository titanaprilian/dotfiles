# Fedora to Omarchy Migration Plan (Mobile Quick Reference)

Zero-risk, side-by-side dual-boot migration guide from Fedora 44 to Omarchy (Arch Linux). Keep this page open on your mobile phone during installation.

---

## Hardware & Baseline Status

- **Device**: ASUS VivoBook X415JP
- **Boot Menu Key**: `Esc` (repeatedly tap on restart)
- **BIOS Setup Key**: `F2`
- **Secure Boot**: Disabled (verified)
- **Drive**: 512 GB NVMe SSD (`/dev/nvme0n1`)
- **Live Installer**: `omarchy-4.0.6.iso` on Ventoy USB drive (`/dev/sda1`)
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

## Step 1: Reboot into Ventoy USB

1. Leave your Ventoy flash drive plugged into the laptop.
2. In Fedora terminal, reboot:
   ```bash
   systemctl reboot
   ```
3. As soon as the screen goes black, **repeatedly tap `Esc`** until the ASUS Boot Menu appears.
4. Select your USB drive: **`UEFI: Ventoy ...`**.
5. In the Ventoy menu, select **`omarchy-4.0.6.iso`** and press Enter.

---

## Step 2: Shrink Fedora by 100 GB

> **Rule**: Shrink Fedora BEFORE launching the installer to avoid partition conflicts.

1. Once the live desktop or terminal appears, launch **GParted** (search in menu or run `sudo gparted` in terminal).
2. Look at the top-right drive selector: ensure **/dev/nvme0n1** is selected.
3. Right-click partition **`/dev/nvme0n1p3`** (380.9 GB Btrfs) and select **Resize/Move**.
4. In the dialog:
   - In **Free space following (MiB)**, type: `102400` (which is 100 GB).
   - Alternatively, drag the right slider handle to the left until unallocated space is ~100 GB.
5. Click **Resize/Move**.
6. Click the green checkmark **Apply All Operations (✓)** on the toolbar.
7. Confirm and wait for the operation to complete (usually takes 1–3 minutes).
8. Close GParted. You now have **100 GB of Unallocated Space** directly after `nvme0n1p3`.

---

## Step 3: Launch Omarchy Installer

1. Launch the **Install Omarchy** icon (or run the installer from terminal).
2. Set your Language, Keyboard layout, and Timezone.
3. When reaching **Disk Partitioning / Storage**:
   - Choose **Manual Partitioning** (or "Something Else").
   - Select the **100 GB Unallocated Space** -> click Create:
     - **Mount Point**: `/` (root)
     - **Filesystem**: `btrfs` (recommended) or `ext4`
     - **Size**: Use entire 100 GB
     - **Format**: Yes (Format this new partition)
   - Select the existing EFI partition **`/dev/nvme0n1p1`** (600 MB):
     - **Mount Point**: `/boot/efi` (or `/boot` if prompted)
     - **Format**: **NO / UNCHECK FORMAT** (Warning: Formatting this deletes Fedora bootloader)
4. User creation:
   - **Username**: `titanic`
   - Set password and enable administrative/sudo privileges.
5. Bootloader:
   - Select your NVMe drive (`/dev/nvme0n1`) for EFI bootloader installation.
6. Review the summary and start the installation.
7. Once finished, reboot the PC and unplug the USB drive.

---

## Step 4: First Boot into Omarchy & Restore Secrets

When Omarchy boots up, plug your Ventoy flash drive back in to restore your keys and environment secrets.

### 4.1. Restore SSH, GitHub CLI, and Cloud Credentials
Open terminal in Omarchy and run:
```bash
# Find your USB mount point (usually /run/media/titanic/Ventoy or /mnt)
USB_PATH="/run/media/titanic/Ventoy"

# Extract credentials
tar -xzvf "$USB_PATH/fedora_migration_backup/credentials.tar.gz" -C ~

# Secure SSH permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_* ~/.ssh/google_compute_engine 2>/dev/null
chmod 644 ~/.ssh/*.pub ~/.ssh/config ~/.ssh/known_hosts 2>/dev/null

# Test GitHub SSH connection
ssh -T git@github.com
```

### 4.2. Clone Your Dotfiles
```bash
git clone git@github.com:titanaprilian/dotfiles.git ~/.dotfiles
```

### 4.3. Mount Old Fedora Home & Restore Work
Your Fedora files are 100% safe on `nvme0n1p3`. Mount it in read-only mode to copy anything you need:

```bash
sudo mkdir -p /mnt/fedora
sudo mount -o ro,subvol=home /dev/nvme0n1p3 /mnt/fedora

# Copy Projects and Development directories:
cp -a /mnt/fedora/titanic/Projects ~/Projects
cp -a /mnt/fedora/titanic/Development ~/Development

# Unmount when done:
sudo umount /mnt/fedora
```

### 4.4. Restore All 30 Project `.env` Files
```bash
tar -xzvf "$USB_PATH/fedora_migration_backup/env_files.tar.gz" -C ~
```
*(All 30 `.env` files will automatically unpack into their respective project folders).*

---

## Step 5: Safety Period & Final Drive Reclamation

- Keep Fedora installed for **1 to 2 weeks** as a fallback.
- Whenever you reboot, you can pick Fedora from GRUB/systemd-boot if you need to check something.
- Once completely satisfied with Omarchy:
  1. Boot the Live USB one last time.
  2. Open GParted and delete `/dev/nvme0n1p2` and `/dev/nvme0n1p3` (Fedora).
  3. Expand the Omarchy partition across the entire free space.
