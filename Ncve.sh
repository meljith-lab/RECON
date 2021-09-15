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

nucleiScan(){
	nuclei -l $domain/subs/Sub_Port.txt -t ~/templates/cves -c 100 -o $domain/recon/CVEs.txt
	nuclei -l $domain/subs/Sub_Port.txt -t ~/templates/vulnerabilities -c 100 -o $domain/recon/Vulners.txt
	nuclei -l $domain/subs/Sub_Port.txt -t ~/templates/security-misconfiguration -c 100 -o $domain/recon/Misconfig.txt
	nuclei -l $domain/subs/Sub_Port.txt -t ~/templates/default-credentials -c 100 -o $domain/recon/DefaultCreds.txt
	nuclei -l $domain/subs/Sub_Port.txt-t ~/templates/files -c 100 -o $domain/recon/Files.txt
	nuclei -l $domain/subs/Sub_Port.txt -t ~/templates/subdomain-takeover -c 100 -o $domain/recon/SubsTakeover.txt
	nuclei -l $domain/subs/Sub_Port.txt -t ~/templates/generic-detections -c 100 -o $domain/recon/Generic.txt
}
nucleiScan

