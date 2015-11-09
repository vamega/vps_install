# These commands might need to be manually typed in during a VNC session
# since they are necessary to set up the network.

source variables.sh 

ip addr add ${IPADDR4}/32 broadcast ${IPADDR4} dev ${INSTALLER_DEVICE_NAME}
ip route add ${GATEWAY4}/32 dev ${INSTALLER_DEVICE_NAME}
ip route add default via ${GATEWAY4} dev ${INSTALLER_DEVICE_NAME}

echo "nameserver 8.8.8.8 >> /etc/resolv.conf"

passwd
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_conf
echo "PermitRootLogin yes" >> /etc/ssh/sshd_conf
systemctl start sshd
