#!/bin/bash

# L2TP VPN 管理脚本
function show_menu() {
    clear
    echo "============================="
    echo " L2TP 管理菜单"
    echo " QQ群：609972590"
    echo "============================="
    echo "1. 安装 L2TP "
    echo "2. 卸载 L2TP "
    echo "3. 查看 VPN 配置"
    echo "4. 退出菜单"
    echo "============================="
}

while true; do
    show_menu
    read -p "请输入选项 [1-4]: " choice
    
    case $choice in
        1)
            echo -e "\n\033[33m正在安装 L2TP (需要root权限)...\033[0m"
            if bash <(curl -sL https://raw.githubusercontent.com/yanpengcloud/scoks/main/l2tp.sh); then
                echo -e "\n\033[32m安装成功！配置已保存到 l2tp.txt\033[0m"
            else
                echo -e "\n\033[31m安装失败，请检查网络或权限\033[0m"
            fi
            ;;
        2)
            echo -e "\n\033[33m正在卸载 L2TP (需要root权限)...\033[0m"
            if bash <(curl -sL https://raw.githubusercontent.com/yanpengcloud/scoks/main/l2tpxz.sh); then
                echo -e "\n\033[32m卸载完成！\033[0m"
            else
                echo -e "\n\033[31m卸载过程中出错\033[0m"
            fi
            ;;
        3)
            echo -e "\n\033[36m==========  配置信息 ==========\033[0m"
            if [ -f "l2tp.txt" ]; then
                cat l2tp.txt
                echo -e "\033[36m==================================\033[0m"
            else
                echo -e "\033[31m未找到配置文件 l2tp.txt\033[0m"
                echo -e "\033[33m请先执行安装操作\033[0m"
            fi
            ;;
        4)
            echo -e "\n\033[32m已退出管理菜单\033[0m"
            exit 0
            ;;
        *)
            echo -e "\n\033[31m无效选项，请重新输入\033[0m"
            ;;
    esac
    
    echo
    read -p "按回车键继续..."
done
