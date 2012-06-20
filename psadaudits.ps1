Import-Module ./modules/QueryCommands.psm1
name_window "PS AD Audits"

function check_exec_pol {
  if ("AllSigned", "Restricted" -contains Get-ExecutionPolicy) {
    "Your ExecutionPolicy is too restrictive to run unsigned scripts."
    "Currently it is set to $(get-excutionPolicy)"
    "To set your ExecutionPolicy open a powershell terminal as Administrator and run:"
    "Set-ExecutionPolicy RemoteSigned"
    }
  }

function show_menu {
  Write-Host "Welcom to PS AD Audits!`n"
  #Write-host "---------------------------------`n"
  Write-host "Take snapshot of AD              [1]"
  Write-Host "Detect changes                   [2]"
  Write-Host "Search for problems              [3]"
  #Write-Host "Run in !Testing Mode?            [4]"
  Write-host "----------------------------------`n"
  Write-Host "What would you like to do? "
}
  
function get_input {
  show_menu
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  $x.character
  }
  
switch (get_input) {
  "1" {import-module ./modules/write_aduser_sqlite.ps1}
  "2" {import-module ./modules/detect_change.ps1}
  "3" {import-module ./modules/search_aduser_sqlite.ps1}
  }
  
retain_window