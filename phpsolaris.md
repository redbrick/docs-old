PHP was compiled for Solaris 10, because none of the prepackaged versions had the feature set we required; some of them just plain didn't work.

It was compiled in the global zone, because we wanted to install it under ''/usr/local/php''.

    ./configure --with-zlib \
 1. -enable-bcmath \
 2. -with-bz2 \
 3. -enable-calendar \
 4. -with-curl \
 5. -enable-dba \
 6. -enable-ftp \
 7. -with-gettext \
 8. -with-gmp \
 9. -with-imap=/usr/local/imap-2007b \
 10. -with-imap-ssl \
 11. -with-ldap \
 12. -enable-mbstring \
 13. -with-mysql=/usr/local/mysql-sparc32 \
 14. -with-mysqli=/usr/local/mysql-sparc32/bin/mysql_config \
 15. -with-pdo-mysql=/usr/local/mysql-sparc32 \
 16. -with-pgsql=/usr/local/postgres-8.3-sparc32 \
 17. -with-pdo-pgsql=/usr/local/postgres-8.3-sparc32 \
 18. -enable-soap \
 19. -enable-zip \
 20. -prefix=/usr/local/php \
 21. -enable-force-cgi-redirect

Some notes:\\
This compiled the 32-bit version of PHP. Due to this, some of the native 64-bit libs didn't work.

*  32-bit MySQL was untarred to /usr/local/mysql-sparc32

*  32-bit postgres was untarred to /usr/local/postgres-8.3-sparc32

*  32-bit zlib was compiled and installed to /usr/local/zlib-sparc32 (although I forgot to set this in the installation script. If there are errors using bzip2 or gzip functions from within PHP, change ''--with-zlib'' above to ''--with-zlib=/usr/local/zlib-sparc32'').

Additionally, we had to install the c-client libraries for IMAP from UW. They were installed manually to /usr/local/imap-2007b. This is all in the global zone. If the c-client headers can't be found, you'll get weird errors relating to U8T_somethingorother not being defined. Yes, it makes no sense.

MySQL and MySQLi support were compiled in. Note that if you move MySQL or attempt to build a 64-bit version in the future using 64-bit libs, the ''--with-mysqli'' option must point at the ''bin/mysql_config'' binary, not the mysql installation folder.

LDAP, SSL, GMP, etc libraries were installed from SunFreeware packages.

Because this was compiled in the local zone, ''dmake -j 4'' was the most efficient compile command (it's **slow**).

Post-compile ''make test'' gave the following output; deemed acceptable:

    Number of tests : 5334              4460
    Tests skipped   :  874 ( 16.4%) --------
    Tests warned    :    1 (  0.0%) (  0.0%)
    Tests failed    :   66 (  1.2%) (  1.5%)
    Tests passed    : 4393 ( 82.4%) ( 98.5%)

The directory ''/usr/local/php'' had to be chmoded to ''755'' after install for some reason. It was created with a mode of ''711'', so PHP couldn't be executed or read by normal users.
