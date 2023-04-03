#!/bin/bash
cd "$(dirname "$0")"
echo -e "Starting OC-Kali-Startup"


# Prompt the user to enter a new password
echo "Enter a new password for your account:"
read -s password

# Prompt the user to confirm the new password
echo "Please confirm your new password by entering it again:"
read -s password_confirm

# Check if the passwords match
if [ "$password" == "$password_confirm" ]; then
  # If the passwords match, update the user's password
  echo "Updating password..."
  sudo chpasswd <<<"oc-pentest:$password"
  echo "Password updated successfully."
else
  # If the passwords don't match, show an error message and exit
  echo "Passwords do not match. Please try again."
  exit 1
fi


# Start SSH service
echo "Starting SSH service..."
sudo systemctl start ssh

# Enable SSH service on startup
echo "Enabling SSH service on startup..."
sudo systemctl enable ssh


echo "Installing Nessus..."
# Download and install the latest version of Nessus Professional
curl -o nessus.deb -L 'https://www.tenable.com/downloads/api/v2/pages/nessus/files/Nessus-10.5.0-debian10_amd64.deb' -H 'Referer: https://www.tenable.com/downloads/nessus'
dpkg -i nessus.deb
echo "Starting Nessus"

# Start Nessus, and enable on startup
sudo /bin/systemctl enable nessusd.service
sudo /bin/systemctl start nessusd.service
echo "Nessus installed and ready"
cd ~/Desktop
touch nessus.desktop && echo -e "[Desktop Entry]\nType=Link\nURL=https://OC-KALI-PENTEST:8834/" > nessus.desktop
echo "Nessus shortcut added to home directory: https://OC-KALI-PENTEST:8834/"
cd "$(dirname "$0")"

# Start xrdp, and enable on startup
echo "Now installing xrdp"
sudo apt-get install xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp


# Get the user's IP address
ip=$(hostname -I | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}')
# Echo the IP address back to the user
echo "xrdp ready to fire on: $ip"

# Download testssl.sh
echo "Downloading testssl.sh..."
cd ~/Desktop
curl -o testssl.sh https://raw.githubusercontent.com/drwetter/testssl.sh/master/testssl.sh
chmod +x testssl.sh
cd "$(dirname "$0")"

# Add firewall rules
#echo "Adding firewall rules..."
#sudo iptables -A INPUT -i lo -j ACCEPT
#sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#sudo iptables -A INPUT -p tcp --dport 3389 -j ACCEPT
#sudo iptables -P INPUT DROP
#sudo iptables -P FORWARD DROP
#sudo iptables-save | sudo tee /etc/iptables/rules.v4

# Enable root login via SSH
echo "Enabling root login via SSH..."
sudo sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Download the most recent Nessus plugins package
cd ~/Desktop
echo "Downloading the most recent Nessus plugins package..."
wget -q -O - https://www.tenable.com/downloads/api/v2/public/pages/nessus/downloads/11843/download?i_agree_to_tenable_license_agreement=true | tar -zxv -C /opt/nessus/var/nessus/plugins/ --strip-components=1
cd "$(dirname "$0")"


echo "Done! Your Kali Box is ready :)"
echo "REMEMBER TO CONFIGURE NETWORK SETTINGS ACCORDING TO THE JOB!"
