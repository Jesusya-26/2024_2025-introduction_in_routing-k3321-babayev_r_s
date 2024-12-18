/interface bridge
add name=loopback0
/routing bgp instance
set default as=65500 router-id=172.16.6.2
/routing ospf instance
set [ find default=yes ] router-id=172.16.6.2
/ip pool
add name=dhcp_pool_ny ranges=172.16.9.2-172.16.9.254
/ip dhcp-server
add address-pool=dhcp_pool_ny disabled=no interface=ether4 name=dhcp_ny
/ip address
add address=172.16.6.2/32 interface=loopback0 network=172.16.6.2
add address=172.16.6.102/30 interface=ether3 network=172.16.6.100
add address=172.16.9.1/24 interface=ether4 network=172.16.9.0
/ip dhcp-server network
add address=172.16.9.0/24 gateway=172.16.9.1
/ip route vrf
add export-route-targets=65500:100 import-route-targets=65500:100 interfaces=ether4 route-distinguisher=65500:100 routing-mark=VRF_DEVOPS
/mpls ldp
set enabled=yes lsr-id=172.16.6.2 transport-address=172.16.6.2
/mpls ldp interface
add interface=ether3
add interface=ether4
/routing bgp instance vrf
add redistribute-connected=yes redistribute-ospf=yes routing-mark=VRF_DEVOPS
/routing bgp peer
add address-families=vpnv4 name=peer1 remote-address=172.16.3.2 remote-as=65500 update-source=loopback0
/routing ospf network
add area=backbone network=172.16.6.100/30
add area=backbone network=172.16.9.0/24
add area=backbone network=172.16.6.2/32
/system identity
set name=R01_NY
