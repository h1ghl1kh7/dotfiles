#!/bin/zsh

echo "GDB peda, pwndbg, gef integration"

installer_path=$PWD
installed_path="${HOME}/.config/dotfiles"

usage() {
    echo "Usage: $0 [gdb | gef] [-o output_path]"
    echo "Options:"
    echo "  gdb                 Install gdb tools"
    echo "  gef                 Install gef"
    echo "  -o output_path      Specify output path (default: /tools)"
    exit 1
}

if [ "$1" = "gdb" ]; then
    target=$1
    shift
    while getopts "o:" opt; do
        case $opt in
            o)
                installed_path="$OPTARG"
                ;;
            \?)
                usage
                ;;
            :)
                usage
                ;;
        esac
    done
elif [ "$1" = "gef" ]; then
    target=$1
    shift
    while getopts "o:" opt; do
        case $opt in
            o)
                installed_path="$OPTARG"
                ;;
            \?)
                usage
                ;;
            :)
                usage
                ;;
        esac
    done
else
    usage
fi

# check if installed_path exists
echo "[+] path : $installed_path"
if [ ! -d "$installed_path" ]; then
    echo "Creating directory: $installed_path"
    mkdir -p "$installed_path"
fi

echo "[+] Checking for required dependencies..."

# check if git is available
if command -v git >/dev/null 2>&1 ; then
    echo "[-] Git found!"
else
    echo "[-] Git not found! Aborting..."
    echo "[-] Please install git and try again."
    exit 1
fi

# Check if curl or wget is available
if command -v wget >/dev/null 2>&1; then
    wget_found=1
elif command -v curl >/dev/null 2>&1; then
    curl_found=1
else
    echo "[-] Please install cURL or wget and run again"
    exit 1
fi

# Backup gdbinit if any
if [ -f "${HOME}/.gdbinit" ]; then
    mv "${HOME}/.gdbinit" "${HOME}/.gdbinit.old"
fi

if [ $target = "gdb" ]; then
    echo "[*] gdb"

    # Install peda
    if [ -d ${installed_path}/peda ] || [ -h ${installed_path}/peda ]; then
        echo "[+] Pass Download Peda"
    else 
        echo "[+] Download Peda"
        git clone https://github.com/longld/peda.git ${installed_path}/peda
    fi



    # Install pwndbg
    if [ -d ${installed_path}/pwndbg ] || [ -h ${installed_path}/pwndbg ]; then
        echo "[*] Pass Download Pwndbg"
    else
        echo "[+] Download Pwndbg"
        git clone https://github.com/pwndbg/pwndbg.git ${installed_path}/pwndbg

        cd ${installed_path}/pwndbg
        ./setup.sh
    fi

    # Install gef
    if [ -d ${installed_path}/gef ] || [ -h ${installed_path}/gef ]; then
        echo "[*] Pass Download Gef"
    else
        echo "[+] Download Gef"
        wget -O ${installed_path}/gef.py -q https://gef.blah.cat/py
    fi

    cd $installer_path

    echo "[+] Setting .gdbinit..."
    cp gdb/gdbinit ~/.gdbinit
    sed -i "s/WORKDIR/${installed_path//\//\\/}/g" ~/.gdbinit

    {
      echo "[+] Creating files..."
        sudo cp gdb/gdb-peda /usr/bin/local/gdb-peda &&\
        sudo cp gdb/gdb-pwndbg /usr/local/bin/gdb-pwndbg &&\
        sudo cp gdb/gdb-gef /usr/local/bin/gdb-gef
    } || {
      echo "[-] Permission denied"
        exit
    }

    {
      echo "[+] Setting permissions..."
        sudo chmod +x /usr/local/bin/gdb-*
    } || {
      echo "[-] Permission denied"
        exit
    }
fi

if [ $target = "gef" ]; then
    echo "[*] gef"

    if [ $wget_found -eq 1 ]; then
        latest_tag=$(wget -q -O- "https://api.github.com/repos/hugsy/gef/tags" | grep "name" | head -1 | sed -e 's/"name": "\([^"]*\)",/\1/' -e 's/ *//')

        # Get the hash of the commit
        branch="${latest_tag}"
        ref=$(wget -q -O- https://api.github.com/repos/hugsy/gef/git/ref/heads/${branch} | grep '"sha"' | tr -s ' ' | cut -d ' ' -f 3 | tr -d "," | tr -d '"')

        # Download the file
        wget -q "https://github.com/hugsy/gef/raw/${branch}/gef.py" -O "${installed_path}/gef-${ref}.py"
    elif [ $curl_found -eq 1 ]; then
        latest_tag=$(curl -s "https://api.github.com/repos/hugsy/gef/tags" | grep "name" | head -1 | sed -e 's/"name": "\([^"]*\)",/\1/' -e 's/ *//')

        # Get the hash of the commit
        branch="${latest_tag}"
        ref=$(curl --silent https://api.github.com/repos/hugsy/gef/git/ref/heads/${branch} | grep '"sha"' | tr -s ' ' | cut -d ' ' -f 3 | tr -d "," | tr -d '"')

        # Download the file
        curl --silent --location --output "${installed_path}/gef-${ref}.py" "https://github.com/hugsy/gef/raw/${branch}/gef.py"
    fi

    # Create the new gdbinit
    echo "source ${installed_path}/gef-${ref}.py" > ~/.gdbinit

    git clone https://github.com/hugsy/gef-extras ${installed_path}/gef-extras

    echo "[+] Download Pwngdb"
    git clone https://github.com/scwuaptx/Pwngdb.git ${installed_path}/Pwngdb

    cd $installer_path

    echo "[+] Setting .gdbinit & .gef.rc"
    cat gef/gdbinit >> ~/.gdbinit
    sed -i "s/WORKDIR/${installed_path//\//\\/}/g" ~/.gdbinit

    cp gef/gef.rc ~/.gef.rc
    sed -i "s/WORKDIR/${installed_path//\//\\/}/g" ~/.gef.rc
fi

echo "[+] Done"
