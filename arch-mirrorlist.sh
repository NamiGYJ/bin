curl https://raw.githubusercontent.com/Gen2ly/armrr/master/armrr > armrr
chmod +x armrr
./armrr
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.b
rankmirrors /etc/pacman.d/mirrorlist.b > /etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist
