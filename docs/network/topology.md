# Topology of Redbrick network
![Network Diagram](/img/network_topology.png)


<br>
### How we get internet
Redbrick has a L2 fibre connection back to DCU's core that is connected on Sebastian's fibre ports.

### Links to be aware of
- Between Steve and Sebastian there is a LACP Fibre link which allows all tagged VLANs across. In the event of a fibre link failure there is an ethernet LACP link configured. 
- Between Sebastian and the SRX due to unforeseen circumstances LACP between the two was never completed. However, there is a router-on-a-stick implementation in place.
