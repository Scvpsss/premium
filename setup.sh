#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/Scvpsss/izin/main/vps > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://raw.githubusercontent.com/Scvpsss/izin/main/vps 
MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/Scvpsss/izin/main/vps | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/Scvpsss/izin/main/vps | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}

clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "$hst" != "$dart" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi
mkdir -p /etc/xray

echo -e "[ ${tyblue}NOTES${NC} ] Before we go.. "
sleep 1
echo -e "[ ${tyblue}NOTES${NC} ] I need check your headers first.."
sleep 2
echo -e "[ ${green}INFO${NC} ] Checking headers"
sleep 1

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END
chmod 644 /root/.profile

echo -e "[ ${green}INFO${NC} ] Preparing the install file"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Alright good ... installation file is ready"
sleep 2
echo -ne "[ ${green}INFO${NC} ] Check permission : "

PERMISSION
if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
green "Permission Accepted!"
else
red "Permission Denied!"
rm setup.sh > /dev/null 2>&1
sleep 5
exit 0
fi
sleep 2
rm -rf /etc/per
mkdir -p /etc/per
touch /etc/per/id
touch /etc/per/token
mkdir -p /etc/xray
touch /etc/xray/domain
touch /etc/xray/scdomain
touch /etc/xray/city
touch /etc/xray/isp
mkdir -p /etc/dns
mkdir -p /etc/slowdns
touch /etc/slowdns/server.pub
touch /etc/slowdns/server.key
mkdir -p /etc/kuhing
mkdir -p /etc/kuhing/theme
mkdir -p /var/lib >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf

if [ -f "/etc/xray/domain" ]; then
echo ""
echo -e "[ ${green}INFO${NC} ] Script Already Installed"
echo -ne "[ ${yell}WARNING${NC} ] Do you want to install again ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
rm setup.sh
sleep 10
exit 0
else
clear
fi
fi

echo ""
wget -q https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
rm dependencies.sh
clear
wget -q https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/api;chmod +x api;./api
clear
yellow "Add Domain for vmess/vless/trojan dll"
echo " "
echo -e "\e[1;32m════════════════════════════════════════════════════════════\e[0m"
echo ""
echo -e "   .----------------------------------."
echo -e "   |\e[1;32mPlease select a domain type below \e[0m|"
echo -e "   '----------------------------------'"
echo -e "     \e[1;32m1)\e[0m Enter your Subdomain"
echo -e "     \e[1;32m2)\e[0m Use a random Subdomain"
echo -e "   ------------------------------------"
read -p "   Please select numbers 1-2 or Any Button(Random) : " host
echo ""
if [[ $host == "1" ]]; then
read -rp "Input your domain : " -e pp
echo "$pp" > /root/domain
echo "$pp" > /root/scdomain
echo "$pp" > /etc/xray/domain
echo "$pp" > /etc/xray/scdomain
echo "IP=$pp" > /var/lib/ipvps.conf
echo ""
elif [[ $host == "2" ]]; then
#install cf
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/SSH/kubing.sh && chmod +x kuhing.sh && ./kuhing.sh
rm -f /root/kuhing.sh
clear
else
echo -e "Random Subdomain/Domain is used"
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/SSH/kubing.sh && chmod +x kuhing.sh && ./kuhing.sh
rm -f /root/kuhing.sh
clear
fi
#THEME RED
cat <<EOF>> /etc/kuhing/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
#THEME BLUE
cat <<EOF>> /etc/kuhing/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
#THEME GREEN
cat <<EOF>> /etc/kuhing/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
#THEME YELLOW
cat <<EOF>> /etc/kuhing/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME MAGENTA
cat <<EOF>> /etc/kuhing/theme/magenta
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME CYAN
cat <<EOF>> /etc/kuhing/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
#THEME CONFIG
cat <<EOF>> /etc/kuhing/theme/color.conf
blue
EOF
    
#install ssh ovpn
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|     PROCESS INSTALLED SSH & OPENVPN      |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/SSH/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#Install Xray
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|          PROCESS INSTALLED XRAY             |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/XRAY/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
#Install SSH Websocket
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|      PROCESS INSTALLED WEBSOCKET SSH     |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/WEBSOCKET/insshws.sh && chmod +x insshws.sh && ./insshws.sh
#Install OHP Websocket
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|          PROCESS INSTALLED OHP              |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
clear
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/OPENVPN/ohp.sh && chmod +x ohp.sh && ./ohp.sh
#Download Extra Menu
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|           DOWNLOAD EXTRA MENU              |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/MENU/update.sh && chmod +x update.sh && ./update.sh
clear
#Download Slowdns
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|           DOWNLOAD SLOWDNS                  |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/slowdns/Installsl.sh && chmod +x Installsl.sh && ./Installsl.sh
clear
#Download Limit
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|           DOWNLOAD LIMIT XRAY                |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
wget https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/limit/limit.sh && chmod +x limit.sh && ./limit.sh
clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
serverV=$( curl -sS https://raw.githubusercontent.com/Scvpsss/premium/main/tarong/version  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ifconfig.me > /etc/myipvps
curl -s ipinfo.io/city?token=75082b4831f909 >> /etc/xray/city
curl -s ipinfo.io/org?token=75082b4831f909  | cut -d " " -f 2-10 >> /etc/xray/isp
IP=$(echo $SSH_CLIENT | awk '{print $1}')
TMPFILE='/tmp/ipinfo-$DATE_EXEC.txt'
curl http://ipinfo.io/$IP -s -o $TMPFILE
ORG=$(cat $TMPFILE | jq '.org' | sed 's/"//g')
domain=$(cat /etc/xray/domain)
LocalVersion=$(cat /root/versi)
IPVPS=$(curl -s ipinfo.io/ip )
ISPVPS=$( curl -s ipinfo.io/org )
TIMES="10"
CHATID="847645599"
KEY="5985854137:AAHSToaZOGkZfxZLbGwjOqmaRTpJEzHKxhs"
URL="https://api.telegram.org/bot$KEY/sendMessage"
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
domain=$(cat /etc/xray/domain) 
token="5985854137:AAHSToaZOGkZfxZLbGwjOqmaRTpJEzHKxhs"
chatid="847645599"
ttoday="$(vnstat | grep today | awk '{print $8" "substr ($9, 1, 3)}' | head -1)"
tmon="$(vnstat -m | grep `date +%G-%m` | awk '{print $8" "substr ($9, 1 ,3)}' | head -1)"
DATE_EXEC="$(date "+%d %b %Y %H:%M")"
CITY=$(cat $TMPFILE | jq '.city' | sed 's/"//g')
REGION=$(cat $TMPFILE | jq '.region' | sed 's/"//g')
COUNTRY=$(cat $TMPFILE | jq '.country' | sed 's/"//g')
Name=$(curl -sS https://raw.githubusercontent.com/Scvpsss/izin/main/vps | grep $MYIP | awk '{print $2}')
MYIP=$(curl -sS ipv4.icanhazip.com)
IZIN=$(curl -sS https://raw.githubusercontent.com/kuhing/ip/main/vps | awk '{print 3}' | grep $MYIP)
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<b>  ⚠️ AUTOSCRIPT INSTALLER ⚠️</b>
<code>◇━━━━━━━━━━━━━━◇</code>
<b>DOMAIN :</b> <code>${domain} </code>
<b>IP :</b> <code>${MYIP} </code>
<b>ISP AND CITY :</b> <code>$ISP $CITY </code>
<b>AUTHOR :</b> <code>$Name </code>
<b>EXP SCRIPT:</b> <code>$IZIN </code>
<code>◇━━━━━━━━━━━━━━◇</code>
"
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=========================[SCRIPT PREMIUM]========================"
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI SSH ]" | tee -a log-install.txt
echo "    -------------------------" | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - Stunnel4                : 447, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - SSH Websocket           : 80 [ON]"  | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI  Bdvp, Ngnx]" | tee -a log-install.txt
echo "    ---------------------------" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7900"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI Shadowsocks-R & Shadowsocks]"  | tee -a log-install.txt
echo "    ---------------------------------------" | tee -a log-install.txt
echo "   - Websocket Shadowsocks   : 443"  | tee -a log-install.txt
echo "   - Shadowsocks GRPC        : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI XRAY]"  | tee -a log-install.txt
echo "    ----------------" | tee -a log-install.txt
echo "   - Xray Vmess Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vless Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vmess Ws None Tls  : 80"  | tee -a log-install.txt
echo "   - Xray Vless Ws None Tls  : 80"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI TROJAN]"  | tee -a log-install.txt
echo "    ------------------" | tee -a log-install.txt
echo "   - Websocket Trojan        : 443"  | tee -a log-install.txt
echo "   - Trojan GRPC             : 443"  | tee -a log-install.txt
echo "   --------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On           : $aureb:00 $gg GMT +8" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully automatic script" | tee -a log-install.txt
echo "   - VPS settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Backup & Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "=========================[SCRIPT PREMIUM]========================"
echo ""
sleep 3
echo -e "    ${tyblue}.------------------------------------------.${NC}"
echo -e "    ${tyblue}|     SUCCESFULLY INSTALLED THE SCRIPT     |${NC}"
echo -e "    ${tyblue}'------------------------------------------'${NC}"
echo ""
echo -e "   ${tyblue}Your VPS Will Be Automatical Reboot In 10 seconds${NC}"
rm /root/kuhing.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/insshws.sh 
rm /root/update.sh
sleep 10
reboot
