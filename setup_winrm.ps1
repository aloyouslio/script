$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
invoke-webrequest -uri $url -outfile $file
powershell.exe -ExecutionPolicy ByPass -File $file

$result=winrm enumerate winrm/config/Listener
write-output $result
$result=$result -match '([0-9]|[A-F]){40}'
$thumbprint=$result -replace ".*CertificateThumbprint = ",""
Get-ChildItem -Path cert:\LocalMachine\My -Recurse | Where-Object { $_.Thumbprint -eq $thumbprint } | Select-Object *
