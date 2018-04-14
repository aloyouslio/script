# install_iis.ps1 -name test4 -path "c:\test4"
param
(
	[Parameter(Mandatory=$true)]
	[String]$name="apps",
	[String]$path="c:\apps"

)

Import-Module WebAdministration

Set-TimeZone  -id 'Singapore Standard Time'

$state=Get-Windowsfeature -name "web-server" 
if($state.installed -ne $true)
{
	Install-WindowsFeature -name Web-Server,Web-Http-Redirect,Web-Request-Monitor,Web-Basic-Auth,Web-CertProvider, `
	Web-Client-Auth,Web-Digest-Auth,Web-Cert-Auth,Web-IP-Security,Web-Url-Auth,Web-Windows-Auth,Web-Net-Ext, `
	Web-Net-Ext45,Web-AppInit,Web-ASP,Web-Asp-Net,Web-Asp-Net45,Web-ISAPI-Ext,Web-ISAPI-Filter -IncludeManagementTools
}

$FileExists=Test-Path $path
if($FileExists -ne $true)
{
    New-Item -Path $path -ItemType "directory"
    Set-Content ($path+"\Default.htm") "<h1>Hello IIS</h1>"
}
$web=get-webapplication -name $name
if($web -eq $null)
{
    New-WebAppPool ($name+"pool")
    New-WebApplication -Name $name -Site 'Default Web Site' -PhysicalPath $path -ApplicationPool ($name+"pool")
    Write-host "wait 5 sec to activate....."
    Start-Sleep -Seconds 5
}
Write-host ("URL: http://localhost/"+$name)
(Invoke-WebRequest -uri http://localhost/$name).content
