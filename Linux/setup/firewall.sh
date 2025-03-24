iptables -I INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -I OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -I INPUT -p tcp -m multiport --dport 22,4505:4506 -j ACCEPT
iptables -I OUTPUT -p tcp -m multiport --dport 53,80,443,389,636,88,464,445,4505:4506,9997 -j ACCEPT
iptables -I OUTPUT -p udp --dport 53 -j ACCEPT

iptables -I INPUT -p icmp -j ACCEPT
iptables -I OUTPUT -p icmp -j ACCEPT

iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
