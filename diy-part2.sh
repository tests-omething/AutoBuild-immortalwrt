#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#


# 移除要替换的包
# rm -rf feeds/packages/net/v2ray-geodata

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# 添加额外插件
# 添加 design 主题
git clone -b js --single-branch https://github.com/gngpp/luci-theme-design package/luci-theme-design
# 添加 alpha 主题
git clone https://github.com/derisamedia/luci-theme-alpha.git package/luci-theme-alpha
# 添加 万能推送
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-pushbot
# 添加关机插件
#git clone https://github.com/VPN-V2Ray/luci-app-poweroff.git package/luci-app-poweroff
# 添加passwall2
git clone https://github.com/xiaorouji/openwrt-passwall2.git package/luci-app-passwall2
#添加adguardhome
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome

#加入turboacc
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh
chmod -R 777 add_turboacc.sh
./add_turboacc.sh

# 加入OpenClash核心
chmod -R a+x $GITHUB_WORKSPACE/preset-clash-core.sh
$GITHUB_WORKSPACE/preset-clash-core.sh

#通过 echo 命令 将以下内容发送到.config文件中，.config文件里面有 所有makefile文件的编译开关以及依赖项等等元数据！也可以通过make menuconfig(图形界面)来生成.config文件！

echo "
# 主题
CONFIG_PACKAGE_luci-theme-design=y

CONFIG_PACKAGE_luci-theme-argon=y

CONFIG_PACKAGE_luci-theme-material=y

CONFIG_PACKAGE_luci-theme-openwrt-2020=y

CONFIG_PACKAGE_luci-theme-alpha=y

CONFIG_PACKAGE_luci-theme-bootstrap-mod=y

# 万能推送
CONFIG_PACKAGE_luci-app-pushbot=y

# 关机插件
#CONFIG_PACKAGE_luci-app-poweroff=y

#openclash
CONFIG_PACKAGE_luci-app-openclash=y

# passwall2
CONFIG_PACKAGE_luci-app-passwall2=y

#adguardhome
CONFIG_PACKAGE_luci-app-adguardhome=y

# TurboAcc
CONFIG_PACKAGE_luci-app-turboacc=y

#netdata
CONFIG_PACKAGE_luci-app-netdata=y

# mosdns
CONFIG_PACKAGE_luci-app-mosdns=y

# pushbot
CONFIG_PACKAGE_luci-app-pushbot=y

# 阿里DDNS
CONFIG_PACKAGE_luci-app-aliddns=y

# Jellyfin
#CONFIG_PACKAGE_luci-app-jellyfin=y

# 易有云
CONFIG_PACKAGE_luci-app-linkease=y

" >> .config

# 修改默认IP
sed -i 's/192.168.1.1/10.0.0.1/g' package/base-files/files/bin/config_generate

# 修改默认子网掩码
sed -i 's/255.255.255.0/255.255.252.0/g' package/base-files/files/bin/config_generate

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改主机名
sed -i 's/ImmortalWrt/ImmortalWrt_T/g' package/base-files/files/bin/config_generate

# 修改Ping 默认网址 immortalwrt.org
#cat feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_network/diagnostics.htm

# 修改系统信息
cp -f $GITHUB_WORKSPACE/99-default-settings package/emortal/default-settings/files/99-default-settings
cp -f $GITHUB_WORKSPACE/banner package/base-files/files/etc/banner

# 修改主题背景
cp -f $GITHUB_WORKSPACE/argon/img/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg
cp -f $GITHUB_WORKSPACE/argon/img/argon.svg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/argon.svg
cp -f $GITHUB_WORKSPACE/argon/favicon.ico feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/favicon.ico
cp -f $GITHUB_WORKSPACE/argon/icon/android-icon-192x192.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/android-icon-192x192.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-144x144.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-144x144.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-60x60.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-60x60.png
cp -f $GITHUB_WORKSPACE/argon/icon/apple-icon-72x72.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/apple-icon-72x72.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-16x16.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-16x16.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-32x32.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-32x32.png
cp -f $GITHUB_WORKSPACE/argon/icon/favicon-96x96.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/favicon-96x96.png
cp -f $GITHUB_WORKSPACE/argon/icon/ms-icon-144x144.png feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/icon/ms-icon-144x144.png
cp -f $GITHUB_WORKSPACE/argon/favicon.ico package/luci-theme-design/htdocs/luci-static/design/favicon.ico

