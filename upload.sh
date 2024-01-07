#!/bin/bash
UPLOAD(){
name=$1
fpath=$2
rpath=$3
spath=$4
num=$5
size=$6
hash=$7
loc=$8
tag=$9
drivename=feng687
day=$(date +%Y-%m-%d)
thread=4
time1=0
RED_FONT_PREFIX="\033[31m"
LIGHT_GREEN_FONT_PREFIX="\033[1;32m"
YELLOW_FONT_PREFIX="\033[1;33m"
LIGHT_PURPLE_FONT_PREFIX="\033[1;35m"
FONT_COLOR_SUFFIX="\033[0m"
#[[ -n ${loc} ]] && [[thread="${loc}"]]
if [ -n "$loc" ];then
  drivename=${loc}
fi
if [ -n "$tag" ];then
  $tag=0
fi
echo -e "
$(date "+%m/%d %H:%M:%S")
name=${name}
fpath=${fpath}
rpath=${rpath}
spath=${spath}
num=${num}
size=${size}
hash=${hash}
loc=${loc}
tag=${tag}
drivename=${drivename}
" >> "/root/file.log"
echo -e "${LIGHT_PURPLE_FONT_PREFIX}$(date "+%m/%d %H:%M:%S")${FONT_COLOR_SUFFIX} ${name} Download ${LIGHT_GREEN_FONT_PREFIX}Finish${FONT_COLOR_SUFFIX}!!!" >> "/root/upload.log"
time1=${LIGHT_PURPLE_FONT_PREFIX}$(date "+%m/%d %H:%M:%S")${FONT_COLOR_SUFFIX}
RETRY=0
RETRY_NUM=3
    while [ ${RETRY} -le ${RETRY_NUM} ];do
    	[ ${RETRY} != 0 ] && 
    	( echo -e "${LIGHT_PURPLE_FONT_PREFIX}$(date "+%m/%d %H:%M:%S")${FONT_COLOR_SUFFIX} ERROR ${name} Upload failed!!! Retry ${RETRY}/${RETRY_NUM} ..." >> "/root/upload.log")
    	rclone move -v "${fpath}" "${drivename}:/${day}/${tag}+${name}" --log-file="/root/log" --transfers="${thread}" --exclude "*.!qB" 
    	RCLONE_EXIT_CODE=$?
    	[ ${RETRY} == 0 ] && (echo -e "${LIGHT_PURPLE_FONT_PREFIX}$(date "+%m/%d %H:%M:%S")${FONT_COLOR_SUFFIX} rclone move -v "${fpath}" "${drivename}:/${day}/${tag}+${name}" --log-file="/root/log" --transfers="${thread}" --exclude "*.!qB" ">>"/root/upload.log") && 
      (echo -e "*******************************************************************************">>"/root/show.log")&& (echo -e "${time1} ${name} Download ${LIGHT_GREEN_FONT_PREFIX}Finish${FONT_COLOR_SUFFIX}!!!" >> "/root/show.log")
    	if [ ${RCLONE_EXIT_CODE} -eq 0 ];then
    		echo -e "${LIGHT_PURPLE_FONT_PREFIX}$(date "+%m/%d %H:%M:%S")${FONT_COLOR_SUFFIX} ${LIGHT_GREEN_FONT_PREFIX}SUCCESS${FONT_COLOR_SUFFIX} ${name} Upload done!!!" |tee -a "/root/upload.log" "/root/show.log"
        rm -r "${fpath}"
    		break
    	else
    		RETRY=$((${RETRY} + 1))
    		[ ${RETRY} -gt ${RETRY_NUM} ] && 
    		(echo -e "${LIGHT_PURPLE_FONT_PREFIX}$(date "+%m/%d %H:%M:%S")${FONT_COLOR_SUFFIX} ${RED_FONT_PREFIX}FAILURE${FONT_COLOR_SUFFIX} ${name} Upload failed!!!" |tee -a "/root/upload.log" "/root/show.log")
    		sleep 3
    	fi
    done
      echo -e "${LIGHT_PURPLE_FONT_PREFIX}$(date "+%m/%d %H:%M:%S")${FONT_COLOR_SUFFIX} ${fpath} --->  "${drivename}:/${day}/${tag}+${name}" ">>"/root/show.log"
      echo -e "*******************************************************************************">>"/root/show.log"
      echo -e "">>"/root/show.log"
}

UPLOAD "$@"
