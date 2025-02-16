#!/bin/sh
# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -n "Gotta run this as root, sorry. To execute as root, run 'su' in your terminal!"
    exit 1
fi
# Function to update the repository to the latest
update_repository() {
                                                                                               
    echo -n "Would you like to update to the latest repository? (Probably will need this for access to many drivers and desktops) (y/n):"
    read update_confirm
    case "$update_confirm" in
        [Yy])
            echo -n "Updating /etc/pkg/FreeBSD.conf to the latest repository..."
            echo -n "Alright, updating FreeBSD to the latest repo!"
            echo -n 'FreeBSD: {' > /etc/pkg/FreeBSD.conf
            echo -n '  url: "pkg+https://pkg.FreeBSD.org/${ABI}/latest",' >> /etc/pkg/FreeBSD.conf
            echo -n '  mirror_type: "srv",' >> /etc/pkg/FreeBSD.conf
            echo -n '}' >> /etc/pkg/FreeBSD.conf
            echo -n "Repository updated to the latest."
            ;;
        [Nn])
            echo -n "Alright, no changes made."
            ;;
        *)
            echo -n "Invalid response. Please enter y or n."
            exit 1
            ;;
    esac
}


configure_graphics() {
    echo -n "Select graphics provider. Your options are: 'Intel','AMD', 'AMD-Legacy', 'Nvidia', 'Virtualbox', and 'VMWare':"
    read provider_name
    case "$provider_name" in
        Intel)
            install_command="pkg install -y graphics/gpu-firmware-intel-kmod && cd /usr/ports/graphics/drm-61-kmod && make -DBATCH install clean"
            kld_command="sysrc kld_list+=i915kms"
            ;;
        AMD)
            install_command="pkg install -y graphics/gpu-firmware-amd-kmod xf86-video-amdgpu && cd /usr/ports/graphics/drm-61-kmod && make -DBATCH install clean"
            kld_command="sysrc kld_list+=amdgpu"
            ;;
        AMD-Legacy)
            install_command="pkg install -y graphics/gpu-firmware-amd-kmod xf86-video-amdgpu && cd /usr/ports/graphics/drm-61-kmod && make -DBATCH install clean"
            kld_command="sysrc kld_list+=radeonkms"
            ;;
        Nvidia)
            install_command="pkg install -y nvidia-driver"
            kld_command="sysrc kld_list+=nvidia-modeset"
            ;;
        Virtualbox)
            install_command="pkg install -y virtualbox-ose-additions && sysrc vboxguest_enable=\"YES\" && sysrc vboxserviceenable=\"YES\" && whoami"
            kld_command="sysrc kld_list+=vboxvideo"
            ;;
        VMWare)
            install_command="pkg install -y xf86-video-vmware"
            kld_command="sysrc kld_list+=vmwgfx"
            ;;
        *)
            echo -n "Invalid option. Please choose between Intel, AMD, or Nvidia. Virtualbox or VMware.."
            exit 1
            ;;
    esac
    # Display the selected provider and ask for confirmation
    echo -n "You selected $provider_name."
    echo -n "Do you want to install drivers for $provider_name? (y/n):"
    read confirm
    case "$confirm" in
        [Yy])
            echo -n "Installing drivers for $provider_name..."
            eval "$install_command"
            eval "$kld_command"
            echo -n "Drivers installed and configured."
            # Prompt for the non-root username and add to the video group
            echo -n "Enter the username of the non-root user to add to the video group:"
            read username
            pw groupmod video -m "$username"
            echo -n "User $username has been added to the video group."
            ;;
        [Nn])
            echo -n "Installation canceled."
            exit 0
            ;;
        *)
            echo -n "Invalid response. Please enter y or n."
            exit 1
            ;;
    esac
    # Ask for desktop environment or Wayland compositor
    echo -n "Do you want to install an X-based desktop environment, or a Wayland compositor? Type 'xorg' for an X-based DE, and 'wayland' for a compositor."
    read choice
    case "$choice" in
        xorg)
            echo -n "Alright, you have the following options: Plasma Plasma-Minimal Gnome Gnome-Minimal XFCE Mate Mate-Minimal Cinnamon LXQT"
            echo -n "Choose your desktop environment: "
            read de_choice
            case "$de_choice" in
                Plasma)
                    echo -n "You selected KDE Plasma."
                    confirm_install "pkg install -y kde5 sddm xorg && sysrc dbus_enable=\"YES\" && sysrc sddm_enable=\"YES\""
                    ;;
                Plasma-Minimal)
                    echo -n "You selected KDE Plasma Minimal."
                    confirm_install "pkg install -y plasma5-plasma konsole dolphin sddm xorg && sysrc dbus_enable=\"YES\" && sysrc sddm_enable=\"YES\""
                    ;;
                Gnome)
                    echo -n "You selected GNOME."
                    confirm_install "pkg install -y gnome xorg && sysrc dbus_enable=\"YES\" && sysrc gdm_enable=\"YES\""
                    ;;
                Gnome-Minimal)
                    echo -n "You selected GNOME Minimal."
                    confirm_install "pkg install -y gnome-lite gnome-terminal xorg && sysrc dbus_enable=\"YES\" && sysrc gdm_enable=\"YES\""
                    ;;
                XFCE)
                    echo -n "You selected XFCE."
                    confirm_install "pkg install -y xfce lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=\"YES\" && sysrc lightdm_enable=\"YES\""
                    ;;
                Mate)
                    echo -n "You selected MATE."
                    confirm_install "pkg install -y mate lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=\"YES\" && sysrc lightdm_enable=\"YES\""
                    ;;
                Mate-Minimal)
                    echo -n "You selected MATE Minimal."
                    confirm_install "pkg install -y mate-base mate-terminal lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=\"YES\" && sysrc lightdm_enable=\"YES\""
                    ;;
                Cinnamon)
                    echo -n "You selected Cinnamon."
                    confirm_install "pkg install -y cinnamon lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=\"YES\" && sysrc lightdm_enable=\"YES\""
                    ;;
                LXQT)
                    echo -n "You selected LXQT."
                    confirm_install "pkg install -y lxqt sddm xorg && sysrc dbus_enable=\"YES\" && sysrc sddm_enable=\"YES\""
                    ;;
                *)
                    echo -n "Invalid option. Please choose from the listed options."
                    exit 1
                    ;;
            esac
            ;;
        wayland)
            echo -n "You have the following options: Hyprland Sway SwayFX"
            echo -n "Choose your Wayland compositor: "
            read compositor_choice
            case "$compositor_choice" in
                Hyprland)
                    echo -n "You selected Hyprland."
                    confirm_install "pkg install -y hyprland kitty wayland xorg-fonts seatd && sysrc seatd_enable=\"YES\" && sysrc dbus_enable=\"YES\" && service seatd start && echo -n SeatD Started!"
                    ;;
                Sway)
                    echo -n "You selected Sway."
                    confirm_install "pkg install -y sway foot wayland seatd xorg-fonts && sysrc seatd_enable=\"YES\" && sysrc dbus_enable=\"YES\" && service seatd start && echo -n SeatD Started!"
                    ;;
                SwayFX)
                    echo -n "You selected SwayFX."
                    confirm_install "pkg install -y swayfx foot wayland xorg-fonts seatd && sysrc seatd_enable=\"YES\" && sysrc dbus_enable=\"YES\" && service seatd start && echo -n SeatD Started!"
                    ;;
                *)
                    echo -n "Invalid option. Please choose from the listed options."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo -n "Invalid option. Please choose 'xorg' or 'wayland'."
            exit 1
            ;;
    esac
sleep 5
    # Prompt to install Auto Mount utility
    echo -n "Would you like to install Automount? (Highly recommended for mounting drives and removable media automatically on FreeBSD) (y/n): "
    read automount_confirm
    case "$automount_confirm" in
        [Yy])
            echo -n "Installing Automount..."
            pkg install -y automount
            echo -n "Automount installed!"
            ;;
        [Nn])
            echo -n "Skipping Auto Mount utility installation."
            ;;
        *)
            echo -n "Invalid response. Please enter y or n."
            exit 1
            ;;
    esac
}
# Function to confirm and install the selected package
confirm_install() {
    local command="$1"
    echo -n "Do you want to proceed with the following command? $command (y/n): "
    read confirm
    case "$confirm" in
        [Yy])
            echo -n "Executing: $command"
            eval "$command"
            echo -n "Installation and configuration complete."
            ;;
        [Nn])
            echo -n "Installation canceled."
            ;;
        *)
            echo -n "Invalid response. Please enter y or n."
            exit 1
            ;;
    esac
}
# Function to prompt for a reboot
prompt_reboot() {
    echo -n "Would you like to reboot the system now? (y/n): "
    read reboot_confirm
    case "$reboot_confirm" in
        [Yy])
            echo -n "Rebooting now..."
            reboot
            ;;
        [Nn])
            echo -n "Reboot skipped. Please remember to reboot later for all changes to take effect."
            ;;
        *)
            echo -n "Invalid response. Please enter y or n."
            exit 1
            ;;
    esac
}
# Update repository if user agrees
update_repository
# Run the function
configure_graphics
# Prompt for reboot
prompt_reboot
