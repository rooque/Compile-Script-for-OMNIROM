#!/bin/bash

# by Victor Roque <victor.rooque@gmail.com> 

usage() { echo "Usage: bash $0 [-d <device>] [-b <clean|installclean|continue> ] [-t] [-u] [-c]" 1>&2;
echo "-u : Upload Log File";echo "-c : Use pre-built chromium";echo "-t : Use timestamp"; exit 1; }

pre=0
upx=0
contin=0
timex=0

while getopts "hd:b:uct" FLAG; do
  case $FLAG in
    b)
    b=$OPTARG
    echo "[           ${b}             ]"
      ;;
    d)
    d=$OPTARG
    echo "DEVICE =[ ${d} ]"
      ;;
    t)
    timex=1
    echo "Using timestamp."
      ;;
    u)
      upx=1
      echo "Log will be uploaded."
      ;;
    c)
      pre=1
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
     echo "Using pre-built chromium."
      export USE_PREBUILT_CHROMIUM=1 ;
else
      export USE_PREBUILT_CHROMIUM=0 ;
fi


. build/envsetup.sh
lunch omni_${d}-userdebug

if [[ "$b" == 'clean' ]] || [[ "$b" == 'installclean' ]] ;then
make ${b} ;
fi

# You need moreutils to use ts command
# sudo apt-get intall moreutils
DATEX=$(date +"%Y-%m-%d_%H:%M")

if [ ${timex} -eq 1 ]; then
   brunch ${d} | ts "[ %T ]" | tee log_$DATEX.txt    ;
else
   brunch ${d} | tee log_$DATEX.txt
fi



if [ ${upx} -eq 1 ]; then
     echo "Nickname: "
     read nickk
     echo "Uploading log to Paste OMNI..."
     echo "Link -> " | curl -d private=1 -d name=${nickk} -d title=${d}_LOG --data-urlencode text@log_$DATEX.txt http://paste.omnirom.org/api/create  ;
else
      echo "LOG was saved to log_${TIME_NOW}.txt" ;
fi

