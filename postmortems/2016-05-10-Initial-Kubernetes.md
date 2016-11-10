Initial Kubernetes Setup
---
Redbrick Networking Society

Date:   2016-06-10  
Author: voy, tbolt  
Time:   2015-10 - 2016-04

---

## Overview
Out initial goas as new admins was to develop Rebrick 2.0 - a complete redesign
of the Redbrick infrastructure to facilitate the change to an distributed
infrastructure across many sites as the server room was being demolished. We
have decided to try containers as it is the new hipster thing. After research
and consideration we have decided to run a CoreOS cluster on 2 newly
provisioned machines: Icarus and Daedalus, named the Helios Cluster. Initially
we had aimed to create as systemd managed containers distributed via fleetctl.
After its fail we continued on to Kubernetes. We had the servers talking to
eachother successfully and pods running between them. We had Gogs, then Gitlab
running but with storage problems as the 2 machines did not store data on the
same server. We had troubles getting NFS storage to share the data between the
pods. Eventually our terms as admins had ended and the Helios cluster was 
decommissioned due to lack of available rack space.

---

## Impact
Users were not impacted as the new services were not conted to the old
infrastructure.

---

## Timeline
*No timeline was kept up to dat, therefore all dataes are approximate and might
not be accurate.*

* 2015-10: Daedalus provisioned.
* 2015-10: Icarus provisioned
* 2015-10: IP addresses space defined for new servers, and running 
           services/pods (LINK TO DOC)
* 2015-01: Servers connected using fleetctl
* 2015-10: Icarus shows signs of RAID failure. Unable to reboot anfter being 
           shut down by locksmith for automated updates.
* 2015-11: voy attemps to stop the automated updates. No luck. 
* 2015-11: Machines changes to beta channel to enable kubermetes installation.
* 2015-11: tbolt performs initial configuration of the kubernetes cluster
* 2015-12: Nginx and Gogs configured on the cluster
* 2015-12: git.redbrick.dcu.ie pointed at daedalus to test the git deployment.
* 2016-01: Various difficulties with the clusrer as icarus continues to not
           boot after restart. Admins on Christmas break. Split brain between
           the servers. Voy had to frequently clear etcd data to sync the 
           servers again.
* 2016-02: Waiting for NFS provisioning to sync Gitlab data.
* 2016-02: Problems with assigning separate IP for shared NFS server (albus).
* 2016-03: tbolt and voy give up due to lack of progressed caused by NFS.
* 2016-03: tbolt's and voy's term ends
* __2016-04: EVENT OVER__
* 2016-06: Icarus and Daedalus decommissioned as Hub is being demolished.

---

## Action Items
Possible Types: PROCESS, CODE, CONFIG  
Possible Action: IMPROVE, REMOVE, ADD

| Description | Type-Action | Related Issue | Assignee |
| ----------- | ----------- | ------------- | -------- |
| Do not seek the perfect solution - implement the basic version and improve
on that, eg use Gluster initially and then move to proper NFS | PROCESS-IMPROVE
| | |
| Save progress live in docs as things are being developed. | PROCESS-IMPROVE |
| |
| Store configuration on external servers so the configurations are not lost
as the servers are decommissioned | CONFIG-ADD | | |
| Develop ways of automatically provisioning new machines | CODE-ADD | | |
 

