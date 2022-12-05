$chunks = (get-content .\input1 -raw) -split "`r`n`r`n"

# $highest = 0
$res = foreach ($chunk in $chunks) {
    $sum = 0
    foreach ($line in ($chunk -split "`n")) {
        $sum += $line
    }
    $sum
}

# part 1
$res | sort -desc | select -first 1 

# part 2
$res | sort -desc | select -first 3 | measure-object -sum