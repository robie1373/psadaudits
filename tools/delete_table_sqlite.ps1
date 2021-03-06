Import-Module ./QueryCommands.psm1

Write-Host "Available Databases are:"
dir $dbdir
$del_dbname = Read-Host "Delete table from which database?"
$del_dbname = $del_dbname.Trim().split('.')[0]

"dbname is " + $del_dbname

set_up_db $del_dbname ($dbdir + $del_dbname + ".sqlite")

Write-Host "$del_dbname has these tables:"
ls ($del_dbname + ":/") | select table
$del_tablename = Read-Host "Delete which table?"
$del_tablename = $del_tablename.Trim()


Write-Host "`nYou are about to delete the table $del_dbname`:/$del_tablename"
Write-Host "Press 'y' to continue or any other key to abort."

$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

if ($x.character -eq "y") { 
  remove-item "$del_dbname`:/$del_tablename" 
  "`n $del_dbname`:/$del_tablename was deleted."}
else { "`nAborting" }

retain_window