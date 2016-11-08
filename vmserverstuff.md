### WHAT WE WANT IN A VM SERVER


*  A: Shared RAM

*  B: User Console Access (Nice but not Required)

*  C: Scriptable (For createing VM's and Such)

*  D: 64 bit support

*  E: Performance


### POSSIBLE VM SOFTWARE


*  XEN: Does A, B (According to Werdz) C, D, E

*  ESXi: Does A, C, D, E

*  KVM: [rbvm](rbvm) does B, C, D and E \o/ Might do A, not sure.

*  xVM : Xen with nicer front end

*  Citrix Xen Serve : ditto

*  Hyper-V: Cian says this is not very good at what we would like it to do. Also, costs lots of money.


# KVM

**Updated**: We've built the entire VM stack on KVM. See [rbvm](rbvm) for details on our homemade enterprise cloud management suite.

Open source, which is nice. It also has decent enough processor performance. Used to have crappy disk IO, but that seems alright in modern versions.

# Xen

http://www.redbrick.dcu.ie/~werdz/xenshell.png
http://www.xen-tools.org/software/xen-shell/ <-- opensource management tool that looks like it does lots of lovely things

We tried Xen for a while, and it was nice, but a world of pain to keep up to date.

