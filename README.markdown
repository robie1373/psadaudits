# PSADAudits is for looking at and keeping track of AD
* psadaudits is v0.5.0 7/3/12
* psadaudits is v0.4.0 6/26/12
* psadaudits is v0.3.0 6/20/12
* psadaudits is v0.2.0 6/20/12
* psadaudits is v0.0.1 6/19/12

## Requirements
* http://psqlite.codeplex.com/

## ToDo
* Error handling in write_adusers **Complete 6/20/12**
* Change detection **Complete 6/20/12**
* Performance *Experiments with transactions showed no benefit but added complexity. I'm looking for suggestions to speed this up. It's painfully slow right now.*
* Offer to create required directories for user
* Create option to search live AD for disabled and locked accounts
* Improve installation help. Particularly unblocking the sqlite modules

## Changelog
### Version 0.5.1 7/3/12
* Added the Enabled property to Stale passords output.

### Version 0.5.0 7/3/12
* Added search for stale passwords in "Search for problems". Output automatically saved to a file in $dbdir.

### Version 0.4.1 6/27/12
* Put assess 5 group options into loops to make using the tool suck less.

### Version 0.4.0 6/26/12
* Added ability to make a db of groups. For now you need to keep track of which is which on your own.
* Added ability to mark groups as privileged, unpriviliged or skip.
* Added ability to show privileged or unprivileged groups.
* Added ability to mark a group based on SamAccountName.
* Reorganzied the modules to make functions easier to find.
* Small changes and fixes too numerous to list.

### Version 0.3.2 6/25/12
* bugfix. column_list and insert-query were being created and looked for in different / wrong places.

### Version 0.3.1 6/21/12
* Checks for sqlite module

### Version 0.3.0 6/20/12
* Checking executionpolicy and giving advice
* All wrapped up in a pretty one-file wrapper

### Version 0.2.1 6/20/12
* Checking for $dbdir
* De-personalized. It might even run on someone else's machine now! ;)

### Version 0.2.0 6/20/12
* Added Change detection
* Added error handling / alerting to write_adusers