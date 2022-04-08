.("./parameters.ps1")

function refresh_boom_file () {

  $callback = $false

  #open file
  $FilePath = $paths.dbox_folder + $paths.boom_folder + $paths.boom_filename

  if ((Test-Path $FilePath) -eq $true) {

    Get-Process -Name excel -ErrorAction SilentlyContinue | Stop-Process -Force

    # start Excel
    $excel = New-Object -comobject Excel.Application

    $workbook = $excel.Workbooks.Open($FilePath)

    #make it visible (just to check what is happening)
    $excel.Visible = $true

    progress_update "BOOM file opened, now refreshing queries" -step ($Global:prog_cur_step)

    #access the Application object and run a macro
    $app = $excel.Application

    # https://stackoverflow.com/a/21175812/7518989
    progress_update "SB_AUTOMATION_REFRESH_SB" -step ($Global:prog_cur_step)
    $callback = $app.Run("SB_AUTOMATION_REFRESH_SB")
    Start-Sleep 10

    if ($callback -eq $true) {
      progress_update "BOOM FILE REFRESHED" -step ($Global:prog_cur_step)

      Start-Sleep 3
    }
    elseif ($callback -eq $false -or $null -eq $callback) {
      return "ERROR SB_AUTOMATION_REFRESH_SB"
    }
    else {
      return $callback
    }

    progress_update "SB_AUTOMATION_UPLOAD_SB" -step ($Global:prog_cur_step)
    $callback = $app.Run("SB_AUTOMATION_UPLOAD_SB")
    Start-Sleep 10

    if ($callback -eq $true) {
      $workbook.Save()
      progress_update "BOOM FILE PREPARED" -step ($Global:prog_cur_step)

      Start-Sleep 3
    }
    elseif ($callback -eq $false -or $null -eq $callback) {
      return "ERROR SB_AUTOMATION_UPLOAD_SB"
    }
    else {
      return $callback
    }

  }
  else {
    progress_update_error "BOOM file not found at its location $($FilePath)"
  }

  Get-Process -Name excel -ErrorAction SilentlyContinue | Stop-Process -Force
  return $callback

}

# # debug
# clear
# .("./functions.ps1")
# refresh_boom_file