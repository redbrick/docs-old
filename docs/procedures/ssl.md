# SSL Certs

Redbrick has a wildcard ssl cert for *.redbrick.dcu.ie.

## Paperwork

This should be on the grant app at the start of each year, in the past it has not been approved.The price is $149 for the year.


Rapidssl will email admins@rb about a month before the cert is due for renewal with instructions, this usually happens around April.

The cert has been bought through thesslstore.com, account details in pwsafe.

## Renewing SSL Cert

### IMPORTANT
Before carrying out any of the below. Make sure to backup:

*  csr

*  private key

*  ssl cert

*  intermediate cert bundle
Under a seperate subdirectory for $year.

First you must generate a CSR (Cert Signing Request) this is a public key with domain name information. This is generated along with a private key.

Minimum bit-length is 2048. Don't use 3DES Encryption for this key file as you need root access to read it.


	openssl genrsa -out privKey.key 2048

Using this key we will generate a csr using the following command


	openssl req -new -key /path/to/privKey.key -out /path/to/newCSRequest.csr


Using the domain information from the existing csr (outlined below) you will then generate a new csr.
### Note

We curently have a csr, if you wish to generate a new one copy the "Subject" line in the output when generating a new csr:


	openssl req -in mycsr.csr -noout -text


When renewing your cert RapidSSL will prompt for your CSR to get all information.

The CSR will resemble ensuring that there are 5 dashes either side of the certificate headers.


	-----BEGIN CERTIFICATE-----

	[encoded data]

	-----END CERTIFICATE-----


## Updating and Uploading

Once you have followed the wizard steps on RapidSSL you will receive an email with your new key, or you can download the new cert from the Customer Portal.

Before uploading any new certs ensure the old ones are backed up!

run a cmp between the backup and the live cert.


	cmp /path/to/BACKUP/ssl_cert.crt /path/to/LIVE/ssl_cert.crt

Ensure there are no differences.

Now upload the new SSL cert and intermediate cert bundle to the correct directory.

Note the naming conventions for the .crt, .csr, .key files.
Replace the 'live' files with the new Intermediate Cert bundle and new SSL cert.
Save these changes.

Restart the Apache Server.

Check that the Certificate Chain is intact via:
[https://ssltools.websecurity.symantec.com/checker/views/certCheck.jsp](https///ssltools.websecurity.symantec.com/checker/views/certCheck.jsp)

If the apache server didn't restart cleanly restore the old files and repeat the above steps.
