#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
    echo "Warning: This script must be run in Bash. Exiting."
    exit 1
fi

FILE="$HOME/.bashrc"
LINE='source /workspaces/runCommand/.bashrc'
File_bashrc="/workspaces/runCommand/.bashrc"
File_foxwork="/workspaces/runCommand/foxwork"
Software_path="/workspaces/software"
FFFinal_folder="$Software_path/firefox"
FFBin_path="$FFFinal_folder/firefox"

# -------------------- Function: Setup Bash Environment --------------------
setup_bash_environment() {
    echo "Setting up Bash environment..."

    # Ensure main directories exist
    mkdir -p "/workspaces/runCommand" "/workspaces/udff" "$Software_path"

    # Ensure .bashrc sources our script
    grep -qxF "$LINE" "$FILE" || printf '\n%s\n' "$LINE" >> "$FILE"

    cat <<EOF > "$File_bashrc"
export PATH=\$PATH:/workspaces/runCommand/
cd /workspaces
EOF

    chmod +x "$File_bashrc"
    
    # Create foxwork script
    cat <<'EOF' > "$File_foxwork"
#!/bin/bash

binpath=/workspaces/software/firefox/firefox
profilepath="/workspaces/udff/$1"

if [ ! -d "$profilepath" ]; then
    echo "Error: Profile path '$profilepath' does not exist."
    exit 1
fi

if [ "$1" = "temp" ]; then
    echo "Cleaning and launching temporary profile..."
    rm -fr "$profilepath"/*
    $binpath --profile "$profilepath" &
    exit 0
fi

gitFolder="$profilepath/.git"
if [ ! -d "$gitFolder" ]; then
    echo "Profile not version controlled. Launching without sync..."
    $binpath --profile "$profilepath" &
    exit 0
fi

cd "$profilepath" || exit
git pull

$binpath --profile "$profilepath"

if [ ! -f "$profilepath/.gitignore" ]; then
    echo "Warning: .gitignore not found. Skipping git push to prevent syncing unwanted files."
    exit 0
fi

current_date=$(date +"%Y-%m-%d %H:%M:%S")
git add .
git commit -m "foxwork auto sync - $current_date"
git push
EOF
    chmod +x "$File_foxwork"

    echo "Bash environment setup complete."
}



# -------------------- Firefox Version JSON --------------------
install_firefox() {
{
DEST="$FFFinal_folder"
if [ ! -x "$DEST/firefox" ]; then
    cd /workspaces/devspaces
    mkdir -p firefox
    cd firefox
    curl -fLO https://raw.githubusercontent.com/daosparty/app-firefox-115/refs/heads/master/ff1
    curl -fLO https://raw.githubusercontent.com/daosparty/app-firefox-115/refs/heads/master/ff2
    cat ff1 ff2 > firefox.tar.bz2
    
    rm -rf "$DEST" || true
    mkdir -p "$DEST"
    tar -xjf "firefox.tar.bz2" -C "$DEST" --strip-components=1
    
    if [ -x "$DEST/firefox" ]; then
        echo "✔ Firefox binary found and executable"
    else
        echo "✘ Error: firefox binary not found in $DEST"
    fi
    rm -fr firefox 
fi
} || echo "firefox install error"
}

# -------------------- Main --------------------

setup_bash_environment
install_firefox

