function New-Password
{
  [CmdletBinding()]
  param(
  [int]$Length = 10,
  [int]$NonAlpha = 4
  )

    Begin
    {
      # Warn if nonalpha greater then length
      if($NonAlpha -gt $Length)
        {Write-Warning -Message "NonAlpha characters are greater than the total length";break}
      
      # Blank array list for creating password string
      [System.Collections.ArrayList]$pswd = @()

      # Blank array list for checking at least 1 capital letter
      [System.Collections.ArrayList]$capLetters = @()

      # Character sets used to build password
      $nonAplhaColl = ([char[]]([char]33..[char]64) + ([char[]]([char]91..[char]96)))
      $alphaColl = ([char[]]([char]65..[char]90)) + ([char[]]([char]97..[char]122))
    }
    Process
    {
      # Add nonAlpha chars
      $count = 0
      do
      {
        $pswd.Add($(Get-Random -InputObject $nonAplhaColl)) *>$null
        $count++
      }
      until($count -eq $NonAlpha)
      
      # Add alpha chars
      $count = 0
      do
      {
        $pswd.Add($(Get-Random -InputObject $alphaColl)) *>$null
        $count++
      }
      until ($count -eq ($length - $NonAlpha))
      
      # Confirm at least 1 capital letter
      $pswd | foreach {if([char]::IsUpper($_)){$capLetters.Add($_) *> $null}}
      if($capLetters.Count -eq 0)
        {
          # If no capital letters, capitalize first letter found in $pswd
          $firstLetter = $($pswd -cmatch '[a-z]')[0].tostring()
          $pswd = $pswd -replace $firstLetter,$firstLetter.toUpper() 
        }

    }
    End
    {
      # Randomize $pswd and output array into a single string
      ($pswd | Sort-Object {Get-Random}) -join ''
    }
}
