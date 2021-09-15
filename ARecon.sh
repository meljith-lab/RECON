#!/bin/bash


echo Please input the domain you would like to scan:
read domain

subdomainEnum(){
	mkdir -p $domain $domain/subs $domain/recon
	subfinder -d $domain -o $domain/subs/SubfinderResults.txt
	amass enum -d  $domain -o $domain/subs/amassResults.txt
	cat $domain/subs/*.txt > $domain/subs/allSubsFound.txt
}
subdomainEnum

subdomainValidation(){
	cat $domain/subs/allSubsFound.txt |httprobe > $domain/subs/Httprobe.txt
}
subdomainValidation

subdomainPortScanner(){
        cat $domain/subs/allSubsFound.txt | naabu -top-ports 1000 > $domain/subs/Sub_Port.txt
}
subdomainPortScanner

