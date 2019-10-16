#!/bin/bash
# RUN ON STANDBY
# change tls	
searchVip()
{
	local profilesArr=($(tmsh -q -c 'cd /'"$2"'; list ltm profile client-ssl all-properties one-line recursive' | grep -v ''"$3"'' | awk '{print $4}'))
	for i in ${profilesArr[@]}; do
		vipCheckArray=($(tmsh -q -c 'cd /; list ltm virtual one-line recursive' | grep ''"$i"'' | awk '{print $3}'))
		if [[ "$1" =~ ^.*$i.*$ ]]; then
			echo "$1"
			echo "$1" | awk '{ print $3 }' >> "$HOME"/"$3"_offenders_"$2".txt
			for i in ${vipCheckArray[@]}; do
				if [[ "$i" != *$env* ]]; then
					echo "    Client-ssl profile for this virtual used in another partition!!!!" >> "$HOME"/"$3"_offenders_"$2".txt
				fi
			done
				
				#if [ ${#vipCheckArray[@]} -gt 1 ]; then
				#	echo "    Client-ssl profile for this virtual used in another partition!!!!" >> "$HOME"/"$3"_offenders_"$2".txt
				#fi
		fi
	done
}

partitions=($(tmsh -q -c 'cd /; list auth partition one-line' | awk '{ print $3 }'))

echo ""
echo ""
echo ""
echo "Partitions: ${partitions[@]}"
echo ""
	sleep .5
	echo -n "*"
	sleep .5
	echo -n "*"
	sleep .5
	echo -n "*"
	sleep .5
	echo ""
	echo ""

read -p "What partition should we check?: " env
sleep .5
echo ""
read -p "What string should we search for in the client-ssl profiles (this usually corresponds to the offending cipher)?:  " cipher

allVipsFullLine=$(tmsh -q -c 'cd /'"$env"'; list ltm virtual one-line recursive')

while read -r line; do
	searchVip "$line" "$env" "$cipher"
	
done <<< "$allVipsFullLine"
echo ""
echo ""
sleep .5


if [ -e "$HOME"/"$cipher"_offenders_"$env".txt ]; then
    echo "${cipher}_offenders_${env}.txt created, or appended in your home directory..."
else
    echo "No ${cipher} Offenders in the ${env} partition.."
	echo ""
	echo "Try Again?..."
fi
