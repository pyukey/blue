#!/bin/bash
if [ -d fun ]; then
  rm -rf fun
else
  :
fi
mkdir fun
cd fun

echo "Enter a subnet to scan"

regex='^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]|[1-2][0-9]|3[0-2])$'
read sub
while [[ $sub =~ $regex ]]; do
  echo "$sub" >> subnets
  echo "Enter a subnet to scan. [Type done to stop]"
  read sub
done
while read -r sub; do
  subStart=${sub%%/*}
  mkdir "$subStart"
  cd "$subStart"
  nmap -PR -PE -PP -PM -PO2 -PS21,22,23,25,80,110,113,135,137,143,443,445,691,993,995,1433,1521,2483,2484,3306,8008,8080,8443,7680,31339 -PA80,113,443,10042 -sn "$sub" | grep report | awk '{print $5" "$6}' > hosts.txt
  sed -i -E 's/^(\S+)\s+.(.*).$/\2 /' hosts.txt
  while read -r host; do
    ip=$(echo "$host" | awk '{print $1}')
    nmap -sS -sV "$ip" > "$ip" 2>/dev/null &
  done < hosts.txt
  sed -i 's|$|Kali assets/Kali ssh,rdp|' hosts.txt
  cd ..
done < subnets

# Reformat hosts.txt to be IP, hostname, distro, services

cat ../index.template.html > ../index.html
while read -r sub; do
  subStart=${sub%%/*}
  cd "$subStart"
  router=$(head -1 hosts.txt | awk '{print $1}')
  while read -r ip hostname distro services ; do
    echo "{ data: { id: \"$ip\", label: \"$ip\n$hostname\", image: \"$distro.png\" } }," >> ../../index.html
    if [ "$ip" = "$router" ]; then
      :
    else
      echo "{ data: { id: \"connect.$ip\", source: \"$router\", target: \"$ip\" } }," >> ../../index.html
    fi
  done < hosts.txt
  cd ..
done < subnets
cd ..
echo "]});" >> index.html
echo "</script>" >> index.html
echo "</body>" >> index.html
echo "</html>" >> index.html
