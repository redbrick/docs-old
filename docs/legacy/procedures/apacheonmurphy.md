# Apache On Murphy

It was decided some time in 2007 that murphy would be an ideal platform for Apache, due to it's multithreading capabilities and vast amounts of RAM. This would also take some major load off deathray, which is on the brink of a nervous breakdown.

## suPHP

It is intended that suPHP will be used for PHP. It provides the security features of suExec, without the requirement for hash lines. It can be argued that the lack of hash lines increases overall security, as it makes it far easier for users to keep their PHP applications (wordpress, etc) up to date.

## Apt packaged install

We're using the standard apache that comes from apt this time around, to make updates easier. It will also be easier to find support - if we ask a question, it's far easier to explain our situation when we don't have to explain our whole custom setup.

All the apache modules (bar pubcookie) also come from apt.

## Pubcookie

Now [works](pubcookie)!

## suExec

Set up the same as before for deathray. docroot is compiled as /var/www, so /var/www is now the docroot for all vhosts, and is a symlink to /storage/webtree.

## Vhosts

Vhosts have been created in /etc/apache2/sites-available. They've all been enabled and will load, bar one (see next point). All of them that I've tested seem to work.

Halenger's vhost uses mod_perl for some reason, and refuses to load. We should ask him if he still wants/needs mod_perl.

Need to figure a way to enable them all properly. Cian suggested round-robin IP (forwarding) to forward .61 to .71 - This seems like a fairly sane idea. Then just email the owners and tell them to eventually update their DNS records to point straight at .71.

## To-do list


*  Test the bejesus out of everything.
