wget -N https://github.com/felixonmars/dnsmasq-china-list/raw/master/bogus-nxdomain.china.conf
cat bogus-nxdomain.china.conf | grep -v '^#bogus' | grep bogus-nxdomain | sed 's/bogus-nxdomain=//g' | sed -e 's/$/\r/' >dnscrypt-blacklist-ips.txt
wget -N https://raw.githubusercontent.com/wkway/dns/master/blacklist-ips/blacklist-ips.txt
cat blacklist-ips.txt dnscrypt-blacklist-ips.txt | sort | uniq >blocked-ips.txt

wget -N https://raw.githubusercontent.com/wkway/dns/master/cloaking-rules/cloaking-rule.txt
wget -N https://github.com/googlehosts/hosts/raw/master/hosts-files/dnscrypt-proxy-cloaking.txt
cat cloaking-rule.txt dnscrypt-proxy-cloaking.txt | grep -v '^$' | sed -e 's/$/\r/' | sed '/^#/d'>tmp.txt
awk '!a[$0]++' tmp.txt >cloaking-rules.txt

wget -N https://github.com/felixonmars/dnsmasq-china-list/raw/master/accelerated-domains.china.conf
cat accelerated-domains.china.conf | grep -v '^#server' | sed -e 's|/| |g' -e 's|^server= ||' | sed 's/114.114.114.114/114.114.114.114,223.5.5.5,119.29.29.29/g' | sed -e 's/$/\r/' >forwarding-rules.txt

wget -N https://raw.githubusercontent.com/notracking/hosts-blocklists/master/unbound/unbound.blacklist.conf
curl -sS -L --compressed "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound&showintro=0&mimetype=plaintext&useip=0.0.0.0" | tee adservers.conf
cat adservers.conf >>unbound.blacklist.conf 
awk '!a[$0]++' unbound.blacklist.conf >unbound_ad_servers

#wget -N https://raw.githubusercontent.com/wkway/dns/master/blocked-names/blocked-names.txt

rm bogus-nxdomain.china.conf dnscrypt-blacklist-ips.txt blacklist-ips.txt cloaking-rule.txt dnscrypt-proxy-cloaking.txt tmp.txt accelerated-domains.china.conf adservers.conf unbound.blacklist.conf 
