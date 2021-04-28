#!/bin/bash
#---------------------------------------------
# Filename: motd.sh
# Date: 2021/04/28
# Author: along
# Description: Display information after login
#---------------------------------------------

function red_echo(){
        echo -e "\033[31;49;1m $1 \033[39;49;0m"
}

function blue_echo(){
        echo -e "\033[34;49;1m $1 \033[39;49;0m"
}

# Get Internal network adaptor's IP.
INTIP_A="10"
INTIP_B="192.168"
INTIP=
get_intip () {
    IPS=`/sbin/ip a | awk '/inet / {if(match($2,"addr")) {print substr($2,6)} else {print $2}}' | awk -F'/' '{print $1}'`
    for myip in $IPS; do
        [ "$myip" = "127.0.0.1" ] && continue
        SUBIP_A=`echo $myip |cut -d "." -f 1`
        SUBIP_B=`echo $myip |cut -d "." -f 1-2`
        for a in $INTIP_A; do
            if [ $SUBIP_A == $a ]; then
                INTIP="$INTIP $myip"
            fi
        done
        for b in $INTIP_B; do
            if [ $SUBIP_B == $b ]; then
                INTIP="$INTIP $myip"
            fi
        done
    done
    echo $INTIP
}

get_osinfo () {
    osinfo=`cat /etc/redhat-release`
    if [ $? -eq 0 ]; then
        echo $osinfo
        return 0
    fi
    source /etc/os-release &> /dev/null
    if [ $? -eq 0 ]; then
        osinfo=$PRETTY_NAME
        echo $osinfo
        return 0
    fi
}

intip=`get_intip`
mem=`free -m | fgrep "Mem:" | awk '{print $2}'`
cpucores=`cat /proc/cpuinfo | grep processor | wc -l`
osinfo=`get_osinfo`

blue_echo "================================================================="
red_echo  "
    内网IP:     ${intip}
    内存:       ${mem}M
    CPU:        ${cpucores}核
    操作系统:   ${osinfo}
"
blue_echo "================================================================="
