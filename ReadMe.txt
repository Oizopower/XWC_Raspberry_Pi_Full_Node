Create a Whitecoin Full Node Without Compiling


This instruction is to create a Whitecoin full node on a raspberry Pi.
You will need the following things before we start
* Raspberry Pi Model B, or B+
* Minimum 8Gb class 10SD card, but I recommend a 16Gb Note: You may even get away with a 4GB card but I recommend against it
* Monitor, keyboard and mouse to plug into the Pi for Initial setup (Not needed after setup is complete
* You need to read up on your router and find out how to make it statically assign an IP address to the Raspberry Pi and how to set up port forwarding on it for both inbound and outbound traffic on port 9336
* You need to be able to SSH from your main computer to the PI to check it. If you have never done this before you will need to download and install Putty from here http://www.putty.org/
* To use Putty just start it and enter the IP address your router has assigned the Pi and make sure port 22 is entered into the port field
* To work out what IP address your router has assigned the Pi you can either open up lxterminal when the pi first booted up and type in ifconfig and it will give you the Pi’s IP address or you can get this by logging into your router




I will not go into the detail on how to do a standard install of Raspbian off Noobs as the Raspberry Pi website gives great instruction on how to do this.
if you do not know where to download Noobs from you get it here.
http://www.raspberrypi.org/downloads/
This link is to the howto to install Noobs onto the SD card
http://www.raspberrypi.org/help/noobs-setup/


The few extra things you should do over a standard install is
* Change the password from the default password for extra security. 
* I also recommend doing minor overclocking to 800Mhz.
* Don’t forget to enable SSH during setup
* I recommend changing the memory split from 64 to only 32Meg for the video to give more memory to the CPU
* Don’t forget to select your timezone
* Consider changing the hostname if you already have more than one Pi on your network

Set up Rasbian as per the instructions from the Raspberry Pi website and SSH into the Pi.
Note as configured this script will download a precompiled version of whitecoind to save you 4 hours of compiling,
if you want to compile it yourself uncommoment that section of the script and comment out the bit that downlaods the precompiled one. 

To Download everything off github onto your Pi use the following command

git clone https://github.com/Oizopower/XWC_Raspberry_Pi_Full_Node

Now enter the directory XWC_Raspberry_Pi_Full_Node

cd XWC_Raspberry_Pi_Full_Node/

We now need to make the script executable by typing

sudo chmod 755 whitecoind_node_precompiled.sh

Now we need to start the install script by typing.
./whitecoind_node_precompiled.sh


This will 
* Update the Pi to the latest version
* Install needed applications to run whitecoind, 
* Set up a firewall, that will allow ssh in and whitecoind to talk to other clients
* Download whitecoind
* Create a conf file with input from you to select a password for RDC
* Download a fairly recent blockchain and chainstate to speed up the process of getting it running
* create an /etc/init.d entry to start whitecoind as using ‘pi’ at boot

You are now on the home stretch.

You now need to log into your router and statically assign the IP address to the Pi and enable port forwarding to this IP address both inbound and outbound on port 9336.
You will need to read your router's manual to find out how to do this.

Once you have set up your router its time to test it.
Type sudo reboot
Once the Pi has booted back up SSH back into it
Give it 2 or 3 minutes for the Whitecoin daemon to start up and then to check it go


whitecoind getinfo

and you should be presented something like this


{
    "version" : "v1.1.2.2",
    "protocolversion" : 71002,
    "walletversion" : 60000,
    "balance" : 9.86057400,
    "newmint" : 0.00000000,
    "stake" : 0.00000000,
    "blocks" : 366284,
    "moneysupply" : 305380918.40797502,
    "connections" : 43,
    "difficulty" : 3.62502655,
    "testnet" : false,
    "keypoololdest" : 1411540496,
    "keypoolsize" : 102,
    "paytxfee" : 0.00010000,
    "errors" : ""
}





If you get an error when trying the above command wait another couple of minutes and try again as it does take a fe minutes for whitecoind daemon to fully start up.
Whilst it is catching up it will use about 90% of the CPU but once it has caught up it will only use 2% or 3%

You can also look at installing apache mysql and PHP and install a web front end to let you see what is happening by your web browser if you want, but don't forget to open up port 80 on the Pis firewall if you do.


Troubleshooting
If after rebooting whitecoind doesn't appear to be running try the command

sudo /etc/init.d/whitecoin start

You will be prompted for user pi password deatils before it will start and if it doesn't start will give you an error message
explaining why.

It is possible that in unzipping the blockchain it could of corrupted the data if this has happend just chose yes to let it rebuild the blockchain. 
This will take a long time though, posibbly over 24 hours if it needs to download the whole blockchain again

