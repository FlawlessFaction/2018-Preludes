# Found this preulde by the coffee. Has the Shadow faction logo on it, so may be a redherring.
using System.Web
using System.Web.Security

function New-Password {
    [cmdletbinding()]
    param(
        [int]$length = 10,
        [int]$maxNA = 4
    )
    While($true){
        $pswd = [membersip]::GeneratePassword($length,$MaxNA)
        ## at least 1 letter and numeric
        ## to match AD complexity requirements
        switch ($pswd){
            {$_ -cnotmatch '[a-z]'}{continue}
            {$_ -cnotmatch '[0-9'}{continue}
        }
        $g = $pswd -Split '' |
        where {$_ -ne ''} |
        Group-Object |
        sort count -Descending

        if ($g[0].Count -eq 1){
            $pswd
            break
        }
    }
}