function New-Password
{
  [CmdletBinding()]
  param(
  [int]$Length = 10,
  [int]$NonAlpha = 4
  )

    Begin
    {
      if($NonAlpha -gt $Length)
        {Write-Warning -Message "NonAlpha characters are greater than the total length";break}
      $pswd = @()
      $nonAplhaColl = ([char[]]([char]33..[char]64) + ([char[]]([char]91..[char]96)))
      $alphaColl = ([char[]]([char]65..[char]90)) + ([char[]]([char]97..[char]122))
    }
    Process
    {
      $x = 0
      do
      {
        $pswd += (Get-Random -InputObject $nonAplhaColl)    
        $x++
      }
      until ($x -eq $NonAlpha)
      
      $x = 0
      do
      {
        $pswd += (Get-Random -InputObject $alphaColl)    
        $x++
      }
      until ($x -eq ($length - $NonAlpha))      

    }
    End
    {
      ($pswd | sort {Get-Random}) -join ''
    }
}