#!/bin/bash

DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
mkdir $DIRECTORY

#subfinder
echo " "
echo "Bullet Train Subfinder"
echo " "
subfinder -d $DOMAIN | tee $DIRECTORY/subfinder.txt
echo "subfinder done"
echo " " 

#findomain
echo " "
echo "Bullet Train Findomain"
echo " "
findomain -t $DOMAIN | tee $DIRECTORY/findomain.txt
echo "findomain done"
echo " " 

#arranging files
echo " "
echo "sorting files and output"
cat $DIRECTORY/subfinder.txt $DIRECTORY/findomain.txt | sort -u | tee $DIRECTORY/subdomains.txt
rm -rf $DIRECTORY/subfinder.txt $DIRECTORY/findomain.txt
echo "sorting files output done"
echo " "

#httpx
echo " "
echo "httpx station train"
echo " "
cat $DIRECTORY/subdomains.txt | httpx | tee $DIRECTORY/live_subdomains.txt
echo " "
cat $DIRECTORY/live_subdomains.txt | httpx -title -status-code -fr -o $DIRECTORY/httpx_title_statuscode.txt
echo " "

# gau
echo " "
echo "gau station train"
echo " "
cat $DIRECTORY/live_subdomains.txt | gau | tee $DIRECTORY/urls.txt
echo "wayback station reached"
echo " "
