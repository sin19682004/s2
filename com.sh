#!/bin/bash

el_start=${el_start:-0}
el_end=${el_end:-5}
wl_start=${wl_start:-0}
wl_end=${wl_end:-5}
dn_start=${dn_start:-0}
dn_end=${dn_end:-5}
bs_start=${bs_start:-0}
bs_end=${bs_end:-4}

job_max=${job_max:-0}
cpu_max=${cpu_max:-0}
delay=${delay:-0}
if_test=${if_test:-0}

wd_start=${wd_start:-0}
wd_end=${wd_end:-6}
#workload=(/home/r01/gengyouchen/ssd_trace/ms_exchange_server.trace /home/r01/gengyouchen/ssd_trace/msn_fs.trace /home/r01/gengyouchen/ssd_trace/ms_live_maps.trace /home/r01/gengyouchen/ssd_trace/MSRC-io-traces-ascii/usr_1.trace /home/r01/gengyouchen/ssd_trace/MSRC-io-traces-ascii/src1_0.trace /home/r01/gengyouchen/ssd_trace/synthetic_overload_full.trace)
workload=(/home/r03/sin19682004/test/simulator2/trace/mse_burst.trace /home/r03/sin19682004/test/simulator2/trace/msn_burst.trace /home/r03/sin19682004/test/simulator2/trace/synf_burst.trace /home/r01/gengyouchen/ssd_trace/ms_live_maps.trace /home/r01/gengyouchen/ssd_trace/MSRC-io-traces-ascii/usr_1.trace /home/r01/gengyouchen/ssd_trace/MSRC-io-traces-ascii/src1_0.trace)
#workload_short=(mse msn msl usr1 src10 synf_b)
workload_short=(mse_b msn_b synf_b msl usr1 src10)


el=( 100 150 200 250 300 )
wl=( 100 150 200 250 300 )
dn=( 64 80 96 112 128 )
bs=( 128 256 512 1024 )

change=${change:-1}
# 1=die number
# 2=block size
prefix=(wl_die block_size_config 3_factor el_die bs_die)
config_dir="config/${prefix["$change"-1]}"
exec_dir="exec/${prefix["$change"-1]}"
out_dir="out/${prefix["$change"-1]}"

if [ "$change" -eq 1 ]; then
		for (( i="$wl_start"; i<"$wl_end"; i++ ))
		do
			for (( j="$dn_start"; j<"$dn_end"; j++ ))
			do
				make -f c config_file="$config_dir"/ssd_typedef_${wl["$i"]}_${dn["$j"]}.h
				echo "cp ./run.x ./"$exec_dir"/run_${wl["$i"]}_${dn["$j"]}.x"
				cp ./run.x ./"$exec_dir"/run_${wl["$i"]}_${dn["$j"]}.x
			done
		done
elif [ "$change" -eq 2 ] ; then
		for (( i="$bs_start"; i<"$bs_end"; i++ ))
		do
			if [ $if_test -eq 1 ]
			then
				bash ./cpu.sh "$cpu_max" "$if_test"
				#echo "$?"
				while [ $? -eq 255 ]
				do
					sleep "$delay"
					bash ./cpu.sh "$cpu_max" "$if_test"
				done
			elif [ $if_test -eq 2 ]
			then
				bash ./cpu.sh "$job_max" "$if_test"
				#echo "$?"
				while [ $? -eq 255 ]
				do
					sleep "$delay"
					bash ./cpu.sh "$job_max" "$if_test"
				done
			fi

			make -f c config_file="$config_dir"/ssd_typedef_${bs["$i"]}.h
			./run.x ${workload["$wn"]} 0 20 > out/"$prefix"/${workload_short["$wn"]}_${bs["$i"]} 2> out/"$prefix"/stderr/${workload_short["$wn"]}_${bs["$i"]} &
			
			if [ $if_test -eq 0 ]
			then
				sleep "$delay"
			fi
		done
elif [ $change -eq 3 ] ; then
		for (( i="$el_start"; i<"$el_end"; i++ ))
		do
			for (( j="$wl_start"; j<"$wl_end"; j++ ))
			do
				for (( k="$bs_start"; k<"$bs_end"; k++ ))
				do
					if [ $if_test -eq 1 ]
					then
						bash ./cpu.sh "$cpu_max" "$if_test"
						#echo "$?"
						while [ $? -eq 255 ]
						do
							sleep "$delay"
							bash ./cpu.sh "$cpu_max" "$if_test"
						done
					elif [ $if_test -eq 2 ]
					then
						bash ./cpu.sh "$job_max" "$if_test"
						#echo "$?"
						while [ $? -eq 255 ]
						do
							sleep "$delay"
							bash ./cpu.sh "$job_max" "$if_test"
						done
					fi

					make -f c config_file="$config_dir"/ssd_typedef_${el["$i"]}_${wl["$j"]}_${bs["$k"]}.h
					./run.x ${workload["$wn"]} 0 20 > out/"$prefix"/${workload_short["$wn"]}_${el["$i"]}_${wl["$j"]}_${bs["$k"]} 2> out/"$prefix"/stderr/${workload_short["$wn"]}_${el["$i"]}_${wl["$j"]}_${bs["$k"]} &

					if [ $if_test -eq 0 ]
					then
						sleep "$delay"
					fi
				done
			done
		done
elif [ $change -eq 4 ] ; then
		for (( i="$el_start"; i<"$el_end"; i++ ))
		do
			for (( j="$dn_start"; j<"$dn_end"; j++ ))
			do
				if [ $if_test -eq 1 ]
				then
					bash ./cpu.sh "$cpu_max" "$if_test"
					#echo "$?"
					while [ $? -eq 255 ]
					do
						sleep "$delay"
						bash ./cpu.sh "$cpu_max" "$if_test"
					done
				elif [ $if_test -eq 2 ]
				then
					bash ./cpu.sh "$job_max" "$if_test"
					#echo "$?"
					while [ $? -eq 255 ]
					do
						sleep "$delay"
						bash ./cpu.sh "$job_max" "$if_test"
					done
				fi

				make -f c config_file="$config_dir"/ssd_typedef_${el["$i"]}_${dn["$j"]}.h
				echo "cp ./run.x ./"$exec_dir"/run_${el["$i"]}_${dn["$j"]}.x"
				cp ./run.x ./"$exec_dir"/run_${el["$i"]}_${dn["$j"]}.x

				if [ $if_test -eq 0 ]
				then
					sleep "$delay"
				fi
			done
		done
elif [ $change -eq 5 ] ; then
		for (( i="$bs_start"; i<"$bs_end"; i++ ))
		do
			for (( j="$dn_start"; j<"$dn_end"; j++ ))
			do
				if [ $if_test -eq 1 ]
				then
					bash ./cpu.sh "$cpu_max" "$if_test"
					#echo "$?"
					while [ $? -eq 255 ]
					do
						sleep "$delay"
						bash ./cpu.sh "$cpu_max" "$if_test"
					done
				elif [ $if_test -eq 2 ]
				then
					bash ./cpu.sh "$job_max" "$if_test"
					#echo "$?"
					while [ $? -eq 255 ]
					do
						sleep "$delay"
						bash ./cpu.sh "$job_max" "$if_test"
					done
				fi
				
				make -f c config_file="$config_dir"/ssd_typedef_${bs["$i"]}_${dn["$j"]}.h
				echo "cp ./run.x ./"$exec_dir"/run_${bs["$i"]}_${dn["$j"]}.x"
				cp ./run.x ./"$exec_dir"/run_${bs["$i"]}_${dn["$j"]}.x

				if [ $if_test -eq 0 ]
				then
					sleep "$delay"
				fi
			done
		done
fi