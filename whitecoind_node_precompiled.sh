echo This script transforms your raspbian installation to a working whitecoin client.
echo whitecoind will be installed in /usr/local/bin/
echo The blockchain, chainstate and conf files will be installed in /home/pi/.Whitecoin
echo press enter to continue, or ctrl c to quit...
read whatever

cd /home/pi

echo
echo updating software...
echo
sudo apt-get -y update
sudo apt-get -y upgrade
echo
echo installing ufw firewall...
echo

sudo apt-get -y install ufw

echo disabling ipv6 in ufw...
cd /home/pi
sudo cat /etc/default/ufw > ufw
sed -i '/IPV6=/d' ufw
echo "IPV6=no" >> ufw
sudo mv -f ufw /etc/default/ufw
sudo chmod 644 /etc/default/ufw
sudo chown root:root /etc/default/ufw 

echo configuring ufw...
echo Opening up Port 22 TCP for SSH
sudo ufw allow 22/tcp
echo opening up Port 15814 for Whitecoin
sudo ufw allow 15814/tcp
sudo ufw status verbose
sudo ufw --force enable

echo
echo installing dependencies for whitecoin...
echo
sudo apt-get -y install build-essential libboost-dev libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libssl-dev libdb++-dev libminiupnpc-dev git g++ g++-4.6
echo

echo
echo Downloading whitecoind and installing in /usr/local/bin
########################################################
#Comment out this section if you do not want to download my compiled
#whitecoind and save yourself 4 hours compiling
cd /usr/local/bin
sudo wget https://github.com/Whitecoin-org/Whitecoin/releases/download/1.1.2.2/rpi-whitecoind-v1_1_2_2.zip
sudo unzip rpi-whitecoind-v1_1_2_2.zip
sudo rm -rf rpi-whitecoind-v1_1_2_2.zip
sudo chmod 755 whitecoind
#######################################################

cd /home/pi
mkdir .Whitecoin
touch .Whitecoin/Whitecoin.conf

#############################################################
#If you comment out the section above uncomment this section to download the source and compile yourself
#cd /home/pi
#echo
#echo downloading source files...
#echo
#sudo git clone https://github.com/Whitecoin-org/Whitecoin.git
#cd Whitecoin/src
#echo
#echo compiling... this takes about 4 hours...
#echo
#sudo make -f makefile.unix USE_UPNP=- xCPUARCH=armv7l whitecoind
#sudo cp -f /home/pi/Whitecoin/src/whitecoind /usr/local/bin
#
#echo
#echo Removing source files...
#echo
#sudo rm -rf /home/pi/Whitecoin
##############################################################



echo
echo Setting up whitecoind conf file
echo
echo "# Whitecoin.conf" > .Whitecoin/Whitecoin.conf
echo "# JSON-RPC options for controlling a running whitecoind process" >> .Whitecoin/Whitecoin.conf
echo "# Server mode allows whitecoind to accept JSON-RPC commands" >> .Whitecoin/Whitecoin.conf
echo "# You must set rpcuser and rpcpassword to secure the JSON-RPC api" >> .Whitecoin/Whitecoin.conf
echo "rpcuser=rpcuser" >> .Whitecoin/Whitecoin.conf

echo Enter a long random password for rpc. This should NOT be your wallet password.
echo You wont need this password for normal use, so make it long and difficult.
echo You can change it anytime by restarting this configuration script.
read rpcpassword

echo "rpcpassword=$rpcpassword" >> .Whitecoin/Whitecoin.conf
echo "listen=1" >> ~/.Whitecoin/Whitecoin.conf
echo "server=1" >> ~/.Whitecoin/Whitecoin.conf
echo "maxconnections=100" >> ~/.Whitecoin/Whitecoin.conf

echo moving start script for whitecoind to /etc/init.d
sudo mv /home/pi/XWC_Raspberry_Pi_Full_Node/whitecoin /etc/init.d
cd /etc/init.d
sudo chmod 755 whitecoin
sudo chmod 755 whitecoin

sudo update-rc.d whitecoin defaults

cd /home/pi/.Whitecoin

echo Downloading blockchain and chainstate. This is a 320 Meg download so will take some time
echo press enter to continue, or ctrl c to quit...
read whatever

sudo wget http://explorer.whitecoin.info/bootstrap/raw_bootstrap.zip
unzip raw_bootstrap.zip
sudo rm raw_bootstrap.zip

echo thats you all set up just sudo reboot to restart your pi, give it a few minutes after booting for the whitecoind daemon to start up and your off and running

