#create_email.ps1 -email new@example.com -dept "Infrastructure" -title "System Engineer" -manager admin@example.com -hp +6512345678


param
(
	[Parameter(Mandatory=$true)]
	[ValidatePattern(".*@example.com")][String]$email,
    [ValidatePattern(".*@example.com")][String]$manager,
	[String]$dept,
	[String]$title,

    [Parameter(Mandatory=$false)]
	[ValidateSet("sg","in")][String]$office = "sg",
	[ValidatePattern("^(\+)?\d{8,10}")][String]$hp = ""
)


$UserCredential = Get-Credential admin@example.com
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MsolService -Credential $UserCredential

$country="singapore"

if($office -eq "sg")
{
		Add-DistributionGroupMember "Group SG" -member $email
}
elseif($office -eq "in")
{
		Add-DistributionGroupMember "Group Nongsa" -member $email
        
        $country="indonesa"
}


if($hp -eq "")
{
	Set-MsolUser -UserPrincipalName  $email -Title $title -Department $dept -office $country -Country $country  -PhoneNumber 12345678 
}
elseif($hp -ne "")
{
	Set-MsolUser -UserPrincipalName  $email -Title $title -Department $dept -office $country -Country $country -MobilePhone $hp -PhoneNumber 12345678
}

Set-User -Identity $email -manager $manager