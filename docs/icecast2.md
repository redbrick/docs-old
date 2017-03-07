Icecast is a streaming server that we currently host on [paphos](paphos)

We stream DCUFm's Broadcasts to their apps via a stream presented on dcufm.redbrick.dcu.ie:80

They serve an audio stream (stream128.mp3) via butt on a desktop in their studio to icecast2.

Icecast requires root privilege to bind to Port 80; normally icecast2 runs as the icecast2 user and binds to 8001.

Procedure:

Change
Configure
    /etc/icecast2/icecast.xml
         `<!-- Sources log in with username 'source' -->` <-- This is the audio source.
        `<source-password>`$password1`</source-password>` <-- This must be copied for the DCUFM buttrc.
        `<!-- Relays log in username 'relay' -->`
        `<relay-password>`$password2`</relay-password>`
        `<admin-user>`admin`</admin-user>` <-- This is for the WebUI frontend
        `<admin-password>`$password3`</admin-password>`

        `<hostname>`dcufm.redbrick.dcu.ie`</hostname>`

        `<listen-socket>`
        `<port>`80`</port>`
        `<bind-address>`136.206.15.101`</bind-address>` <-- i.p. addr for dcufm.redbrick.dcu.ie A Record.

After that you must configure the default behaviour for the icecast server to allow icecast2 to bind to port 80.

    USERID & GROUPID in  
    /etc/defaults/icecast2 to root
