function test-adpath {
    [cmdletbinding()]
    param (
        [ValidateSet('OU','CN')]
        [string]$type,
        [string]$name,
        [string]$path
    )
    Test-Path -Path "AD:\type=name,path"
}

function New-OU {
    [cmdletbinding()]
    param(
        [string]$name,
        [string]$description,

        [string]$streetaddress,
        [string]$pobox,
        [string]$city,

        [Alias('zipcode')]
        [string]$postcode,

        [Alias('province')]
        [string]$state,
        [string]$country
    )
    BEGIN {
        if (-not $path){
            $path = Get-ADDomain
            Select -ExpandProperty DistinguishedName
        }
    }

    PROCESS {
        if (test-adpath -type OU -Name $name -path $path) {
            throw "OU $name,$path already exists"
        }

        $sb = [system.test.stringbuilder]::new()
        $vars = 'name', 'path', 'description', 'displayname', 'streetaddress',
                'pobox', 'city', 'postcode', 'state', 'country'

        foreach($var in $vars){
            $v = Get-variable -Name $var -ErrorAction SilentlyContinue

            if ($var -eq 'streetaddress'){
                Write-Verbose -Message "`$var -eq 'streetaddress'"
                if(($v.value).indexof("`n") -gt 0){
                    continue
                }
            }
            if ($v.value){
                $sline = "$((Get-Culture).TextInfo) = $($v.Value)"
                [void]$sb.AppendLine($sline)
            }

            $topsplat = ConvertFrom-StringData -StringData $sb.toString()

            if($topsplat['StreetAddress']){
                New-AdOrganizationalUnit @topsplat
            }
            else{
                New-AdorganizationalUnit $topsplat -StreetAddress $streetaddress
            }
        }
    } # end PROCESS
    <#
    $stree = @'
    Floor 3
    1456 New Street
    District 1
    '@

    New-OU -name test1 -description 'test one' -city London -streetaddress $street
    #>
}