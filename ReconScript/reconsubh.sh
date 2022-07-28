#!/bin/bash

DOMAIN=$1
DIRECTORY=${DOMAIN}_recon
mkdir $DIRECTORY

#assetfinder
echo " Now, Assetfinder"
assetfinder -subs-only $DOMAIN | tee $DIRECTORY/ast.txt
echo " "

#subfinder
echo " Now, Subfinder"
subfinder -d $DOMAIN | tee $DIRECTORY/subf.txt
echo " "

#amass
echo "Now, Amass"
amass enum --passive -d $DOMAIN | tee $DIRECTORY/amass.txt

#arranging files
echo " Arranging Subdomains into one"
cat $DIRECTORY/ast.txt $DIRECTORY/subf.txt $DIRECTORY/amass.txt | sort -u | tee $DIRECTORY/subdomains.txt
rm -rf $DIRECTORY/ast.txt $DIRECTORY/subf.txt $DIRECTORY/amass.txt
echo "Done "
echo " "

#httpx and httprobe
cat $DIRECTORY/subdomains.txt | httpx | tee $DIRECTORY/livesubdomains.txt
echo "httpx done"
echo "Now, filtering live subdomains and scanning open ports like 81, 8080, 8000, 8443"
cat $DIRECTORY/subdomains.txt | httprobe -p http:81 -p http:8000 -p http:8080 -p https:8443 -c 50 | tee $DIRECTORY/httprobeOpenPorts.txt
echo "httprobe done"
cat $DIRECTORY/livesubdomains.txt | httpx -title -status-code -fr -o $DIRECTORY/httpxSubdomains.txt

#aquatone
echo " Now, screenshot using aquatone"
echo " "
cd $DIRECTORY
mkdir aquatoneDatas
cd aquatoneDatas
cat ../livesubdomains.txt | aquatone
echo " "
echo " aquatone done"
cd ../../


#waybackurls
echo " Now Waybackurls"
cat $DIRECTORY/livesubdomains.txt | waybackurls | tee $DIRECTORY/wayback.txt
echo "waybackurls done "
echo " "

#gau
echo "Now Gau"
cat $DIRECTORY/livesubdomains.txt | gau | tee $DIRECTORY/gau.txt
echo " "
echo "Gau done"

#arranging content discovery files
echo "Now, arranging content discovery files"
cat $DIRECTORY/wayback.txt $DIRECTORY/gau.txt | sort -u | tee $DIRECTORY/urls.txt
rm -rf $DIRECTORY/wayback.txt $DIRECTORY/gau.txt
echo " Done "


# fff
cat $DIRECTORY/urls.txt | fff | tee $DIRECTORY/liveUrls.txt
cat $DIRECTORY/liveUrls.txt | grep js | tee $DIRECTORY/liveJs.txt

# gf pattern filter
cat $DIRECTORY/liveUrls.txt | gf xss | tee $DIRECTORY/gfxss.txt
cat $DIRECTORY/liveUrls.txt | gf ssrf | tee $DIRECTORY/gfssrf.txt
cat $DIRECTORY/liveUrls.txt | gf upload-fields | tee $DIRECTORY/gfupload.txt
cat $DIRECTORY/liveUrls.txt | gf sqli | tee $DIRECTORY/gfsqli.txt
cat $DIRECTORY/liveUrls.txt | gf redirect | tee $DIRECTORY/gfredirect.txt
cat $DIRECTORY/liveUrls.txt | gf rce | tee $DIRECTORY/gfrce.txt
cat $DIRECTORY/liveUrls.txt | gf idor | tee $DIRECTORY/gfidor.txt
cat $DIRECTORY/liveUrls.txt | gf lfi | tee $DIRECTORY/gflfi.txt
echo " "
mkdir $DIRECTORY/gfTool
mv $DIRECTORY/gfxss.txt $DIRECTORY/gfssrf.txt $DIRECTORY/gfupload.txt $DIRECTORY/gfsqli.txt $DIRECTORY/gfredirect.txt $DIRECTORY/gfrce.txt $DIRECTORY/gfidor.txt $DIRECTORY/gflfi.txt $DIRECTORY/gfTool/
 
