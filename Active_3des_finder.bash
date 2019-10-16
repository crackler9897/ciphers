#!/bin/bash
#profilesArr=($(tmsh -q -c 'cd /; show ltm profile client-ssl recursive' | grep -e 'Ltm::ClientSSL Profile:' -e 'Digital Encryption Standard (DES)' | grep -v 'Digital Encryption Standard (DES)                                 0' | grep -B 1 'Digital Encryption Standard (DES)' | grep  Ltm::ClientSSL | awk '{print $3}'))
profilesArr=($(tmsh -q -c 'cd /; show ltm profile client-ssl recursive' | grep -e 'Ltm::ClientSSL Profile:' -e 'Digital Encryption Standard (DES)' | grep -v 'Digital Encryption Standard (DES)                                 0' | grep -B 1 'Digital Encryption Standard (DES)' | grep 'Ltm::ClientSSL' | awk '{print $3}'))
        printf '%s\n' "${profilesArr[@]}"
        for i in ${profilesArr[@]}; do
                x=$(tmsh -q -c 'cd /; list ltm virtual one-line recursive' | grep ''"$i"'' | awk '{print $3}')
                        echo "$x"
        done
		
	