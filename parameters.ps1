$dt = @{

  switchOverDay       = 4
  file_threshold_time = "10:00 AM"

}

$dt.today = (Get-Date).AddDays(-$dt.switchOverDay)
$dt.month = ("$($dt.today.Month)/$($dt.today.Year)") -as [DateTime]
$dt.yesterday = $dt.month.AddMonths(1).AddDays(-$dt.month.Day)


$paths = @{

  dbox_folder         = "C:\Dropbox\"
  selenium_path       = "C:\selenium\"

  ranker_folder       = "AutoPull\MyResultsHistoricalAnalysis\"

  boom_folder         = "OpSupport Team Folder\Cell Shop\SB\"
  boom_filename       = "StoreBoard.xlsm"
  boom_r_err_filename = "autopull_errors.log"

  error_email_url     = "https://boom.cellshop.us/api/v1/send_mail"
  email_sendto        = "tmp.rashid@gmail.com"

}



if ($dt.yesterday -ge (Get-Date)) { $dt.yesterday = (Get-Date).AddDays(-1) }
$dt.yesterday = ("$($dt.yesterday.ToString("yyyy-MM-dd")) $($dt.file_threshold_time)") -as [DateTime]
