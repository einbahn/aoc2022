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

# get content of / 
$root = Get-Instructions 2
# recurse through / depth first
solve $root "/" "/" | out-null
$ans = 0
# find folders with size smaller than 100,000
$total.Values | where {$_ -le 100000} | foreach { 
    $ans += $_ 
}
Write-host "Answer to part 1 is $ans"

# part 2
$needed = 30000000
$size = 70000000
$smallest = [double]::PositiveInfinity
foreach ($f in $total.Keys) {
    if (($size - $total["\"] + $total[$f]) -gt $needed -and $total[$f] -lt $smallest) {
        $smallest = $total[$f]
    }
}
write-host "Answer to part 2 is $smallest"