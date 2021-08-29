function get_files{
    Param ($FileExtension)
    $List = Get-ChildItem . -Recurse | where {$_.Extension -eq $FileExtension} | Select-Object FullName
    Write-Output $List
}

function extract_dates_from_filename{
    param ($files, $extension)
    $extracted_dates = @()
    foreach ($file in $files) {
        Write-Output $file
        $file -match "(\d\d\d\d)(\d\d)(\d\d)$extension"
        $year = $Matches[1]
        $month = $Matches[2]
        $day = $Matches[3]
        $complete_date = "$month/$day/$year 08:00:00"
        $extracted_dates += $complete_date
    }

    Write-Output $extracted_dates

}

$extension = ".pdf"

$files = get_files $extension

$dates = extract_dates_from_filename $files $extension

Write-Output $dates
