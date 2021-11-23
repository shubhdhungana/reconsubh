#!/bin/bash

###Name of the website to attack
echo "Enter the target's name: "
read target


##################this enumerates the subdomains and filter the live subdomains 
assetfinder --subs-only $target | httpx | tee subdomain1.txt  
subfinder -d $target | httpx | tee subdomain2.txt
cat subdomain1.txt subdomain2.txt>allsubdomains.txt
##########################Deleting unwanted subdomains file
rm -rf subdomain1.txt subdomain2.txt 

#######         fetching urls
cat allsubdomains.txt | gau | tee urls1.txt
cat allsubdomains.txt | gauplus | tee urls2.txt
cat urls1.txt urls2.txt>urlsAll.txt
###Deleting urls unwanted file
rm -rf urls1.txt urls2.txt

#####     filtering urls using gf tool
cat urlsAll.txt | gf xss | tee xssgf.txt
cat urlsAll.txt | gf ssrf | tee ssrfgf.txt
cat urlsAll.txt | gf servers | tee serversgf.txt
cat urlsAll.txt | gf aws-keys | tee awsgf.txt

######organizing folder and moving files to proper folders
mkdir urls
mv awsgf.txt serersgf.txt ssrfgf.txt urlsAll.txt xssgf.txt urls/

mv urlsAll.txt awsgf.txt serversgf.txt ssrfgf.txt xssgf.txt urls/ 
