The ILOM's differ to Murphy's ALOM, for one they are accessed by ssh not telnet, and also have a web management interface similar to the dells.

## Web Interface Access


The webmanagment interface runs on port 443, it inclueds a Java App that allows you to view and use the system console, it uses ports 7578 (video) and 5121 (keyboard)


	sudo ssh -L 443:morpheus.mgmt:443 -L 7578:morpheus.mgmt:7578 -L 5121:morpheusl.mgmt:5121 username@b4.redbrick.dcu.ie



	sudo ssh -L 443:daniel.mgmt:443 -L 7578:daniel.mgmt:7578 -L 5121:daniel.mgmt:5121 username@b4.redbrick.dcu.ie
