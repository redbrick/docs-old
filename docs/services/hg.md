
	Hey,                                                                            

	I've installed a redbrick-wide hgwebdir instance:                               

	http://hg.redbrick.dcu.ie/                                                      

	It's publically readable, so not really suitable for things you don't           
	want people to see the source for, but useful if anyone's doing any open        
	source work.                                                                    

	Push access is restricted to SSL (https://hg.redbrick.dcu.ie/reponame/),        
	which is protected by mod_authnz_ldap (Pubcookie + hg is a world of             
	pain). Each repository has it's own list of which authenticated users           
	may push (write) to it.                                                         

	If any users ask for a repository, running                                      
	/srv/admin/scripts/add_hg_repo.sh on murphy will create it for you.             
	Repositories are in /storage/hg and need to be owned by www-data to             
	function (the script does this for you). The script is interactive.  
