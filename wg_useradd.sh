#!/bin/bash
echo "This script needs to run with root privelages to have access to the wireguard command and directory."
echo "Please ensure you run this script with 'sudo'."
echo "This script relies on qrencode to produce a QR code at the end."
echo "Please provide a name for the new profile:"
read name
##################################################################
# up to a valid 8 bit integer for the final IP address increment #
##################################################################
echo "What is the IP address increment:"
read ipincrement

cd /etc/wireguard
pwd
umask 077

############################################################
# generate the public private key pair for your new client #
############################################################
wg genkey | tee ${name}.key | wg pubkey > ${name}.pub
############################################################
# generate a pre shared key for your client                #
############################################################
wg genpsk > ${name}.psk

###########################################################
# append your client as a peer to your SERVER config file #
###########################################################

echo "# ${name} client config" >> /etc/wireguard/wg0.conf
echo "[Peer]" >> /etc/wireguard/wg0.conf
##############################################
# change the config file name as appropriate #
##############################################
echo "PublicKey = $(cat ${name}.pub)" >> /etc/wireguard/wg0.conf
echo "PresharedKey = $(cat "${name}.psk")" >> /etc/wireguard/wg0.conf
##############################################################
# INCREMENT YOUR IP ADDRESSESS AS APPROPRIATE TO YOUR CONFIG #
##############################################################
echo "AllowedIPs = 10.100.0.${ipincrement}/32, fd08:4711::${ipincrement}/128" >> /etc/wireguard/wg0.conf

# create a client config file
echo "[Interface]" > "${name}.conf"
echo "Address = 10.100.0.${ipincrement}/32, fd08:4711::${ipincrement}/128" >> "${name}.conf"
####################################################
# Replace DNS_SERVER with your DNS Servers address #
####################################################
echo "DNS = DNS_SERVER_ADDRESS" >> "${name}.conf"
echo "PrivateKey = $(cat "${name}.key")" >> "${name}.conf"

echo "[Peer]" >> "${name}.conf"
#########################################################
# add your server ip address here as well as you home   #
# ip address range if you want access to network too    #
# ip ranges and addresses seperated by a comma          #
#########################################################
echo "AllowedIPs = 10.100.0.0/24, fd08:4711::/64" >> "${name}.conf"
################################################################
# Replace PUBLIC_UP with your public ip address or domain here #
# and replace 11111 with the appropriate port                  #
################################################################
echo "Endpoint = PUBLIC_IP:11111" >> "${name}.conf"
echo "PersistentKeepalive = 25" >> "${name}.conf"
echo "PublicKey = $(cat server.pub)" >> "${name}.conf"
echo "PresharedKey = $(cat "${name}.psk")" >> "${name}.conf"

#################################################################
# generate a QR code for scanning on a mobile device (optional) #
#################################################################
qrencode -t ansiutf8 < "/etc/wireguard/${name}.conf"
