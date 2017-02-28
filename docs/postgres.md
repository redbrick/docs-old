
*  Install postgres (This bit should be easy, it's in apt repos)

*  Create data base (initdb -D /var/db/postgres (or other file))

*  Set up auth (we want to use ident same user. Details of this are [here](http://www.postgresql.org/docs/8.3/interactive/auth-pg-hba-conf.html). We should need a rule something like

	
	host all all 136.206.15/24 ident sameuser


*  We need to set up a listen_address in the config file at postgres.internal (listen_address `<ip addr>`

*  We need to set up postgresql.internal to point to (whatever machine)
