Invoke-Command -ComputerName Server -ScriptBlock { 
Import-Module PSWindowsUpdate
Hide-WUUpdate -Title '.net' -Verbose  –Confirm:$false | FT Title
} -Credential domain\administrator
