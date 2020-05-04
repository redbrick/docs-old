# Mailing Stack

This section of docs covers the installation, current deployment and
troubleshooting guides for Redbrick's mail stack.

End user documentation is [on the wiki](https://wiki.redbrick.dcu.ie/index.php/Category:Mail).

See the other pages under this section for service docs.

## Terminology

- **MTA**: Mail Transfer Agent. Responsible for sending and receiving
 mail, checking filters, and hands over good mail to the MDA. Provides
 SMTP. We use [Postfix](http://www.postfix.org/).
- **MDA**: Mail Delivery Agent. Responsible for storing user email
 and providing IMAP and authentication (SASL). We use
 [Dovecot2](https://www.dovecot.org/).
- **IMAP**: Internet Message Access Protocol. The standard used by
 clients for reading mail from Dovecot. It runs on port 993.
- **SMTP**: Simple Mail Transfer Protocol. The standard used by
 MTAs to transfer mail between each other. Clients use this to
 write/send mail. It runs on port 587 (STARTTLS) and 25 (unencrypted).
 Also known as the submission port.
- **LMTP**: Local Mail Transfer Protocol. Postfix sends mail to
 Dovecot using LMTP over a unix socket.
- **MDBox**: The mailbox format used by Dovecot in /var/mail
- **SRS**: Sender Rewrite Scheme. Changes the from field when mail
 is relayed from Redbrick to another source (e.g. Gmail forwarding).
 Handled by postsrsd.
- **SPF**: Sender Policy Framework. DNS entry which specify the rules
 for other MTAs when accepting mail from our domain.
- **DKIM**: DomainKey Identified Mail. Allows our MTA to sign mail
 and for other MTAs to validate that it came from us. Involves a key
 pair and a public key in DNS. Signing is handled by Rspamd.
- **DMARC**: Stupidly long acronym. Expansion of SPF and DKIM to
 further prevent fraud mail.
- **Sieve**: Scripting system provided by Dovecot for filtering and
 organising mail.
- **Milter**: Mail filter, usually a piece of software that scans mails
 before they go through to users. Rspamd is an example we use.

## Architecture

