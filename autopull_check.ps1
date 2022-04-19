Clear-Host
.("./parameters.ps1")
$Global:RB_errors = @()

function createDirectory ($Directory) {
  If (!(Test-Path $Directory)) {
    try {
      New-Item -ItemType Directory -Force -Path $Directory
      return $true
    }
    catch {
      writeError ("Failed to create directory " + $Directory) -longError 1
      writeError $_.Exception.Response -longError 1
    }
  }
  else {
    return $true
  }
  return $false
}


function checkFile ($Directory, $FilePattern) {

  # Refresh BOOM object
  $RB = @{
    searchString                  = $FilePattern
    folder_path                   = $paths.dbox_folder + $Directory

    folder_not_empty              = $false
    folder_has_right_qty_of_files = $false

    file_name                     = $false

    file_timestamp                = $false
    file_has_correct_timestamp    = $false

    file_size                     = $false
    file_has_correct_size         = $false
  }

  $RB.folder_exists = createDirectory $RB.folder_path

  if ($RB.folder_exists) {

    $list = $null
    $list = Get-ChildItem -Path $RB.folder_path -File -Filter $FilePattern | Sort-Object LastWriteTime -Descending

    $RB.qty_of_files_in_folder = $list.Count

    $RB.folder_not_empty = $list.Count -ne 0
    $RB.folder_has_right_qty_of_files = $RB.qty_of_files_in_folder -ge 2

    if ($RB.folder_not_empty) {
      if ($RB.folder_has_right_qty_of_files) {

        $RB.file_name = $list[0].Name

        $RB.file_timestamp = $list[0].LastWriteTime
        $RB.file_has_correct_timestamp = $RB.file_timestamp -gt $dt.yesterday

        $RB.file_size = $list[0].Length
        $RB.file_has_correct_size = $RB.file_size -gt ($list[1].Length * 0.9)
      }
    }
  }


  if ($RB.folder_exists -eq $false) {
    $Global:RB_errors += "$($RB.searchString): Folder not found " + $RB.folder_path
  }

  if ($RB.folder_not_empty -eq $false) {
    $Global:RB_errors += "$($RB.searchString): No file in folder " + $RB.folder_path
  }


  if ($RB.folder_not_empty -eq $true -and $RB.folder_has_right_qty_of_files -eq $false) {
    $Global:RB_errors += "$($RB.searchString): Only $($RB.qty_of_files_in_folder) files in folder"
  }

  if ($RB.file_has_correct_size -eq $false) {
    $Global:RB_errors += "$($RB.searchString): Today's file_size ($($RB.file_size)) is smaller than previous file's"
  }

  if ($RB.file_has_correct_timestamp -eq $false) {
    $Global:RB_errors += "$($RB.searchString): Last file is older than ($($dt.yesterday))"
  }


}

function autopull_check () {

  try {

    $void = checkFile $paths.ranker_folder "AT&T MyResults - Historical Analysis-RANKER_2_LOCATION*.xlsx"
    $void = checkFile $paths.ranker_folder "AT&T MyResults - Historical Analysis-RANKER_2_RAE*.xlsx"
    $void = checkFile $paths.ranker_folder "AT&T MyResults - Historical Analysis-RANKER_1_RAE*.xlsx"
    $void = checkFile $paths.ranker_folder "AT&T MyResults - Historical Analysis-RANKER_1_LOCATION*.xlsx"

    if ($null -eq $Global:RB_errors -or $Global:RB_errors.Length -eq 0) {
      # Write-Host "All good"
      return $true
    }
    else {

      $Global:RB_errors = $Global:RB_errors | ConvertTo-Json
      $Global:RB_errors = 'AutoPull Errors: ' + $Global:RB_errors

      $void = writeError( $Global:RB_errors) -longError 1

      $Global:RB_errors = @((Get-Date).toString("G")) + $Global:RB_errors
      $Global:RB_errors | Out-File "$($paths.dbox_folder)$($paths.boom_folder)$($paths.boom_r_err_filename)"

    }
    return $false

  }
  catch {

    $tmp = New-TemporaryFile
    Write-Host $tmp.FullName
    $out = "AUTOPULL ERRORS" + "`n" + $_.Exception.Response
    $out | Out-File $tmp.FullName
    notepad $tmp.FullName

    writeError $_.Exception.Response -longError 1

  }

}

# # debug
# clear
# .("./functions.ps1")
# autopull_check