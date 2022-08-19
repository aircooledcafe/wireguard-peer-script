# Wireguard Peer Script

A bash script for generating the public private keys and configuration for a new Wireguard peer.
I created this script as there are a lot of commands to run to add a new peer and I wanted an easy way tro create the confguration and generate a QR code to add it to a mobile device. It's a pretty quick and dirty script, but it gets the job done.
It could be used to generate a configuration for any peer, commenting out the QR code generation line at the end. Just copy the genrated to .conf file to your new peer in the `/etc/wireguard` folder as wg0.conf and your all set to go.
