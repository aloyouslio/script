#rcmd Get-ChildItem

param
(
    [Parameter(Mandatory=$True,HelpMessage="Please enter a command to run")]
		[String]$cmd,
		[Parameter(Mandatory=$false)]
		[String]$user = "administrator",
		[String]$server = "192.168.1.200",
                [String]$pass = ""
 )

if($pass -eq "")
{
    $pass = Get-Content "C:\list\access.txt"
}
$SecPass = ConvertTo-SecureString -String $Pass -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user,$SecPass

$scriptblock = $executioncontext.invokecommand.NewScriptBlock($cmd)
$option=New-PSsessionOption -SkipCACheck -SkipCNCheck
$sess=New-PSSession -ComputerName $server  -Credential $cred -SessionOption $option -UseSSL
Invoke-Command -Session $sess -ScriptBlock $scriptblock

Remove-PSSession -Session $sess

