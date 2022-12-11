$inputData = get-content input\8
$len = $inputData[0].Length # len is x axis
$width = $inputData.Length # width is y axis
$ans = 0
$ans += 2 * ($len + $width) - 4
$start = @(1, 1)
$end = @( ($len-2), ($width-2))

function find ($x, $y) {
    try {
        $curr = $inputData[$x][$y]
        $found = $false
        while ($true) {
            # look up - decrement y until y == 0
            $values = $null
            $values = ($y-1)..0 | foreach {
                $inputData[$x][$_]
            }
            if ($null -eq ($values | where {$_ -ge $curr})) {
                $found = $True
                break
            }

            # look left - decrement x until x == 0
            $values = $null
            $values = ($x-1)..0 | foreach {
                $inputData[$_][$y]
            }
            if ($null -eq ($values | where {$_ -ge $curr})) {
                $found = $True
                break
            }
            
            # look right - increment x until x == length-1
            $values = $null
            $values = ($x+1)..($len-1) | foreach {
                $inputData[$_][$y]
            }
            if ($null -eq ($values | where {$_ -ge $curr})) {
                $found = $True
                break
            }

            # look down - increment y until y == width-1
            $values = $null
            $values = ($y+1)..($width-1) | foreach {
                $inputData[$x][$_]
            }
            if ($null -eq ($values | where {$_ -ge $curr})) {
                $found = $True
                break
            }
            break
        }
        $found    
    }
    catch {
        write-host "error"
    }
}


foreach ($x in ($start[0]..$end[0])) {
    foreach ($y in $start[1]..$end[1]) {
        # write-host "$x, $y"
        if (find $x $y) {
            $ans++
        }
        write-host $ans
    }
}