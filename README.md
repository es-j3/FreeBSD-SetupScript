## FreeBSD Setup Script

> Warning! This script is not recommended for if you are new to FreeBSD, as it takes away from the learning experience. This is mainly intended for people who are reinstalling and want to save time. 

### What is this?

This is a script designed to set up the core of a FreeBSD GUI desktop automagically. It installs Graphics Drivers, Desktop Environments, and a browser, with the goal of saving time.

### How to use? 

To enter super user:

```su -```

To fetch the script:

```fetch https://raw.githubusercontent.com/coolerguy71/FreeBSD-SetupScript/main/setupbsd``` 

To make executable:

```chmod +x setupbsd```

Now, you have two options:

1. A guided install ```./setupbsd``` <--- just this


2. An automated install. Maybe I need to explain this one a bit.

```./setupbsd |Latest| |AMD|AMD-Legacy|Intel|Nvidia|VMware| |Plasma|Plasma-Minimal|GNOME|Gnome-Minimal|XFCE|Mate|Mate-Minimal|Cinnamon|LXQT|i3|Hyprland|Hikari|IceWM|River|Sway|SwayFX|Wayfire| |GDM|LightDM|SDDM|```

Example: ```./setupbsd Latest AMD GNOME GDM```

> (C) 2025 es-j3
