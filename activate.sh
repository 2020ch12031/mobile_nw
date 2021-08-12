#!/bin/bash

#Create required directories and set permissions
mkdir mobility_files
mkdir -p Output/nam
mkdir -p Output/trace
mkdir -p Output/awk
mkdir -p Output/csv
chmod 777 -R mobility_files

send_pkt=0
recv_pkt=0
pdr=0
avg_delay=0
throughput=0
ctrl_overhead=0

aodv_send_pkt=0
aodv_recv_pkt=0
aodv_pdr=0
aodv_avg_delay=0
aodv_throughput=0
aodv_ctrl_overhead=0

dsr_send_pkt=0
dsr_recv_pkt=0
dsr_pdr=0
dsr_avg_delay=0
dsr_throughput=0
dsr_ctrl_overhead=0

dsdv_send_pkt=0
dsdv_recv_pkt=0
dsdv_pdr=0
dsdv_avg_delay=0
dsdv_throughput=0
dsdv_ctrl_overhead=0

simulation_count=10

#Main loop which runs 10 times.
for (( i=1; i<=10; i++))
	do
		#Creates 10 mobility files. Each of which is named as mob1, mob2, ... , mob10.
		./setdest -v 2 -n $1 -m 1 -M 10 -t 100 -p 5 -x 800 -y 800 > mobility_files/mob$1

		#Call TCL script with mobility file as a parameter.
		ns aodv.tcl $1 mobility_files/mob$1
		ns dsr.tcl $1 mobility_files/mob$1
		ns dsdv.tcl $1 mobility_files/mob$1
		awk -f aodv_analysis.awk aodv_out_$1.tr > Output/awk/aodv_$1_nodes.txt
		awk -f dsr_analysis.awk dsr_out_$1.tr > Output/awk/dsr_$1_nodes.txt
		awk -f dsdv_analysis.awk dsdv_out_$1.tr > Output/awk/dsdv_$1_nodes.txt
		
		printf "\nProcessing AODV"
		grep "Number of sent pkts:" Output/awk/aodv_$1_nodes.txt |  awk 'BEGIN{}{print $5;}' > aodv_1.txt
		send_pkt=$(<aodv_1.txt)
		aodv_send_pkt=$( bc <<< "$send_pkt + $aodv_send_pkt ")
		grep "Number of recv pkts:" Output/awk/aodv_$1_nodes.txt |  awk 'BEGIN{}{print $5;}' > aodv_2.txt
		recv_pkt=$(<aodv_2.txt)
		aodv_recv_pkt=$( bc <<< "$recv_pkt + $aodv_recv_pkt ")
		grep "Packet_Delivery_Ratio:" Output/awk/aodv_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > aodv_3.txt
		pdr=$(<aodv_3.txt)
		aodv_pdr=$( bc <<< "$pdr + $aodv_pdr ")
		grep "Average End to End Delay:" Output/awk/aodv_$1_nodes.txt |  awk 'BEGIN{}{print $6;}' > aodv_4.txt
		avg_delay=$(<aodv_4.txt)
		aodv_avg_delay=$( bc <<< "$avg_delay + $aodv_avg_delay ")
		grep "Throughput:" Output/awk/aodv_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > aodv_5.txt
		throughput=$(<aodv_5.txt)
		aodv_throughput=$( bc <<< "$throughput + $aodv_throughput ")
		grep "Control_Overhead:" Output/awk/aodv_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > aodv_6.txt
		ctrl_overhead=$(<aodv_6.txt)
		aodv_ctrl_overhead=$( bc <<< "$ctrl_overhead + $aodv_ctrl_overhead ")
		
		
		printf "\nProcessing DSR"
		grep "Number of sent pkts:" Output/awk/dsr_$1_nodes.txt |  awk 'BEGIN{}{print $5;}' > dsr_1.txt
		send_pkt=$(<dsr_1.txt)
		dsr_send_pkt=$( bc <<< "$send_pkt + $dsr_send_pkt ")
		grep "Number of recv pkts:" Output/awk/dsr_$1_nodes.txt |  awk 'BEGIN{}{print $5;}' > dsr_2.txt
		recv_pkt=$(<dsr_2.txt)
		dsr_recv_pkt=$( bc <<< "$recv_pkt + $dsr_recv_pkt ")
		grep "Packet_Delivery_Ratio:" Output/awk/dsr_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > dsr_3.txt
		pdr=$(<dsr_3.txt)
		dsr_pdr=$( bc <<< "$pdr + $dsr_pdr ")
		grep "Average End to End Delay:" Output/awk/dsr_$1_nodes.txt |  awk 'BEGIN{}{print $6;}' > dsr_4.txt
		avg_delay=$(<dsr_4.txt)
		dsr_avg_delay=$( bc <<< "$avg_delay + $dsr_avg_delay ")
		grep "Throughput:" Output/awk/dsr_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > dsr_5.txt
		throughput=$(<dsr_5.txt)
		dsr_throughput=$( bc <<< "$throughput + $dsr_throughput ")
		grep "Control_Overhead:" Output/awk/dsr_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > dsr_6.txt
		ctrl_overhead=$(<dsr_6.txt)
		dsr_ctrl_overhead=$( bc <<< "$ctrl_overhead + $dsr_ctrl_overhead ")
		
		printf "\nProcessing DSDV"
		grep "Number of sent pkts:" Output/awk/dsdv_$1_nodes.txt |  awk 'BEGIN{}{print $5;}' > dsdv_1.txt
		send_pkt=$(<dsdv_1.txt)
		dsdv_send_pkt=$( bc <<< "$send_pkt + $dsdv_send_pkt ")
		grep "Number of recv pkts:" Output/awk/dsdv_$1_nodes.txt |  awk 'BEGIN{}{print $5;}' > dsdv_2.txt
		recv_pkt=$(<dsdv_2.txt)
		dsdv_recv_pkt=$( bc <<< "$recv_pkt + $dsdv_recv_pkt ")
		grep "Packet_Delivery_Ratio:" Output/awk/dsdv_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > dsdv_3.txt
		pdr=$(<dsdv_3.txt)
		dsdv_pdr=$( bc <<< "$pdr + $dsdv_pdr ")
		grep "Average End to End Delay:" Output/awk/dsdv_$1_nodes.txt |  awk 'BEGIN{}{print $6;}' > dsdv_4.txt
		avg_delay=$(<dsdv_4.txt)
		dsdv_avg_delay=$( bc <<< "$avg_delay + $dsdv_avg_delay ")
		grep "Throughput:" Output/awk/dsdv_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > dsdv_5.txt
		throughput=$(<dsdv_5.txt)
		dsdv_throughput=$( bc <<< "$throughput + $dsdv_throughput ")
		grep "Control_Overhead:" Output/awk/dsdv_$1_nodes.txt |  awk 'BEGIN{}{print $2;}' > dsdv_6.txt
		ctrl_overhead=$(<dsdv_6.txt)
		dsdv_ctrl_overhead=$( bc <<< "$ctrl_overhead + $dsdv_ctrl_overhead ")
		
		
		rm *.txt
	done
	printf "\nAverage Calculation"
# 1) Node 2) AodvSendPkt 3) AodvRecvPkt 4) AodvPDR 5) AodvAvgDelay 6) AodvThroughput 7) AodvCtrlOverhead 8) DsrSendPkt 9) DsrRecvPkt 10) DsrPDR 11) DsrAvgDelay 12) DsrThroughput 13) DsrCtrlOverhead 14) DsdvSendPkt 15) DsdvRecvPkt 16) DsdvPDR 17) DsdvAvgDelay 18) DsdvThroughput 19) DsdvCtrlOverhead 
	echo  "$1" | awk '{printf "\n%.5f", $1}' >> Output/csv/Result.csv
		
	echo  "$aodv_send_pkt $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$aodv_recv_pkt $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$aodv_pdr $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$aodv_avg_delay $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$aodv_throughput $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$aodv_ctrl_overhead $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	
	echo  "$dsr_send_pkt $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsr_recv_pkt $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsr_pdr $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsr_avg_delay $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsr_throughput $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsr_ctrl_overhead $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv

	echo  "$dsdv_send_pkt $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsdv_recv_pkt $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsdv_pdr $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsdv_avg_delay $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsdv_throughput $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv
	echo  "$dsdv_ctrl_overhead $simulation_count" | awk '{printf ", %.5f", $1/$2}' >> Output/csv/Result.csv

#Move all output files to their locations.
mv *.nam Output/nam
mv *.tr Output/trace
printf "\nAll files Generated. Please check Output directory\n"

