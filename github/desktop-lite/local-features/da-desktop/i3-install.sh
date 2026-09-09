#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

NOVNC_VERSION="${NOVNCVERSION:-"1.6.0"}"
VNC_PASSWORD=${PASSWORD:-"vscode"}
if [ "$VNC_PASSWORD" = "noPassword" ]; then
    unset VNC_PASSWORD
fi
NOVNC_PORT="${WEBPORT:-6080}"
VNC_PORT="${VNCPORT:-5901}"

INSTALL_NOVNC="${INSTALL_NOVNC:-"true"}"
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
WEBSOCKETIFY_VERSION=0.10.0

package_list="
    tigervnc-standalone-server \
    tigervnc-common \
    i3 \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    xdg-utils \
    at-spi2-core \
    xterm \
    nautilus \
    mousepad \
    seahorse \
    gnome-icon-theme \
    gnome-keyring \
    libx11-dev \
    libxkbfile-dev \
    libsecret-1-dev \
    libgbm-dev \
    libnotify4 \
    libnss3 \
    libxss1 \
    xfonts-base \
    xfonts-terminus \
    fonts-noto \
    fonts-wqy-microhei \
    fonts-droid-fallback \
    ncdu \
    curl \
    ca-certificates \
    unzip \
    nano \
    locales"

package_list_additional="tigervnc-tools"

set -e
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Determine non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

# i3 basic user setup function
setup_i3_config() {
    local target_dir="$1"
    mkdir -p "${target_dir}/.config/i3"
    mkdir -p "${target_dir}/.vnc"
    
    # Generate a default i3 config if none exists
    if [ ! -e "${target_dir}/.config/i3/config" ]; then
        cp /etc/i3/config "${target_dir}/.config/i3/config" 2>/dev/null || true
    fi

    # Configure TigerVNC xstartup to run i3
    cat << 'EOF' > "${target_dir}/.vnc/xstartup"
#!/bin/sh
exec i3
EOF
    chmod +x "${target_dir}/.vnc/xstartup"
}

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive
apt_get_update

# Install packages
check_packages ${package_list}

if apt-cache show libasound2t64 > /dev/null 2>&1; then
    check_packages libasound2t64 libasound2-dev
elif apt-cache show libasound2 > /dev/null 2>&1; then
    check_packages libasound2 libasound2-dev
fi

if ! type vncpasswd > /dev/null 2>&1; then
    check_packages ${package_list_additional}
fi

if ! grep -o -E '^\s*en_US.UTF-8\s+UTF-8' /etc/locale.gen > /dev/null; then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
fi

# Install noVNC
if [ "${INSTALL_NOVNC}" = "true" ] && [ ! -d "/usr/local/novnc" ]; then
    mkdir -p /usr/local/novnc
    curl -sSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.zip -o /tmp/novnc-install.zip
    unzip /tmp/novnc-install.zip -d /usr/local/novnc
    cp /usr/local/novnc/noVNC-${NOVNC_VERSION}/vnc.html /usr/local/novnc/noVNC-${NOVNC_VERSION}/index.html
    curl -sSL https://github.com/novnc/websockify/archive/v${WEBSOCKETIFY_VERSION}.zip -o /tmp/websockify-install.zip
    unzip /tmp/websockify-install.zip -d /usr/local/novnc
    ln -s /usr/local/novnc/websockify-${WEBSOCKETIFY_VERSION} /usr/local/novnc/noVNC-${NOVNC_VERSION}/utils/websockify
    rm -f /tmp/websockify-install.zip /tmp/novnc-install.zip
    check_packages python3-minimal python3-numpy
    sed -i -E 's/^python /python3 /' /usr/local/novnc/websockify-${WEBSOCKETIFY_VERSION}/run
fi

mkdir -p /var/run/dbus /usr/local/etc/vscode-dev-containers/


# Container ENTRYPOINT script
cat << 'EOF' > /usr/local/share/dagithubinit.sh
#!/bin/bash

DAINIT_DIR="/workspaces/.dainit"
DAINIT_SCRIPT="$DAINIT_DIR/autostart.sh"

mkdir -p "$DAINIT_DIR"

if [ ! -f "$DAINIT_SCRIPT" ]; then
cat << 'INNER_EOF' > "$DAINIT_SCRIPT"
#!/bin/bash

LOG_FILE="/tmp/dagithub-autostart.log"

while true; do
    echo "[$(date)] autostart running" > "$LOG_FILE"
    sleep 10
done
INNER_EOF

chmod +x "$DAINIT_SCRIPT"
fi

bash "$DAINIT_SCRIPT"
EOF

# Resolution changer script
cat << EOF > /usr/local/bin/set-resolution
#!/bin/bash
RESOLUTION=\${1:-\${VNC_RESOLUTION:-1920x1080}}
DPI=\${2:-\${VNC_DPI:-96}}
xrandr --fb \${RESOLUTION} --dpi \${DPI} > /dev/null 2>&1
echo -e "\nSuccess!\n"
EOF
chmod +x /usr/local/bin/set-resolution

# Desktop init script
cat << EOF > /usr/local/share/desktop-init.sh
#!/bin/bash
user_name="${USERNAME}"
group_name="\$(id -gn \${user_name})"
LOG=/tmp/container-init.log

export DBUS_SESSION_BUS_ADDRESS="\${DBUS_SESSION_BUS_ADDRESS:-"autolaunch:"}"
export DISPLAY="\${DISPLAY:-:1}"
export VNC_RESOLUTION="\${VNC_RESOLUTION:-1440x768x16}"

startInBackgroundIfNotRunning() {
    if ! pgrep -x \$1 > /dev/null; then
        (\$2 bash -c "while :; do \$3; sleep 5; done 2>&1" &)
        while ! pgrep -x \$1 > /dev/null; do sleep 1; done
    fi
}

sudoIf() { if [ "\$(id -u)" -ne 0 ]; then sudo "\$@"; else "\$@"; fi; }
sudoUserIf() { if [ "\$(id -u)" -eq 0 ] && [ "\${user_name}" != "root" ]; then sudo -u \${user_name} "\$@"; else "\$@"; fi; }

sudoIf /etc/init.d/dbus start 2>&1 > /dev/null

sudoIf rm -rf /tmp/.X11-unix /tmp/.X*-lock
mkdir -p /tmp/.X11-unix
sudoIf chmod 1777 /tmp/.X11-unix

screen_geometry="\${VNC_RESOLUTION%*x*}"
screen_depth="\${VNC_RESOLUTION##*x}"

common_options="tigervncserver \${DISPLAY} -geometry \${screen_geometry} -depth \${screen_depth} -rfbport ${VNC_PORT} -dpi \${VNC_DPI:-96} -localhost -desktop i3 -fg"

if [ -n "\${VNC_PASSWORD+x}" ]; then
    startInBackgroundIfNotRunning "Xtigervnc" sudoUserIf "\${common_options} -passwd /usr/local/etc/vscode-dev-containers/vnc-passwd"
else
    startInBackgroundIfNotRunning "Xtigervnc" sudoUserIf "\${common_options} -SecurityTypes None"
fi

if [ -d "/usr/local/novnc" ]; then
    if [ "\$(ps -ef | grep novnc_proxy | grep -v grep)" = "" ]; then
        (/usr/local/novnc/noVNC*/utils/novnc_proxy --listen ${NOVNC_PORT} --vnc localhost:${VNC_PORT} &)
    fi
fi


# Run custom startup script in background
if [ -f "/usr/local/share/dagithubinit.sh" ]; then
    sudoIf "/usr/local/share/dagithubinit.sh"
fi

if [ -n "\$1" ]; then exec "\$@"; fi
EOF

if [ -n "${VNC_PASSWORD+x}" ]; then
    echo "${VNC_PASSWORD}" | vncpasswd -f > /usr/local/etc/vscode-dev-containers/vnc-passwd
fi
chmod +x /usr/local/share/desktop-init.sh

# Apply i3 configuration
if [ "${USERNAME}" != "root" ]; then
    setup_i3_config "/home/${USERNAME}"
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.config /home/${USERNAME}/.vnc
fi

rm -rf /var/lib/apt/lists/*
echo "(*) i3 Desktop Environment Installed Successfully!"
