#!/bin/zsh

echo "[*] install zsh plugins"

installer_path=$PWD
installed_path="${HOME}/.config/dotfiles"

usage() {
    echo "Usage: $0 install [-o install_path]"
    echo "Options:"
    echo "  install             Install gdb tools"
    echo "  -o install_path     Specify install path (default: /tools)"
    exit 1
}

# 인자 확인
if [ "$1" != "install" ]; then
    usage
fi

## 옵션 처리
if [ "$2" = "-o" ]; then
    installed_path="$3"
elif [ "$2" != "" ]; then
    usage
fi

# 설치 경로에 해당하는 폴더가 없으면 생성
if [ ! -d "$installed_path" ]; then
    echo "Creating directory: $installed_path"
    mkdir -p "$installed_path"
fi

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}//plugins/zsh-vi-mode

cd $installer_path

cp config/p10k.zsh ~/.p10k.zsh
cp config/vimrc ~/.vimrc
cp config/zshrc ~/.zshrc
cp config/tmux.conf ~/.tmux.conf
