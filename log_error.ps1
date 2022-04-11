.("./parameters.ps1")
# .("./sk_bot.ps1")
# exit

$Global:WrapperError = @{
  script_start_time = (Get-Date).ToString("u")
  script_host       = $env:computername
  ps_version        = $PSVersionTable.PSVersion.toString()
  log               = @()
}

function logError ($lw_errorString) {


  # $sklog = log_error_skype $lw_errorString
  $emllog = log_error_email ($lw_errorString)



  $log_path = "$($PSScriptRoot)\logs\AutoBOOM_$($Global:WrapperError.script_start_time.Replace(":", ".")).log"
  $Global:WrapperError | ConvertTo-Json | Out-File $log_path


}

function log_error_skype ($ls_messageString) {
  progress_update "logging on skype" -step $Global:prog_cur_step
  try {
    $sk_e = send_skype_msg $lw_errorString
  }
  catch { }
  if ($sk_e -ne $true) {
    writeError $sk_e
    return $false
  }
  else {
    return $true
  }
}

function log_error_email ($le_errorString, $isSuccesss) {

  progress_update "logging on email" -step $Global:prog_cur_step
  $secret_key = '$2y$10$e/sDCcVhr7XKONZyInyksuYszIVi3E.KkGdpXu8PcB5v3TVCQLnIK'

  # $Global:WrapperError.log += $le_errorString
  # $Global:WrapperError.log += $le_errorString

  $wp_js = ($Global:WrapperError | ConvertTo-Json )

  $errorString2 = $le_errorString
  $errorString2 = $errorString2 + '<p class="text-muted">Additional Info:</p>'
  $errorString2 = $errorString2 + '<pre>'
  $errorString2 = $errorString2 + $wp_js
  $errorString2 = $errorString2 + "</pre>"


  if ($isSuccesss -eq 1) { $heading = 'BOOM Bot Successful' } else { $heading = 'BOOM Bot Failure' }



  $postParams = @{
    secret    = $secret_key;
    subject   = $heading
    heading   = $heading
    body_text = $errorString2
    to        = $paths.email_sendto
    bcc       = $paths.email_sendbcc
  }

  $header = @{
    "Content-Type" = "application/json"
  }


  # return Invoke-WebRequest -Uri $paths.error_email_url -Method POST -Body $postParams
  $postParams = $postParams | ConvertTo-Json
  return Invoke-RestMethod -Uri $paths.error_email_url -Method POST -Body $postParams -Headers $header

}
# clear
# write-host (get-date)
# $x = log_error_email("hello")
# $x
# $x.Content