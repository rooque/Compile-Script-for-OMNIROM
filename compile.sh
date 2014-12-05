#!/bin/bash

# by Victor Roque <victor.rooque@gmail.com> 

usage() { echo"";echo "Usage: bash $0 [-d <device>] [-b <clean|installclean|continue> ] [-u] [-c] [-p]" 1>&2;
echo "";echo "-u : Upload Log File";echo "-p : Use pre-built chromium";echo "-c : Use CCACHE"; exit 1; }

function box_out() {
  local s="$*"
  tput setaf 3
  echo " -${s//?/-}-
| ${s//?/ } |
| $(tput setaf 4)$s$(tput setaf 3) |
| ${s//?/ } |
 -${s//?/-}-"
  tput sgr 0
}


pre=0
upx=0
contin=0
timex=0
ccc=0

function logox() {
echo "                                     ";
echo "     ██████╗ ███╗   ███╗███╗   ██╗██╗";
echo "    ██╔═══██╗████╗ ████║████╗  ██║██║";
echo "    ██║   ██║██╔████╔██║██╔██╗ ██║██║";
echo "    ██║   ██║██║╚██╔╝██║██║╚██╗██║██║";
echo "    ╚██████╔╝██║ ╚═╝ ██║██║ ╚████║██║";
echo "     ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝";
echo "                                     ";
}

clear
logox

while getopts "hd:b:uctp" FLAG; do
  case $FLAG in
    b)
    b=$OPTARG
    box_out " ${b} "
    sleep 0.625
      ;;
    d)
    d=$OPTARG
    box_out "DEVICE =  ${d} "
    sleep 0.625
      ;;
    t)
    #timex=1
    #box_out " Using timestamp. "
      ;;
    u)
      upx=1
    box_out "Log will be uploaded."
    sleep 0.625 
      ;;
    p)
      pre=1
      ;;
    c)
      ccc=1
      ;;
    h)  #show help
      usage
      ;;
    \?) #unrecognized option - show help
     usage
      ;;
  esac
done


if [ -z "${d}" ] ||  [ -z "${b}" ]; then
    usage
fi

if [ ${pre} -eq 1 ]; then
     box_out "Using pre-built chromium."
      sleep 0.625
      export USE_PREBUILT_CHROMIUM=1 ;
else
      export USE_PREBUILT_CHROMIUM=0 ;
fi
if [ ${ccc} -eq 1 ]; then
     box_out "Using CCACHE."
     sleep 0.625
     export USE_CCACHE=1 ;
else
     export USE_CCACHE=0 ;
fi

clear
logox
box_out "Lunching..."
sleep 0.625

. build/envsetup.sh
lunch omni_${d}-userdebug

if [[ "$b" == 'clean' ]] || [[ "$b" == 'installclean' ]] ;then
make ${b} ;
fi

# You need moreutils to use ts command
# sudo apt-get intall moreutils
DATEX=$(date +"%Y-%m-%d_%H:%M")

clear
logox
box_out "Brunch..."
sleep 0.625


if [ ${timex} -eq 1 ]; then
   brunch ${d} | tee log_$DATEX.txt   ;
else
   brunch ${d} | tee log_$DATEX.txt   ;
fi

clear
logox

if [ ${upx} -eq 1 ]; then
     echo "Enter Nickname to the paste upload : " 
     read nickk
     box_out "Uploading log to Paste OMNI..."
     curl -d private=1 -d name=${nickk} -d title=${d}_LOG --data-urlencode text@log_$DATEX.txt http://paste.omnirom.org/api/create  ;
else
     box_out "LOG was saved to log_${TIME_NOW}.txt" ;
fi

