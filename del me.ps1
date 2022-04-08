clear
$Global:WrapperError = @{
  script_start_time = (Get-Date).ToString("u")
  script_host       = $env:computername
  ps_version        = $PSVersionTable.PSVersion.toString()
  log            = @()
}
"$($PSScriptRoot)\AutoBOOM_$($Global:WrapperError.script_start_time).log".Replace(":",".")
# $Global:WrapperError | ConvertTo-Json | Out-File "$($PSScriptRoot)\AutoBOOM_$($Global:WrapperError.script_start_time).log"