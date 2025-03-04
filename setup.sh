#!/bin/sh

SRC_PATH="/usr/src/sys"
PORTS_PATH="/usr/ports/emulators"

if [ "$(id -u)" -ne 0 ]; then
    echo "Root is required."
    exit 1
fi

        echo "
███████ ███████ ████████ ██    ██ ██████  ██
██      ██         ██    ██    ██ ██   ██ ██
███████ █████      ██    ██    ██ ██████  ██
     ██ ██         ██    ██    ██ ██        
███████ ███████    ██     ██████  ██      ██
        "                              
         
        sleep 2
         
        echo 'Warning! This script is not recommended for if you are new to FreeBSD, as it takes away from the learning experience. This is mainly intended for people who are reinstalling and want to save time.'
         
        sleep 2
         
     if [ ! -d "$SRC_PATH" ]; then
      printf "It looks like you are missing the system source tree in /usr/src. This is required for the script to function. Would you like to clone it now? (y/n): "
      read -r src_confirm 
        case "$src_confirm" in
            [Yy])
                echo "Installing git to clone the source tree..."
                pkg install -y git
                git clone https://github.com/freebsd/freebsd-src.git --depth 1 /usr/src
                ;;
            [Nn])
                    echo "Alright, no changes made."
                    ;;
                *)
                    echo "Invalid response, enter y or n."
                    exit 1
                    ;;
        esac
    fi

     if [ ! -d "$PORTS_PATH" ]; then
      printf "Looks like the ports tree is not here, and it's required for this script to properly function. Clone it now?"
      read -r ports_confirm 
        case "$ports_confirm" in
            [Yy])
                echo "Installing git to clone ports..."
                pkg install -y git
                git clone https://github.com/freebsd/freebsd-ports.git --depth 1 /usr/ports
                ;;
            [Nn])
                    echo "Alright, no changes made."
                    ;;
                *)
                    echo "Invalid response, enter y or n."
                    exit 1
                    ;;
        esac
    fi
         
        sleep 2

         
        echo "
██████  ███████ ██████   ██████  ███████
██   ██ ██      ██   ██ ██    ██ ██      
██████  █████   ██████  ██    ██ ███████
██   ██ ██      ██      ██    ██      ██
██   ██ ███████ ██       ██████  ███████
        "
         
        printf 'To start, would you like to switch to the latest repo from quarterly? (y/n): '
        read -r repo_switch
            case "$repo_switch" in
                [Yy])
                    echo "Alright, updating FreeBSD to the latest repo!"
                    echo "FreeBSD: {" > /etc/pkg/FreeBSD.conf
                    echo "  url: "pkg+https://pkg.FreeBSD.org/${ABI}/latest"," >> /etc/pkg/FreeBSD.conf
                    echo "  mirror_type: "srv"," >> /etc/pkg/FreeBSD.conf
                    echo "}" >> /etc/pkg/FreeBSD.conf
                    ;;
                [Nn])
                    echo "Alright, no changes made."
                    ;;
                *)
                    echo "Invalid response, enter y or n."
                    exit 1
                    ;;
            esac
         
        echo "
 ██████  ██████   █████  ██████  ██   ██ ██  ██████ ███████
██       ██   ██ ██   ██ ██   ██ ██   ██ ██ ██      ██      
██   ███ ██████  ███████ ██████  ███████ ██ ██      ███████
██    ██ ██   ██ ██   ██ ██      ██   ██ ██ ██           ██
 ██████  ██   ██ ██   ██ ██      ██   ██ ██  ██████ ███████
        "
        echo " "
        echo "0 - skip"
        echo "1 - AMD"
        echo "2 - AMD-Legacy"
        echo "3 - Intel"
        echo "4 - Nvidia"
        echo "5 - VMware"
        echo " "
        printf "What will it be?: "
         
        read -r graphics
            case "$graphics" in
                0)
                    sleep 1
                    ;;
         
                1)
                    echo 'Installing AMD Graphics Drivers...'
                    pkg install -y graphics/gpu-firmware-amd-kmod && sysrc kld_list+=amdgpu && cd /usr/ports/graphics/drm-61-kmod && make install clean 
                    echo 'Finished!'
                    ;;
         
                2)
                    echo 'Installing AMD Legacy Graphics Drivers...'
                    pkg install -y graphics/gpu-firmware-amd-kmod && sysrc kld_list+=radeonkms && cd /usr/ports/graphics/drm-61-kmod && make install clean 
                    echo 'Finished!'
                    ;;
         
                3)
                    echo 'Installing Intel Graphics Drivers...'
                    pkg install -y graphics/gpu-firmware-intel-kmod && sysrc kld_list+=i915kms && cd /usr/ports/graphics/drm-61-kmod && make install clean 
                    echo 'Finished!'
                    ;;
         
                4)
                    echo 'Installing Nvidia Graphics Drivers...'
                    pkg install -y nvidia-driver && sysrc kld_list+=nvidia-modeset
                    echo 'Finished!'
                    ;;
         
                5)
                    echo 'Installing VMware Graphics Drivers...'
                    pkg install -y xf86-video-vmware && sysrc kld_list+=vmwgfx
                    echo 'Finished!'
                    ;;
               
                *)
         
                    echo "Looks like something went wrong. Select 1 for AMD, 2 for Legacy AMD, 3 for Intel, 4 for Nvidia, and 5 for VMware."
                    exit 1
                    ;;
            esac  
        
        sleep 3

echo "
 ██████  ██████   ██████  ██    ██ ██████  ███████ 
██       ██   ██ ██    ██ ██    ██ ██   ██ ██      
██   ███ ██████  ██    ██ ██    ██ ██████  ███████ 
██    ██ ██   ██ ██    ██ ██    ██ ██           ██ 
 ██████  ██   ██  ██████   ██████  ██      ███████ 
"

    printf "Enter the username of your non-root user to add to the video group: "
        read -r video_group
        pw groupmod video -m "$video_group"

        echo "
 ██████  ██    ██ ██
██       ██    ██ ██
██   ███ ██    ██ ██
██    ██ ██    ██ ██
 ██████   ██████  ██
        "
         
        echo " "
        echo "0 - skip"
        echo "1 - Desktop Environment"
        echo "2 - Window Manager"
        echo " "
        printf "Desktop Environment, or Window Manager?: "
         
        read -r gui_choice
            case "$gui_choice" in
                0)
                    sleep 1
                    ;;
         
                1)
                    echo "
██████  ███████ ███████ ██   ██ ████████  ██████  ██████  
██   ██ ██      ██      ██  ██     ██    ██    ██ ██   ██
██   ██ █████   ███████ █████      ██    ██    ██ ██████  
██   ██ ██           ██ ██  ██     ██    ██    ██ ██      
██████  ███████ ███████ ██   ██    ██     ██████  ██      
                    "
                    echo " "
                    echo "0 - skip"
                    echo "1 - Plasma"
                    echo "2 - Plasma-Minimal"
                    echo "3 - GNOME"
                    echo "4 - GNOME-Minimal"
                    echo "5 - XFCE"
                    echo "6 - Mate"
                    echo "7 - Mate Minimal"
                    echo "8 - Cinnamon"
                    echo "9 - LXQT"
                    echo "By the way, feel free to open an issue or PR in case you want anything new added"
                    echo " "
         
                    printf "So, which desktop?: "
                    read -r desktop_choice
                        case "$desktop_choice" in
                            0)
                                sleep 1
                            ;;
         
                            1)
                                echo "Installing KDE Plasma..."
                                pkg install -y kde5 sddm xorg && sysrc dbus_enable=YES && sysrc sddm_enable=YES
                                echo "Success!"
                            ;;
                            2)
                                echo "Installing KDE Plasma Minimal..."
                                pkg install -y plasma5-plasma konsole dolphin sddm xorg && sysrc dbus_enable=YES && sysrc sddm_enable=YES
                                echo "Success!"
                            ;;
                            3)
                                echo "Installing GNOME..."
                                pkg install -y gnome xorg && sysrc dbus_enable=YES && sysrc gdm_enable=YES
                                echo "Success!"
                            ;;
                            4)
                                echo "Installing GNOME Minimal..."
                                pkg install -y gnome-lite gnome-terminal xorg && sysrc dbus_enable=YES && sysrc gdm_enable=YES
                                echo "Success!"
                            ;;
                            5)
                                echo "Installing XFCE..."
                                pkg install -y xfce lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=YES && sysrc lightdm_enable=YES
                                echo "Success!"
                            ;;
                            6)
                                echo "Installing MATE..."
                                pkg install -y mate lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=YES && sysrc lightdm_enable=YES
                                echo "Success!"
                            ;;
                            7)
                                echo "Installing MATE Minimal..."
                                pkg install -y mate-base mate-terminal lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=YES && sysrc lightdm_enable=YES
                                echo "Success!"
                            ;;
                            8)
                                echo "Installing Cinnamon..."
                                pkg install -y cinnamon lightdm lightdm-gtk-greeter xorg && sysrc dbus_enable=YES && sysrc lightdm_enable=YES
                                echo "Success!"
                            ;;
                            9)
                                echo "Installing LXQT..."
                                pkg install -y lxqt sddm xorg && sysrc dbus_enable=YES && sysrc sddm_enable=YES
                                echo "Success!"
                            ;;        
                           *)
                                echo "This looks invalid, follow the instructions."
                                exit 1
                            ;;
                        esac
                    ;;
                2)
                    echo "
██     ██ ███    ███ 
██     ██ ████  ████ 
██  █  ██ ██ ████ ██ 
██ ███ ██ ██  ██  ██ 
 ███ ███  ██      ██
                    "
                    echo " "
                    echo "0 - skip"
                    echo "1 - i3"
                    echo "2 - Hyprland"
                    echo "3 - Hikari"
                    echo "4 - IceWM"
                    echo "5 - River"
                    echo "6 - Sway"
                    echo "7 - SwayFX"
                    echo "8 - Wayfire"
                    echo "By the way, feel free to open an issue or PR in case you want anything new added."
                    echo " "
                    printf "So, what're you going with?: "
                    read -r wm_choice
                        case "$wm_choice" in
                            0)
                                sleep 1
                            ;;
         
                            1)
                                echo "Installing the third i..."
                                pkg install -y i3 alacritty && sysrc dbus_enable=YES
                                echo "Success!"
                            ;;
                            2)
                                echo "Installing eye crack..."
                                pkg install -y hyprland kitty wayland xorg-fonts seatd && sysrc seatd_enable=YES && sysrc dbus_enable=YES && service seatd start
                                echo "Success!"
                            ;;
                            3)
                                echo "Installing an underrated wm..."
                                pkg install -y hikari alacritty wayland xorg-fonts seatd && sysrc seatd_enable=YES && sysrc dbus_enable=YES && service seatd start
                                echo "Success!"
                            ;;
                            4)
                                echo "Installing icy wm..."
                                pkg install -y icewm xterm && sysrc dbus_enable=YES
                                echo "Success!"
                            ;;
                            5)
                                echo "Installing river, dont get too wet..."
                                pkg install -y river foot wayland xorg-fonts seatd && sysrc seatd_enable=YES && sysrc dbus_enable=YES && service seatd start
                                echo "Success!"
                            ;;
                            6)
                                echo "Installing sway..."
                                pkg install -y sway foot wayland xorg-fonts seatd && sysrc seatd_enable=YES && sysrc dbus_enable=YES && service seatd start
                                echo "Success!"
                            ;;
                            7)
                                echo "Installing sway but eye candy..."
                                pkg install -y swayfx foot wayland xorg-fonts seatd && sysrc seatd_enable=YES && sysrc dbus_enable=YES && service seatd start
                                echo "Success!"
                            ;;
                            8)
                                echo "Installing the way of fire..."
                                pkg install -y wayfire alacritty xorg-fonts seatd && sysrc dbus_enable=YES && sysrc seatd_enable="YES" && service seatd start
                                echo "Success!"
                            ;;
                        esac
                    
                    sleep 3

                    echo "
██       ██████   ██████  ██ ███    ██ 
██      ██    ██ ██       ██ ████   ██ 
██      ██    ██ ██   ███ ██ ██ ██  ██ 
██      ██    ██ ██    ██ ██ ██  ██ ██ 
███████  ██████   ██████  ██ ██   ████ 
                    "
                    echo "Oh yeah, I almost forgot. Do you want a login manager to-go with that great WM pick? If not, just skip but if yes, go ahead!"
                    echo "0 - skip"
                    echo "1 - GDM"
                    echo "2 - LightDM"
                    echo "3 - SDDM"
                    printf "So, what will it be?: "
                    read -r lm_pick
                        case "$lm_pick" in
                            0)
                                sleep 1
                            ;;
                            1)  
                                echo "Installing GDM..."
                                pkg install -y gdm && sysrc gdm_enable=YES
                                echo "Success!"
                            ;;
                            2)
                                echo "Installing LightDM..."
                                pkg install -y lightdm lightdm-gtk-greeter && sysrc lightdm_enable=YES
                                echo "Success!"
                            ;;
                            3)
                                echo "Installing SDDM..."
                                pkg install -y sddm && sysrc sddm_enable="YES"
                                echo "Success!"
                            ;;
                           *)   
                                echo "This looks invalid, follow the instructions."
                                exit 1
                            ;;
                        
                        esac
                    esac
echo "Hello, looks like we've reached the end! Thanks for using this script, and enjoy your FreeBSD install."
