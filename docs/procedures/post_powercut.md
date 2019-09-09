# Post-powercut todo list

A list of things that should be done/checked immediately after a power cut:

- Check [KVM](/network/pike), hit ctrl+D on minerva to make sure it boots.
- Check [KVM](/network/pike), hit F1 on sprout to make sure it boots
- Check [KVM](/network/pike), sometimes you need to press F1 on carbon for it to
  boot
- Stop Exim on the mail server (Morpheus) until minerva (NFS) is online.
- For murphy:
  - If LDAP is down, you'll need to use the ALOM to do the next step.
  - Check that ldapclient started (svcs -xv). If it didn't, run
    `svcadm clear ldap/client` to make it start. This usually happens because
    murphy comes back before morpheus does, and the LDAP client won't start due
    to lack of an LDAP server.
  - Apache is stupid and tries to start before networking is finished starting.
    To fix it, disable/re-enable it a few times. This usually makes it turn on.

Fill this in if there's stuff I've forgotten.
