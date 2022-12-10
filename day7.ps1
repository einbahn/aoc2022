$inputData = get-content .\input\7
$total = [ordered]@{}
function Get-Instructions ($start) {
    $inst = @()
    foreach ($line in $inputData[$start..$inputData.Length]) {
        if ($line -imatch '^\$') {
            break
        }
        $inst += new-object -typename psobject -property @{
            'instruction' = $line
            'index' = $start
        }
        $start++
    }
    $inst
}

function findMatchingCmd ($currentIndex, $folderName, $path) {
    $currentPath = $path
    while ($True) {
        $curr = $inputData[$currentIndex]
        if ($curr -imatch '\$ cd ([\w]+)') {
            if ($Matches[1] -eq $folderName -and $path -eq $currentPath) {
                break
            } else {
                $currentPath = Join-Path $currentPath $Matches[1]
            }
        } elseif ($curr -eq '$ cd ..') {
            $currentPath = Split-Path -Path $currentPath -Parent
        }
        $currentIndex++
    }
    $currentIndex
}

function solve ($contents, $folder, $currentPath) {
    $t = 0
    $currentPath = Join-Path $currentPath $folder
    foreach ($entry in $contents) {
        $instruction = $entry.instruction 
        $idx = $entry.index
        if ($instruction -imatch 'dir') {
            $folderName = ($instruction -split "\s")[1] 
            # find matching $ cd $foldername 
            $matchingIndex = findMatchingCmd $idx $foldername $currentPath
            $inst = Get-Instructions ($matchingIndex + 2)
            $t += solve $inst $foldername $currentPath
        } else {
            $size = ($instruction -split "\s")[0]
            $t += $size
        }
    }
    $total[$currentPath] = $t
    # return the size of this folder
    $t
}

$root = Get-Instructions 2
solve $root "/" "/" | out-null

$ans = 0
$total.Values | where {$_ -le 100000} | foreach { 
    $ans += $_ 
}

Write-host "$ans"