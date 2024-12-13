#!/bin/bash

cd "$HOME" || exit

mkdir temp_____

cd temp_____ || exit
rm -rf francinette

# download github
git clone --recursive https://github.com/xicodomingues/francinette.git

if [ "$(uname)" != "Darwin" ]; then
        echo "Admin permissions needed to install C compilers, python, and upgrade current packages"
        case $(lsb_release -is) in
                "Ubuntu")
                        sudo apt update
                        sudo apt upgrade
                        sudo apt install gcc clang libpq-dev libbsd-dev libncurses-dev valgrind -y
                        sudo apt install python-dev python3-pip -y
                        sudo apt install python3-dev python3-venv python3-wheel -y
                        pip3 install wheel
                        ;;
                "Arch")
                        sudo pacman -Syu
                        sudo pacman -S gcc clang postgresql libbsd ncurses valgrind --noconfirm
                        sudo pacman -S python-pip --noconfirm
                        pip3 install wheel
                        ;;
        esac
fi

cp -r francinette "$HOME"

cd "$HOME" || exit
rm -rf temp_____

cd "$HOME"/francinette || exit

python3 -m pip install --user virtualenv

# start a venv inside francinette
if ! python3 -m virtualenv francinette-env ; then
        echo "Bu installer python virtual env kullanmak yerine virtualen tool unu kullanır."
        echo 'Sorununuz hala çözülmemişse whatsapp üzerinden irtibata geçin 05530028324'
        exit 1
fi

# activate venv
source francinette-env/bin/activate

# install requirements
if ! pip3 install -r requirements.txt ; then
        echo 'Problem launching the installer. Contact me (fsoares- on slack)'
        exit 1
fi

RC_FILE="$HOME/.zshrc"

if [ "$(uname)" != "Darwin" ]; then
        RC_FILE="$HOME/.bashrc"
        if [[ -f "$HOME/.zshrc" ]]; then
                RC_FILE="$HOME/.zshrc"
        fi
fi

echo "Trying to add alias and PATH to file: $RC_FILE"

# Add the PATH to ~/.zshrc or ~/.bashrc (make it permanent)
NEW_PATHS="/home/aaycan/francinette:/home/aaycan/francinette/francinette-env/bin"

for path in $(echo $NEW_PATHS | tr ":" "\n")
do
    if ! grep -q "$path" "$RC_FILE"; then
        echo "export PATH=\$PATH:$path" >> "$RC_FILE"
        echo "$path added to $RC_FILE"
    else
        echo "$path already exists in $RC_FILE"
    fi
done

# set up the alias
if ! grep "francinette=" "$RC_FILE" &> /dev/null; then
        echo "francinette alias not present"
        printf "\nalias francinette=%s/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

if ! grep "paco=" "$RC_FILE" &> /dev/null; then
        echo "Short alias not present. Adding it"
        printf "\nalias paco=%s/francinette/tester.sh\n" "$HOME" >> "$RC_FILE"
fi

# print help
"$HOME"/francinette/tester.sh --help

echo -e "\e[32mFrancinette Path e kalıcı olarak eklendi !\e[0m"
echo -e "\e[32mFrancinette has been added to path\e[0m"
echo -e "\e[32mThis installer uses the virtualenv tool instead of Python's virtualenv.\e[0m"
echo -e "\e[32mBu installer python venv kullanmak yerine virtualinv tool unu kullanır\e[0m"
echo -e "\e[32mIf you are still having issues, please contact me on WhatsApp: +905530028324\e[0m"
echo -e "\e[32mFrancinett hala kurulmuyorsa whatsapp uzerinden bana ulasabilirsiniz 05530028324\e[0m"

# automatically replace current shell with new one.
exec "$SHELL"

printf "\033[33m... and don't forget, \033[1;37mpaco\033[0;33m is not a replacement for your own tests! \033[0m\n"
