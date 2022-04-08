.("./log_error.ps1")
# exit

Write-Host; Write-Host; Write-Host; Write-Host; Write-Host; Write-Host;

$Global:WrapperError = @{
  script_start_time = (Get-Date).ToString("u")
  script_host       = $env:computername
  ps_version        = $PSVersionTable.PSVersion.toString()
  log            = @()
}
$Global:prog_cur_step = 0
$Global:prog_total_steps = 0
$Global:prog_percent = 0
$Global:prog_cur_action = $null
$Global:prog_activity = $null
# $Global:prog_completed_steps = $null

$Host.PrivateData.ProgressForegroundColor = 'Yellow'
$Host.PrivateData.ProgressBackgroundColor = 'DarkCyan'

function writeError ($w_errorString, $longError) {

  $Global:WrapperError.log += (Get-Date).ToString("G")
  $Global:WrapperError.log += $w_errorString

  Write-Host

  if ($longError -ne 1) {
    $longErrorlen = ($w_errorString.length + 2)
    Write-Host (" " * $longErrorlen) -ForegroundColor White -BackgroundColor "Re"
    $w_errorString = " " + $w_errorString + " "
  }

  Write-Host $w_errorString  -ForegroundColor White -BackgroundColor Red

  if ($longError -ne 1) {
    Write-Host (" " * $longErrorlen) -ForegroundColor White -BackgroundColor "Re"
  }

  Write-Host

  return $w_errorString
}


function progressSet () {

  $Global:WrapperError.log += (Get-Date).ToString("G")
  $Global:WrapperError.log += $Global:prog_cur_action

  Write-Progress -Activity $Global:prog_activity -Status $Global:prog_cur_action -PercentComplete $Global:prog_percent
  Start-Sleep 2

}

function progress_update ($action, $step) {

  if ($action -ne $null -and $action -ne "") {
    $Global:prog_cur_action = $action
  }
  if ($step -eq $null -or $step -eq "") {
    $Global:prog_cur_step++
  }
  else {
    $Global:prog_cur_step = $step
  }

  $Global:prog_percent = $Global:prog_cur_step / $Global:prog_total_steps * 100
  $Global:prog_activity = "AutoBOOM Bot: Step $($Global:prog_cur_step)/$($Global:prog_total_steps)"

  # if ($Global:prog_completed_steps -ne $null) {
  #   $Global:prog_activity = $Global:prog_completed_steps + " - " + $Global:prog_activity
  # }

  progressSet

}


function progress_update_error ($action) {

  $Global:prog_cur_action = $action

  $host.privatedata.ProgressBackgroundColor = "DarkRed";
  $host.privatedata.ProgressForegroundColor = "White";
  progressSet

  logError $action

  Start-Sleep 2
}


# function logCompletedSteps ($step) {
#   $Global:prog_completed_steps += $step + " - "
# }