#!/bin/bash

# socks5_manager.sh - 集成多IP绑定和Socks5服务管理
# 功能：1.绑定多IP 2.搭建Socks5服务 3.退出

# 绑定IP脚本URL
BIND_URL="https://raw.gitcode.com/2401_89691644/socks5/raw/main/bind.sh"
# Socks5相关URL
SK5_BIN_URL="https://lfs-cdn.gitcode.com/lfs-objects/4b/ed/bb1fa52a5647fe6a2587c0ee0a2834298f699e8ae6e9ee66ba985c602824?certificate=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQcm9qZWN0UGF0aCI6IjI0MDFfODk2OTE2NDQvc29ja3M1IiwiT2lkIjoiNGJlZGJiMWZhNTJhNTY0N2ZlNmEyNTg3YzBlZTBhMjgzNDI5OGY2OTllOGFlNmU5ZWU2NmJhOTg1YzYwMjgyNCIsIlVzZXJOYW1lIjoiMjQwMV84OTY5MTY0NCIsIlJlYWxVc2VyTmFtZSI6IjI0MDFfODk2OTE2NDQiLCJPcGVyYXRpb24iOiJkb3dubG9hZCIsIlByb2plY3RJRCI6MCwiUmVwb1R5cGUiOjAsIlNpemUiOjAsIlRpbWUiOjE3NTE2MTkxMzMsImV4cCI6MTc1MTYyMjczMywiaXNzIjoibGZzLXN2ciJ9.ojF0LRsoBM3BEu8M-1QvRZOD8mOCaMAL97b-LtFY7jo&username=2401_89691644&auth_key=1751619133-59b441d585f64a9db76e5ced00f5eb85-0-9d3345b284ac0fce5edb3d24437a660157f67d809bbfe1fa2a87c49730af155b&filename=sk5"
SK5_SH_URL="https://raw.gitcode.com/2401_89691644/socks5/raw/main/sk5.sh"

# 修复文件格式函数
fix_file_format() {
    local file=$1
    if [ -f "$file" ]; then
        # 检查并移除Windows回车符
        if grep -q $'\r' "$file"; then
            echo "修复 $file 的格式 (移除Windows回车符)..."
            sed -i 's/\r$//' "$file"
        fi
        # 确保可执行权限
        chmod +x "$file"
    fi
}

# 检查并下载文件函数
download_file() {
    local url=$1
    local filename=$2
    
    if [ -f "$filename" ]; then
        echo "文件 $filename 已存在，跳过下载。"
        fix_file_format "$filename"  # 修复已有文件的格式
        return 0
    fi
    
    echo "正在下载 $filename ..."
    if wget -q --timeout=10 --tries=3 "$url" -O "$filename"; then
        fix_file_format "$filename"  # 修复新下载文件的格式
        echo "下载成功: $filename"
        return 0
    else
        echo "错误: 下载失败! 请检查网络或URL: $url"
        return 1
    fi
}

# 绑定多IP功能
bind_ips() {
    echo -e "\n[绑定多IP]"
    
    # 检查ip.txt文件
    if [ ! -f "ip.txt" ]; then
        echo "错误: 未找到ip.txt文件!"
        echo "请创建ip.txt文件，格式每行为: [私网IP] [网卡名称]"
        echo "示例:"
        echo "192.168.1.100 eth0"
        echo "192.168.1.101 eth0"
        return 1
    fi

    # 下载绑定脚本
    download_file "$BIND_URL" "bind.sh" || return 1
    
    # 执行绑定
    echo "正在执行IP绑定..."
    ./bind.sh
}

# 搭建Socks5服务
setup_socks5() {
    echo -e "\n[搭建Socks5服务]"
    
    # 下载并安装sk5二进制
    echo "正在安装sk5主程序到/usr/local/bin..."
    if wget -q --timeout=10 --tries=3 "$SK5_BIN_URL" -O /usr/local/bin/sk5; then
        chmod +x /usr/local/bin/sk5
        echo "sk5主程序已安装到/usr/local/bin目录！"
    else
        echo "错误: sk5主程序下载失败！"
        return 1
    fi

    # 下载安装脚本
    echo "下载sk5安装脚本..."
    if wget -q --timeout=10 --tries=3 "$SK5_SH_URL" -O sk5_install.sh; then
        fix_file_format "sk5_install.sh"  # 修复脚本格式
        echo "运行安装脚本..."
        ./sk5_install.sh
        echo "Socks5服务安装完成！"
    else
        echo "错误: sk5安装脚本下载失败！"
        return 1
    fi
    
    # 清理临时文件
    rm -f sk5_install.sh
}

# 主菜单
while true; do
    echo -e "\n========== Socks5 管理菜单 =========="
    echo "1. 绑定多IP到网卡"
    echo "2. 搭建Socks5代理服务"
    echo "3. 退出"
    echo "====================================="
    
    read -p "请输入选项 (1-3): " choice
    
    case $choice in
        1) bind_ips ;;
        2) setup_socks5 ;;
        3) echo "已退出菜单"; exit 0 ;;
        *) echo "无效选项，请重新输入！" ;;
    esac
done
