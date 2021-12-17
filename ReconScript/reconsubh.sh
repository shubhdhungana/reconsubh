#!/bin/bash

##taking input from the user
read -p "Enter the name of the target? " targetName

##extracting subdomains
assetfinder --subs-only $targetName | tee subdomains1.txt
subfinder -d $targetName | tee subdomains2.txt

cat subdomains1.txt subdomains2.txt | tee finalSubdomains.txt
rm -rf subdomains1.txt subdomains2.txt

## filterinig subdomains and fetching live domains
cat finalSubdomains.txt | httpx | tee liveSubdomains.txt

## fetching urls from subdomains
cat liveSubdomains.txt | gau | tee urls1.txt
cat liveSubdomains.txt | gauplus | tee urls2.txt
cat liveSubdomains.txt | waybackurls | tee urls3.txt

cat urls1.txt urls2.txt urls3.txt > urls.txt
rm -rf urls1.txt urls2.txt urls3.txt

## fetching juicy urls
cat urls.txt | gf xss | tee gfxss.txt
cat urls.txt | gf ssrf | tee gfssrf.txt
cat urls.txt | gf servers | tee gfservers.txt
cat urls.txt | gf aws-keys | tee gfAws.txt

## organizing files for good readability
mkdir $targetName
mv finalSubdomains.txt liveSubdomains.txt urls.txt gfxss.txt gfssrf.txt gfservers.txt gfAws.txt $targetName


### Done This is Ending #######
### Author: Shubham Dhungana #####
