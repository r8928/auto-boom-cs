$dt = @{

  switchOverDay       = 4
  file_threshold_time = (Get-Date).Date # start of day today

}

$dt.today = (Get-Date).AddDays(-$dt.switchOverDay)
$dt.month = ("$($dt.today.Month)/$($dt.today.Year)") -as [DateTime]


$paths = @{

  dbox_folder         = "C:\Dropbox\"
  selenium_path       = "C:\selenium\"

  ranker_folder       = "AutoPull\MyResultsHistoricalAnalysis\"

  boom_folder         = "OpSupport Team Folder\Cell Shop\SB\"
  boom_filename       = "StoreBoard.xlsm"
  boom_r_err_filename = "autopull_errors.log"

  error_email_url     = "https://boom.cellshop.us/api/v1/send_mail"
  email_sendto        = "reporting@cellshop.us"
  email_sendbcc       = "tmp.rashid@gmail.com"

}
