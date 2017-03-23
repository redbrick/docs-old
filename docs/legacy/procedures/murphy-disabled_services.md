    svc:/network/stdiscover:default
    svc:/network/stlisten:default
these two do tag discovery whatever that is. Doesn't seem very useful, from what I can see, so better safe than sorry, and turned them off
    svc:/network/telnet:default
    svc:/network/shell:default
    svc:/network/login:rlogin
    svc:/network/ftp:default
because it's not 1990...
    svc:/network/smtp:sendmail
we'll probably replace this with exim at some point.
