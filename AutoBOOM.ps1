Clear

.("./parameters.ps1")
.("./functions.ps1")
.("./refresh_boom.ps1")
.("./autopull_check.ps1")
.("./log_error.ps1")
# .("./sk_bot.ps1")


$Global:prog_total_steps = 5
progress_update "Imports initialized"
# exit





progress_update "Checking AutoPull Status" -step 0
$step1 = autopull_check

if ($step1 -ne $true) {

  if ($step1 -eq $false) {
    $stpError = "Error occured while performing AutoPull Check"
  }
  else {
    $stpError = $step1
  }
  progress_update_error $stpError
  Exit
}






progress_update "Opening BOOM file for refreshing queries"
$step2 = refresh_boom_file

if ($step2 -ne $true) {
  if ($step2 -eq $false) {
    $stpError = "Error occured while refreshing BOOM file"
  }
  else {
    $stpError = $step2
  }
  progress_update_error $stpError
  Exit
}
else {
  progress_update "BOOM refreshed successfully"
}



log_error_email "Successfully finished" -isSuccesss 1
$log_path = "$($PSScriptRoot)\logs\AutoBOOM_$($Global:WrapperError.script_start_time.Replace(":", ".")).log"
$Global:WrapperError | ConvertTo-Json | Out-File $log_path