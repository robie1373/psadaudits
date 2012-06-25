# PSADAudits is for looking at and keeping track of AD
* psadaudits is v0.3.0 6/20/12
* psadaudits is v0.2.0 6/20/12
* psadaudits is v0.0.1 6/19/12

## Requirements
* http://psqlite.codeplex.com/

## ToDo
* Error handling in write_adusers **Complete 6/20/12**
* Change detection **Complete 6/20/12**
* Performance *Experiments with transactions showed no benefit but added complexity. I'm looking for suggestions to speed this up. It's painfully slow right now.*

## Changelog
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