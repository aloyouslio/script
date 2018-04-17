#ResetPass user

param(

        [Parameter(Mandatory=$true)]
        [String]$Identity,
        [int]$Length = 8,
        [Switch]$NoChange,
		
	[Parameter(Mandatory=$false)]
	[String]$Password = ""
        
)


if($Password -eq "")
{
    [String[]]$RandomString = @('abcdefghijkmnopqrstuvwxyz', 'ABCEFGHJKLMNPQRSTUVWXYZ', '23456789', '!@$&')
    for ($i=0;$i -lt $length;$i++){
            $len=$i % ($RandomString.Length)
			$password+=$RandomString[$len][(get-random -maximum $RandomString[$len].length)]
    }
}

$secpass = ConvertTo-SecureString -String $Password -AsPlainText -Force
try
{
    $ADUser = Set-ADAccountPassword -Reset -NewPassword $secpass -Identity $Identity -PassThru -Confirm:$false -WhatIf:$false -ErrorAction Stop

    if(-Not $NoChange)
    {
        Set-ADUser -ChangePasswordAtLogon $true -Identity $ADUser -Confirm:$false -WhatIf:$false -ErrorAction Stop
    }

    Unlock-ADAccount -Identity $ADUser -Confirm:$false -WhatIf:$false -ErrorAction Stop
    Write-Host `r`nNew password for $Identity : $Password`r`n
}
catch
{
    throw $_
}

