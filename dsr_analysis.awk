BEGIN {
	send = 0;
	recv = 0;
	bytes = 0;
	avg_delay = 0;
	start_time = 0;
	end_time = 0;
	packets = 0;
	delay = 0;
}
{
	if(($1 == "s" || $1 == "f") && $4 == "RTR" && $7 "DSR")
	{
		packets++;
	}
	if($1 == "s" && $4 == "AGT" && $7 == "cbr")
	{
		if(send == 0)
		{
			start_time = $2;
		}
		end_time = $2;
		st_time[$6] = $2;
		send++;
	}
	if($1 == "r" && $4 == "AGT" && $7 == "cbr")
	{
		recv++;
		bytes += $8;
		ft_time[$6] = $2;
		delay += ft_time[$6] - st_time[$6];
	}
}

END {
	if(recv == 0)
		recv = 1;
	avg_delay = delay/recv;
	printf("Number of sent pkts: \t\t%.f\n", send);
	printf("Number of recv pkts: \t\t%.f\n", recv);
	printf("Packet_Delivery_Ratio: \t\t%.2f %%\n",recv/send*100);
	printf("Total_Delay: \t\t%.2f Seconds\n", delay);
	printf("Average End to End Delay: \t%.2f Seconds\n", avg_delay);
	printf("Control_Overhead: \t\t%d\n",packets);
	printf("Normalized_Routing_Overhead: \t%.2f %%\n",packets/recv*100);
	printf("Throughput: \t\t\t%.2f Kbps\n",bytes*8/(end_time-start_time)/1000);
	printf("Packet_Dropping_Ratio: \t\t%.2f %%\n",(send-recv)/send*100);	
}
