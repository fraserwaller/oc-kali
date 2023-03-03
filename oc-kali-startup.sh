#!/bin/bash
cd "$(dirname "$0")"
echo -e "\033[34mStarting OC-Kali-Startup\033[0m"
echo "\033[32mInstalling Nessus...\033[0m"
# Download and install the latest version of Nessus Professional
curl -o nessus.deb -L 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.5.0-debian10_amd64.deb' -H 'Referer: https://www.tenable.com/downloads/nessus'
dpkg -i nessus.deb
echo "\033[32mStarting Nessus\033[0m"
# Start Nessus, and enable on startup
sudo /bin/systemctl enable nessusd.service
sudo /bin/systemctl start nessusd.service
echo "\033[32mNessus installed and ready\033[0m"
touch nessus.desktop && echo -e "[Desktop Entry]\nType=Link\nURL=https://OC-KALI-PENTEST:8834/" > nessus.desktop
echo "\033[32mNessus shortcut added to current directory: https://OC-KALI-PENTEST:8834/\033[0m"
# Start xrdp, and enable on startup
echo "\033[32mNow installing xrdp\033[0m"
sudo apt-get install xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp
# Get the user's IP address
ip=$(hostname -I | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
# Echo the IP address back to the user
echo "\033[32mxrdp ready to fire on: $ip\033[0m"
echo "\033[34m.Done! Your Kali Box is ready :)\033[0m"