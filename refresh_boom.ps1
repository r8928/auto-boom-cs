.("./parameters.ps1")

function refresh_boom_file () {

  $callback = $false

  #open file
  $FilePath = $paths.dbox_folder + $paths.boom_folder + $paths.boom_filename

  if ((Test-Path $FilePath) -eq $true) {

    tskill excel

    # start Excel
    $excel = New-Object -comobject Excel.Application

    $workbook = $excel.Workbooks.Open($FilePath)

    #make it visible (just to check what is happening)
    $excel.Visible = $true

    progress_update "BOOM file opened, now refreshing queries" -step ($Global:prog_cur_step)

    #access the Application object and run a macro
    $app = $excel.Application
    $callback = $app.Run("import_queries_callback") #<------- Change this!!!
    Start-Sleep 10

    if ($callback -eq $true) {
      $workbook.Save()
      progress_update "BOOM file saved successfully" -step ($Global:prog_cur_step)

      Start-Sleep 20
    }

    $workbook.close($false)
    # $excel.Quit()
  }
  else {
    progress_update_error "BOOM file not found at its location $($FilePath)"
  }
  return $callback

}

# # debug
# clear
# .("./functions.ps1")
# refresh_boom_file