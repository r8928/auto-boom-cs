$dt = @{

  switchOverDay       = 4
  file_threshold_time = "12:00 PM"

}

$dt.today = (Get-Date).AddDays(-$dt.switchOverDay)
$dt.month = ("$($dt.today.Month)/$($dt.today.Year)") -as [DateTime]
$dt.yesterday = $dt.month.AddMonths(1).AddDays(-$dt.month.Day)


$paths = @{

  dbox_folder         = "C:\Dropbox\"
  selenium_path       = "C:\selenium\"

  dcs_folder          = "AutoPull\DCS\$($dt.month.ToString('MM-yyyy'))\"
  boomsbi_folder      = "AutoPull\BOOM-Stacks\$($dt.month.ToString('MM-yyyy'))\"
  sort_folder         = "AutoPull2\DealerSort\$($dt.month.ToString('MM-yyyy'))\"

  boom_folder         = "#DM Vault\" + $dt.month.Year + "\" + $dt.month.ToString('yyyy-MM') + "\BOOM\"
  boom_filename       = "@Boom" + $dt.month.ToString('yyyy-MM') + ".xlsm"
  boom_r_err_filename = "autopull_errors.log"

  error_email_url     = "https://boom.talkmobilenet.com/api/v1/send_mail"
  email_sendto        = "tmp.rashid@gmail.com,commissions@talkmobilenet.com,moojid@talkmobilenet.com"

}



if ($dt.yesterday -ge (Get-Date)) { $dt.yesterday = (Get-Date).AddDays(-1) }
$dt.yesterday = ("$($dt.yesterday.ToString("yyyy-MM-dd")) $($dt.file_threshold_time)") -as [DateTime]
