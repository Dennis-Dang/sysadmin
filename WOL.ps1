# Author: Dennis Dang
# Date: 3.18.2023
# Version: 1.0
# Description: This is a Wake on LAN powershell script that will send a magic packet to power up the host machine, whichever machine the NIC is connected to.
# 	I've seen some reports (due to the nature of WoL?) that after power outages, machine may not remember the driver settings to receive magic packets.
#	Therefore you may need to manually turn on the machine, and gracefully shutdown for WoL to work in general.

# Replace with the MAC address of your NIC. Not case sensitive, but be sure to use hyphens. If not deliminated by hyphens, you change -split '-' to -split ':' on line 17
$macAddress = "FE-A0-F0-C1-4A-BB"
# Subnet mask for broadcasting your network. 
# You may use '255.255.255.255' to broadcast through your entire network, but know that some routers may block the packet unless you accurately specify which subnet.
$broadcastAddress = "192.168.1.255" 
$port = 9

# Change to -split ':' if your mac address is delineated this way.
$macBytes = $macAddress -split '-' | ForEach-Object { [byte]('0x' + $_) }

$magicPacket = [byte[]](,0xFF * 6) + ($macBytes * 16)

$udpClient = New-Object System.Net.Sockets.UdpClient
# Will output 102 on the console after sucessfully sending packet.
# Though, obviously will not output if host has received it because that is not how UDP operates.
$udpClient.Send($magicPacket, $magicPacket.Length, $broadcastAddress, $port)
