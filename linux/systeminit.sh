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
FF_VERSION_JSON=$(curl -s https://product-details.mozilla.org/1.0/firefox_versions.json)

# -------------------- Function: Download & Install Firefox --------------------
download_firefox() {
    local Firefox_url="$1"
    local FFTmp_extract="$Software_path/firefox_tmp_$$"
    local FFDownload_file="/tmp/firefox.download"

    rm -f "$FFDownload_file"
    rm -rf "$FFTmp_extract"
    mkdir -p "$FFTmp_extract"

    trap 'rm -rf "$FFTmp_extract" "$FFDownload_file"' EXIT

    echo "Downloading Firefox ESR..."
    if ! curl -L -o "$FFDownload_file" "$Firefox_url"; then
        echo "Error: Download failed!"
        exit 1
    fi

    echo "Extracting Firefox..."
    if ! tar -xf "$FFDownload_file" -C "$FFTmp_extract"; then
        echo "Error: Extraction failed!"
        exit 1
    fi

    local Extracted_folder
    Extracted_folder=$(find "$FFTmp_extract" -mindepth 1 -maxdepth 1 -type d | head -n 1)
    if [ -z "$Extracted_folder" ]; then
        echo "Error: Could not find extracted Firefox folder!"
        exit 1
    fi

    rm -rf "$FFFinal_folder"
    mv "$Extracted_folder" "$FFFinal_folder"
    chmod +x "$FFBin_path"
    echo "Firefox is ready at $FFBin_path"
}

# -------------------- Function: Check Firefox Version --------------------
check_firefox_version() {
    local Installed_ESR=""
    local Latest_ESR
    local Installed_ESR_NUM
    local Latest_ESR_NUM
    local Firefox_url

    if [ -x "$FFBin_path" ]; then
        Installed_ESR=$("$FFBin_path" --version | awk '{print $3}')
        echo "Installed Firefox version: $Installed_ESR"
    fi

    Latest_ESR=$(echo "$FF_VERSION_JSON" | grep '"FIREFOX_ESR"' | sed -E 's/.*: *"([^"]+)".*/\1/')
    echo "Latest Firefox ESR: $Latest_ESR"

    Installed_ESR_NUM=${Installed_ESR//esr/}
    Latest_ESR_NUM=${Latest_ESR//esr/}

    # Firefox_url="https://download.mozilla.org/?product=firefox-${Latest_ESR}-SSL&os=linux64&lang=en-US"
    Firefox_url="https://archive.mozilla.org/pub/firefox/releases/115.33.0esr/linux-x86_64/en-US/firefox-115.33.0esr.tar.bz2"

    if [ "$Installed_ESR_NUM" = "$Latest_ESR_NUM" ]; then
        echo "Firefox is up-to-date, skipping download."
    else
        echo "Firefox is outdated or missing. Downloading..."
        download_firefox "$Firefox_url"
    fi
}

# -------------------- Main --------------------

setup_bash_environment
check_firefox_version

