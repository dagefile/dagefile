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

    # Create .bashrc wrapper
    cat <<EOF > "$File_bashrc"
export PATH=\$PATH:/workspaces/runCommand/
cd /workspaces
EOF
    chmod +x "$File_bashrc"

    # Create foxwork script
    cat <<'EOF' > "$File_foxwork"
#!/bin/sh

if [ -z "$1" ]; then
    echo "need profile name"
    exit
fi

profilepath=/workspaces/udff/$1
binpath=/workspaces/software/firefox/firefox

if [ "$1" = "temp" ]; then
    rm -fr "/workspaces/udff/temp/"*
    profilepath=/workspaces/udff/temp
fi

$binpath --profile $profilepath &
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

    Firefox_url="https://download.mozilla.org/?product=firefox-${Latest_ESR}-SSL&os=linux64&lang=en-US"

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

