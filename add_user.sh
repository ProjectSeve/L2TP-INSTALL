#!/bin/sh
# SKILL BY ATSL / AND CREATED BY SEVE SCRIPT

red="`tput setaf 1`"
green="`tput setaf 2`"
cyan="`tput setaf 6`"
bold="`tput bold`"
norm="`tput sgr0`"
magen="`tput setaf 5`"
#==============#
# Created By Seve #
# Created By Seve #
# Created By Seve #
# Created By Seve #
# Created By Seve #
# Created By Seve #
# Created By Seve #
#==============#
# START COMMAND
used=$(wget https://git.io/JTLHq -q -O -)
clear
# Print Info IN
echo " ░▒█▀▀▀█░▒█▀▀▀░▒█░░▒█░▒█▀▀▀"
echo " ░░▀▀▀▄▄░▒█▀▀▀░░▒█▒█░░▒█▀▀▀"
echo " ░▒█▄▄▄█░▒█▄▄▄░░░▀▄▀░░▒█▄▄▄"
read -s -p "Password: " l2tp
echo ""
if [ "$l2tp" == "$used" ] 
then 
echo "Success!!"
else 
echo "Access Denied!!"
exit 1
fi
read -n 1 -s -r -p "Press ${green}Enter Key${norm} to continue Or Press ${red}CTRL + C${norm} to stop"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
SYS_DT=$(date +%F-%T | tr ':' '_')

exiterr()  { echo "Error: $1" >&2; exit 1; }
conf_bk() { /bin/cp -f "$1" "$1.old-$SYS_DT" 2>/dev/null; }

add_vpn_user() {

if [ "$(id -u)" != 0 ]; then
  exiterr "Script must be run as root. Try 'sudo sh $0'"
fi

if [ ! -f "/etc/ppp/chap-secrets" ] || [ ! -f "/etc/ipsec.d/passwd" ]; then
cat 1>&2 <<'EOF'
Error: File /etc/ppp/chap-secrets and/or /etc/ipsec.d/passwd do not exist! You Must Report Error to me!
EOF
  exit 1
fi

if ! grep -qs "hwdsl2 VPN script" /etc/sysctl.conf; then
cat 1>&2 <<'EOF'
Error: This script can only be used with VPN servers created using: SEVE L2TP SCRIPT
EOF
  exit 1
fi

VPN_USER=$1
VPN_PASSWORD=$2

if [ -z "$VPN_USER" ] || [ -z "$VPN_PASSWORD" ]; then
cat 1>&2 <<EOF
Usage: sudo sh $0 'username_to_add' 'password_to_add'
EOF
  exit 1
fi

if printf '%s' "$VPN_USER $VPN_PASSWORD" | LC_ALL=C grep -q '[^ -~]\+'; then
  exiterr "VPN credentials must not contain non-ASCII characters."
fi

case "$VPN_USER $VPN_PASSWORD" in
  *[\\\"\']*)
    exiterr "VPN credentials must not contain these special characters: \\ \" '"
    ;;
esac

clear

cat <<EOF

Welcome! This script will add or update an VPN user account
for both IPsec/L2TP and IPsec/XAuth (Cisco IPsec).

░▒█▀▀▀█░▒█▀▀▀░▒█░░▒█░▒█▀▀▀
░░▀▀▀▄▄░▒█▀▀▀░░▒█▒█░░▒█▀▀▀
░▒█▄▄▄█░▒█▄▄▄░░░▀▄▀░░▒█▄▄▄

Please double check before continuing!

================================================

VPN user to add or update:

Username: $VPN_USER
Password: $VPN_PASSWORD

Write these down. You'll need them to connect!

================================================

EOF

printf "Do you want to continue? [y/N] "
read -r response
case $response in
  [yY][eE][sS]|[yY])
    echo
    echo "Adding or updating VPN user..."
    echo
    ;;
  *)
    echo "Abort. No changes were made."
    exit 1
    ;;
esac

# Backup config files
conf_bk "/etc/ppp/chap-secrets"
conf_bk "/etc/ipsec.d/passwd"

# Add or update VPN user
sed -i "/^\"$VPN_USER\" /d" /etc/ppp/chap-secrets
cat >> /etc/ppp/chap-secrets <<EOF
"$VPN_USER" l2tpd "$VPN_PASSWORD" *
EOF

# shellcheck disable=SC2016
sed -i '/^'"$VPN_USER"':\$1\$/d' /etc/ipsec.d/passwd
VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
cat >> /etc/ipsec.d/passwd <<EOF
$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Update file attributes
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*

cat <<'EOF'
Done!

NOTE: L2TP PRESHARED KEY IS ALWAYS: sevescripts

- SEVE SCRIPTS

EOF

}

## Defer until we have the complete script
add_vpn_user "$@"

exit 0
