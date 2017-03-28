## Mysql


*  Main mysql runs on morpheus (mysql.internal, 192.168.0.76).

*  There are mysql slaves on thunder and severus, which are [backed](/legacy/procedures/dirvish) up nightly.


## Moving Mysql

How to move mysql:


*  apt-get install mysql-server

*  copy /etc/mysql/debian.cnf to the new machine

*  copy /var/lib/mysql to the new machine

*  set the server id and bin logs in /etc/mysql/my.cnf

*  move mysql.internal in DNS

*  start the new server

## Fixing Replication

Mysql is shit. If replication breaks you'll probably need to re-sync it with the master. This is a pain.

### Step 1: Make a snapshot

This step requires you stopping the mysql master server, affecting user websites etc. Obviously, the objective should be to get this step done as quickly as possible - it should take less than 10 minutes on morpheus. Don't bother with anything that would slow this step down - compression, writing to nfs mounts, etc. Once this is done you won't have to stop the master again, so you can take your time with all the other steps.


*  login to the mysql master as root

*  ` mysql> flush tables with read lock;`

*  ` mysql> show master status\G`

*  Save the output at the bottom of this page. This means that someone else can use your tar to setup a slave within in the next $BINLOG_EXPIRY_TIME days. Without the file name and position your tar is relatively useless.

*  CTRL+Z that mysql shell, and /etc/init.d/mysql stop

*  `cd /var/lib && tar -cvvf mysql-date.tar mysql`

*  plan how your going to hurt robin as his 2gb table holds you up

*  start mysql again.


### Alternate Step 1: Make a snapshot from another slave server

Since we have multiple slave servers it's possible to use a snapshot of one to start the other. The process is pretty similar to taking a snapshot of the master.


*  Login to the running slave as root

*  ` mysql> stop slave;`

*  ` mysql> flush tables with read lock;`

*  ` mysql> show slave status\G`

*  Save the output at the bottom of this page. This means that someone else can use your tar to setup a slave within in the next $BINLOG_EXPIRY_TIME days. Without the file name and position your tar is relatively useless.

*  CTRL+Z that mysql shell, and /etc/init.d/mysql stop

*  `cd /var/lib && rm mysql/dumps/*.sql && tar -cvvf mysql-`date +%Y%m%d`.tar mysql`

*  plan how your going to hurt robin as his 2gb table holds you up

*  start mysql again.


### Step 2: Move tar to the backup server


*  copy the tar to the slave server

*  while it's copying check that /etc/mysql/debian.cnf on the slave matches the one on the server. The init scripts will break if the passwords in this file on the slave don't match the passwords in the db you're importing.

*  stop the mysql slave server

*  untar this into /var/lib/mysql

*  plan how your going to hurt robin as his 2gb table holds you up AGAIN

*  if necessary, fix the file ownership

*  ensure that the directory /var/lib/mysql/dumps/ exists

*  start the mysql slave server

### Step 3: Fix stuff on the new slave database


*  If this wasn't previously a slave server, set server-id in my.cnf, and restart. This server id must be unique.

*  login to the slave mysql as root

*  ` mysql> stop slave; `

*  ` mysql> change master to master_host='mysql.internal', master_user='replication', master_password='passsword', master_log_file='mysql-bin.xxxxxx', master_log_pos=1234567; `

*  ` mysql> start slave; `

*  ` mysql> show slave status\G `

*  Hopefully the status output will look normal. If it doesn't, cry.


### Step 4: Backup user


*  The backup user needs to exist on all slaves for the dirvish scripts to operate correctly. The username and password are specified in /etc/mysql/backup.conf. If the db was copied from another slave you can probably skip this step, otherwise it needs to be done now.

*  ` mysql > grant select, reload, lock tables, show databases, show view, replication client on *.* to 'backup'@'localhost' identified by 'the_password' `


#### Notes

*  The master_log_file and master_log_pos are the values that you carefully noted from the master at the beginning. If you've lost these you can start all over again ;)

*  The replication user password is in pwsafe

*  The password for the backup user needs to match the password specified in /etc/mysql/backup.conf

*  If this machine wasn't a mysql slave before install redbrick-mysqlslave,logwatch-mysqlslave

### Tar

#### mysql-20140308.tar


	File: mysql-bin.001721
	Position: 88417402
