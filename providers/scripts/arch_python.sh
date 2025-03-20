
pacman -Syu --noconfirm
pacman -S --noconfirm python reflector

# cp /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/mirrorlist  
/usr/bin/reflector --verbose  --country $1 --latest 5 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

echo "" > /etc/xdg/reflector/reflector.conf
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--country $1" >> /etc/xdg/reflector/reflector.conf
echo "--latest 5" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf

/usr/bin/systemctl enable reflector.service
/usr/bin/systemctl enable reflector.timer

/usr/bin/systemctl enable sshd.service