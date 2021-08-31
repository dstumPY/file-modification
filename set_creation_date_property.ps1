function get_files{
    <#
    .SYNOPSIS
        Return all files below the scripts directory matching a file extension.

    .PARAMETER $fileExtension
        Specify the matching file extension including leading dot as string, e.g. ".pdf".

    .EXAMPLE 
        get_files ".pdf"
    #>
    Param ($fileExtension)

    $List = Get-ChildItem . -Recurse | where {$_.Extension -eq $fileExtension} | Select-Object FullName
    Return $List
}


function extract_dates_from_filename{
    <#
    .SYNOPSIS
        Extract last digits prior to a trailing file name extension, cast them as date and set them as new CreationDat.

    .PARAMETER $files
        List of absolute file paths.

    .PARAMETER $fileExtension
        Specify the matching file extension including leading dot as string, e.g. ".pdf".

    .EXAMPLE
        extract_dates_from_filename @(pathA, pathB, ..) ".pdf"
    #>
    param ($files, $fileExtension)

    $extracted_files = @()
    $extracted_dates = @()
    foreach ($file in $files) {

        # match date format YYYYMMDD
        $cond = $file -match "(\d\d\d\d)(\d\d)(\d\d)$fileExtension"
        if($cond) {
            $year = $Matches[1]
            $month = $Matches[2]
            $day = $Matches[3]

            # append date format "MM/DD/YYYY 08:00:00"
            $complete_date = "$month/$day/$year 08:00:00"
            $extracted_dates += $complete_date
            $extracted_files += $file
        }else {
            # skip not-matching files
            Write-Output "Skipped file $file"
        }
    }

    Return $extracted_dates, $extracted_files

}


function update_creation_date{
    <#
    .SYNOPSIS
        Set $date (8:00 am) as new file CreationTime.

    .PARAMETER $file
        file path to file that needs to be updated

    .PARAMETER $date
        provided date to set

    .EXAMPLE
        update_creation_date "<file_path>" "MM/DD/YYYY HH:MM:SS"
    #>

    param ($file, $date)

    Set-ItemProperty -Path $file -Name CreationTime -Value $date
}


# init extension of interest
$extension = ".pdf"

# list all extension-matching files
$files = get_files $extension

# extract casted date and file
$dates, $filtered_files = extract_dates_from_filename $files $extension

# set extracted dates as CreationTime 
$length = $filtered_files.Length
for($i=0; $i -lt $length; $i++) {
    update_creation_date $filtered_files[$i] $dates[$i]
}
