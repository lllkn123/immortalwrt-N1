#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.99/g' package/base-files/files/bin/config_generate

# Add customize command
sed -i 's/alF/alhF/' package/base-files/files/etc/profile
cat >> package/base-files/files/etc/profile <<EOF

# Change directory aliases
[ -d /mnt/mmcblk2p4 ] && alias 2p4='cd /mnt/mmcblk2p4'
[ -d /mnt/sda1 ] && alias sda1='cd /mnt/sda1'
alias bd='cd "\$OLDPWD"'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# alias chmod commands
alias mx='chmod +x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Copy and go to the directory
cpg ()
{
    if [ -d "\$2" ];then
        cp \$1 \$2 && cd \$2
    else
        cp \$1 \$2
    fi
}

# Move and go to the directory
mvg ()
{
    if [ -d "\$2" ];then
        mv \$1 \$2 && cd \$2
    else
        mv \$1 \$2
    fi
}

# Create and go to the directory
mkdirg ()
{
    mkdir -p \$1
    cd \$1
}

# History search ↑ ↓
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
EOF

# Change banner
sed -i '/openwrt_banner/i\echo "" > /etc/banner\
echo "[34mImmortalwrt[0m $(uname -r)" >> /etc/banner\
echo "" >> /etc/banner\
' package/emortal/default-settings/files/99-default-settings

# Modify vim
cp -rf ${GITHUB_WORKSPACE}/general/vim/.vim package/base-files/files/etc/
cp -f ${GITHUB_WORKSPACE}/general/vim/.vimrc package/base-files/files/etc/
sed -i '/exit/i\mv /etc/.vimrc /root/\
mv /etc/.vim /root/\
' package/emortal/default-settings/files/99-default-settings

./scripts/feeds update -a
./scripts/feeds install -a