/interface bridge
add name=loopback0
/routing bgp instance
set default as=65500 router-id=172.16.4.2
/routing ospf instance
set [ find default=yes ] router-id=172.16.4.2
/ip pool
add name=dhcp_pool_spb ranges=172.16.7.2-172.16.7.254
/ip dhcp-server
add address-pool=dhcp_pool_spb disabled=no interface=ether4 name=dhcp_spb
/ip address
add address=172.16.4.2/32 interface=loopback0 network=172.16.4.2
add address=172.16.4.102/30 interface=ether3 network=172.16.4.100
add address=172.16.7.1/24 interface=ether4 network=172.16.7.0
/ip dhcp-server network
add address=172.16.7.0/24 gateway=172.16.7.1
/ip route vrf
add export-route-targets=65500:100 import-route-targets=65500:100 interfaces=ether4 route-distinguisher=65500:100 routing-mark=VRF_DEVOPS
/mpls ldp
set enabled=yes lsr-id=172.16.4.2 transport-address=172.16.4.2
/mpls ldp interface
add interface=ether3
add interface=ether4
/routing bgp instance vrf
add redistribute-connected=yes redistribute-ospf=yes routing-mark=VRF_DEVOPS
/routing bgp peer
add address-families=vpnv4 name=peer1 remote-address=172.16.1.2 remote-as=65500 update-source=loopback0
/routing ospf network
add area=backbone network=172.16.4.100/30
add area=backbone network=172.16.7.0/24
add area=backbone network=172.16.4.2/32
/system identity
set name=R01_SPB

/ip route vrf 
remove [find routing-mark=VRF_DEVOPS]
/routing bgp instance vrf 
remove [find routing-mark=VRF_DEVOPS]
/interface bridge
add name=vpls
/interface bridge port
add bridge=vpls interface=ether4
/interface vpls bgp-vpls
add bridge=vpls export-route-targets=1:2 import-route-targets=1:2 name=vpls route-distinguisher=1:2 site-id=4
/ip address
add address=10.10.66.40/24 interface=vpls network=10.10.66.0
/routing bgp peer
remove [find address-families=vpnv4]
add address-families=l2vpn name=peer1 remote-address=172.16.1.2 remote-as=65500 update-source=loopback0
/ip pool
remove [find name=dhcp_pool_spb]
add name=dhcp_pool_vpls ranges=10.10.66.2-10.10.66.39,10.10.66.41-10.10.66.49,10.10.66.51-10.10.66.59,10.10.66.61-10.10.66.254
/ip dhcp-server
remove [find name=dhcp_spb]
add address-pool=dhcp_pool_vpls disabled=no interface=vpls name=dhcp_vpls
/ip dhcp-server network
remove [find gateway=172.16.7.1]
add address=10.10.66.0/24 gateway=10.10.66.40
