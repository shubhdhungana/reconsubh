#!/bin/bash

echo "Enter the name of website: "
read domain
echo " "


##subdomain enumeration
assetfinder --subs-only $domain | tee  subdomainsAsset.txt
subfinder -d $domain | tee subdomainsSubfinder.txt
cat subdomainsAsset.txt subdomainsSubfinder.txt>subdomainsAll.txt
rm -rf subdomainsAsset.txt subdomainsSubfinder.txt

##live scanning of domains
cat subdomainsAll.txt | httpx | tee  subdomainsLive.txt



## fetching urls
cat subdomainsLive.txt | gau | tee urlsGau.txt
cat subdomainsLive.txt | gauplus | tee urlsGauplus.txt
cat urlsGau.txt urlsGauplus.txt>urlsAll.txt
rm -rf urlsGau.txt urlsGauplus.txt


##filter urls
cat urlsAll.txt | gf xss | tee filterxss.txt
cat urlsAll.txt | gf ssrf | tee filterssrf.txt
cat urlsAll.txt | gf aws-keys | tee filteraws.txt

##organizing
mkdir -p $domain/subdomains $domain/urls $domain/livedomains
mv subdomainsAll.txt $domain/subdomains/
mv subdomainsLive.txt $domain/livedomains
mv urlsAll.txt $domain/urls

echo ""
echo "  "
echo " ####################### "
echo " "
echo "Task Completed"
