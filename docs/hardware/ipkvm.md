# Dell IP KVM Switch

We have a [Dell 2161DS-2 IP KVM Switch](http://downloads.dell.com/published/pages/poweredge-2161ds.html).
It is running the last released firmware. The login details are in the passwordsafe.
At the time of writing its address is 192.168.0.240 although this might become 192.168.1.240 soon.

This device allows us to connect one screen and keyboard to all the servers in the room.
Most importantly it allows us to connect remotely to the physical machines even if they die.
Each server is connected to a dongle which has one VGA connector and one USB connector.
These dongles connect directly to the IPKVM switch. it does not support virtual media attachment
as we have v1 of the dongles and not v2.

## Oddities

- A physical user and a remote user can't access the same server at the same time.
- A remote user can only open 2 servers at once.
- The web console is literally the worst. Browsing to the IP address doesn't cut it, [click this instead](https://192.168.0.240/home.asp).
  You can only inspect things from the web console, you can't view any servers.

## Connecting remotely

You need a proprietary tool from Dell to connect remotely. There are two versions available.

- The latest version (v4) uses HTTP to connect to the remote screen. It works on Linux but has an iffy
  Java based viewer. Download it [here](https://downloads.dell.com/RACK%20SOLUTIONS/DELL_MULTI-DEVICE_A02_R270943.exe).
- The older version (v3) uses weird ports only to connect to the remote screen. It has no Linux support
  but works absolutely fine in Wine, which can be easier than the Linux install. Download it [here](https://downloads.dell.com/RACK%20SOLUTIONS/R132099.EXE)

Installation depends on the version you download. For v4, download + extract it, and
run the Linux/setup.bin file. Install somewhere like ~/.local/dell. To run it,
execute `Dell_Remote_Console_Switch_Software` from the install directory.

For v3, set up a Wine prefix (using Lutris or DIY if you know how), and run the installer like you
usually would. Same process for running the thing applies, although now it has `.exe` on the end.

Unless you're on the VPN, you will need to forward the following ports from your local machine to RB.
Here's an SSH command to do it. You need to add an address other than 127.0.0.1 because it refuses
to use localhost. If you are using v3 you can skip the port 80 and 443 logins, and not use sudo.

```bash
sudo ip a 192.168.144.100/24 dev lo
sudo -E ssh -vN \
  -L 192.168.144.100:80:192.168.0.240:80 \
  -L 192.168.144.100:443:192.168.0.240:443 \
  -L 192.168.144.100:2068:192.168.0.240:2068 \
  -L 192.168.144.100:3211:192.168.0.240:3211 \
  rb
```

Open the Dell RCS suite. On the `Remote Console Switches` tab select `New Remote Console Switch`.
Go through the wizard to add 192.168.144.100 as a remote console switch. Select `Dell 2162DS-2`
as the model. Once complete right click the newly added RCS and click `Properties`.
On the `Network` tab make sure the IP is `192.168.144.100`.

Now you should be able to connect to a remote machine. From the `Servers` tab double click a host. You
will be prompted for a username and password (look them up in passwordsafe).

Do what you need to from here **THEN LOG OUT OF THE SERVER**. Do NOT leave TTYs in root shells.
m1cr0man will literally murder you.

