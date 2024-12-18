/interface bridge
add name=loopback0
/routing bgp instance
set default as=65500 router-id=172.16.1.2
/routing ospf instance
set [ find default=yes ] router-id=172.16.1.2
/ip address
add address=172.16.1.2/32 interface=loopback0 network=172.16.1.2
add address=172.16.1.101/30 interface=ether3 network=172.16.1.100
add address=172.16.3.102/30 interface=ether4 network=172.16.3.100
add address=172.16.4.101/30 interface=ether5 network=172.16.4.100
/mpls ldp
set enabled=yes lsr-id=172.16.1.2 transport-address=172.16.1.2
/mpls ldp interface
add interface=ether3
add interface=ether4
add interface=ether5
/routing bgp peer
add address-families=vpnv4 name=peer1 remote-address=172.16.2.2 remote-as=65500 update-source=loopback0
add address-families=vpnv4 name=peer2 remote-address=172.16.3.2 remote-as=65500 route-reflect=yes update-source=loopback0
add address-families=vpnv4 name=peer3 remote-address=172.16.4.2 remote-as=65500 route-reflect=yes update-source=loopback0
/routing ospf network
add area=backbone network=172.16.1.100/30
add area=backbone network=172.16.3.100/30
add area=backbone network=172.16.4.100/30
add area=backbone network=172.16.1.2/32
/system identity
set name=R01_HKI
