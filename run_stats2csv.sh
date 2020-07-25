#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit
fi

if [ -z "$1" ]
  then
  echo "No argument supplied"
fi

REASON=$1

# tegrastats stat collect
FILENAME="`ls -1 ${REASON}/tegrastats-*.log`" 
# test if IRAM & APE stats present (48s stats)
if [ $(grep -cE "IRAM.*APE" ${FILENAME}) > 0 ]
then
        echo "unixepochtime,ramused,ramtotal,swapused,swaptotal,cached,iramused,iramtotal,cpu1per,cpu1freq,cpu2per,cpu2freq,cpu3per,cpu3freq,cpu4per,cpu4freq,emcper,emcfreq,gr3dper,gr3dfreq,ape,plltemp,cputemp,pmictemp,gputemp,aotemp,thermal,pom5vincurr,pom5vinavg,pom5vgpucurr,pom5vgpuavg,pom5vcpucurr,pom5vcpuavg" > "${FILENAME}.48.csv"
        cat "${FILENAME}" | sed -E 's/[()%\[]|MB|]|kB/ /g' | sed -E 's/[,@]|C / /g' | sed -E 's/ /\t/g' | sed -E 's/\t+/\t/g' | awk -F$"\t" \
        'BEGIN { OFS="," }; \
        { \
	        split($3,RAM,"/"); \
	        split($7,SWAP,"/"); \
	        split($11,IRAM,"/"); \
	        split($44,POM_5V_IN,"/"); \
	        split($46,POM_5V_GPU,"/"); \
	        split($48,POM_5V_CPU,"/"); \
	        print $1,RAM[1],RAM[2],SWAP[1],SWAP[2],$9,IRAM[1],IRAM[2],$15,$16,$17,$18,$19,$20,$21,$22,$24,$25,$27,$28,$30,$32,$34,$36,$38,$40,$42,POM_5V_IN[1],POM_5V_IN[2],POM_5V_GPU[1],POM_5V_GPU[2],POM_5V_CPU[1],POM_5V_CPU[2]; \
        };
        END {}; \' >> "${FILENAME}.48.csv"
else
        echo "unixepochtime,ramused,ramtotal,swapused,swaptotal,cached,cpu1per,cpu1freq,cpu2per,cpu2freq,cpu3per,cpu3freq,cpu4per,cpu4freq,emcfreq,gr3dfreq,plltemp,cputemp,pmictemp,gputemp,aotemp,thermal,pom5vincurr,pom5vinavg,pom5vgpucurr,pom5vgpuavg,pom5vcpucurr,pom5vcpuavg" > "${FILENAME}.40.csv"
        cat "${FILENAME}" | sed -E 's/[()%\[]|MB|]|kB/ /g' | sed -E 's/[,@]|C / /g' | sed -E 's/ /\t/g' | sed -E 's/\t+/\t/g' | awk -F$"\t" 'BEGIN { OFS="," }; \
        { \
        split($3,RAM,"/"); \
        split($7,SWAP,"/"); \
        split($36,POM_5V_IN,"/"); \
        split($38,POM_5V_GPU,"/"); \
        split($40,POM_5V_CPU,"/"); \
        print $1,RAM[1],RAM[2],SWAP[1],SWAP[2],$9,$11,$12,$13,$14,$15,$16,$17,$18,$20,$22,$24,$26,$28,$30,$32,$34,POM_5V_IN[1],POM_5V_IN[2],POM_5V_GPU[1],POM_5V_GPU[2],POM_5V_CPU[1],POM_5V_CPU[2]; \
        };
        END {}; \' >> "${FILENAME}.40.csv"
fi

# free -m stat collect
FILENAME="`ls -1 ${REASON}/free-*.log`" 
echo "unixepochtime,memtotal,memused,memfree,memshared,membufcache,memavailable,lowtotal,lowused,lowfree,hightotal,highused,highfree,swaptotal,swapused,swapfree,totaltotal,totalused,totalfree" > "${FILENAME}.csv"
cat "${FILENAME}" | sed -Ee 's/[^[:digit:]]+/ /g' -Ee 's/^ //g' -Ee '/^$/d' | sed -e 'N;N;N;N; s/\n/ /g' -Ee 's/ /,/g' >> "${FILENAME}.csv"

# iotop
FILENAME="`ls -1 ${REASON}/iotop-*.log`"
# iotop segnet-camera stat to CSV transformation
echo "unixepochtime,diskread,diskwrite,swapin,io" > "${FILENAME}.segnet-camera.csv"
grep -E "segnet-camera" ${FILENAME} | sed -E 's/%|(K\/s)//g' | awk -F" " -v logdate="Jul 20, 2020" \
'BEGIN { OFS="," }; \
{ \
	split($1,time,":"); \
	cmd ="date \"+%s\" -d \""logdate" "time[1]":"time[2]":"time[3]"\""; \
	cmd | getline var; \
	print var,$5,$6,$7,$8; \
};
END {}; \' >> "${FILENAME}.segnet-camera.csv"

# iotop total disk stat to CSV transformation
echo "unixepochtime,totaldiskread,totaldiskwrwite" > "${FILENAME}.totaldisk.csv"
grep -E "Total DISK" "$FILENAME" | sed -E 's/\||(K\/s)|(Total DISK READ :)|(Total DISK WRITE :)//g' | awk -F" " -v logdate="Jul 9, 2020" 'BEGIN { OFS="," }; \
{ \                  
split($1,time,":"); \                                                
cmd ="date \"+%s\" -d \""logdate" "time[1]":"time[2]":"time[3]"\""; \
cmd | getline var; \
print var,$2,$3; \
};        
END {}; \' >> "${FILENAME}.totaldisk.csv"

echo "done"
