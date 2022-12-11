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
        while ($true) {
            # look up - decrement y until y == 0
            
            $d1 = 0
            if ($y -ne 0) {
                foreach ($i in (($y-1)..0)) {
                    $val = $inputData[$x][$i]
                    if ($val -lt $curr) {
                        $d1++
                    } elseif ($val -ge $curr) {
                        $d1++
                        break
                    } 
                }
            }
            write-host $d1
            
            # look left - decrement x until x == 0
            $d2 = 0
            if ($x -ne 0) {
                foreach ($i in (($x-1)..0)) {
                    $val = $inputData[$i][$y]
                    if ($val -lt $curr) {
                        $d2++
                    } elseif ($val -ge $curr) {
                        $d2++
                        break
                    }
                }
            }
            write-host $d2
            

            # look right - increment x until x == length-1
            $d3 = 0
            if ($x -ne ($len-1)) {
                foreach ($i in (($x+1)..($len-1))) {
                    $val = $inputData[$i][$y]
                    if ($val -lt $curr) {
                        $d3++
                    } elseif ($val -ge $curr) {
                        $d3++
                        break
                    } 
                }
            }
            write-host $d3
            # look down - increment y until y == width-1
            $d4 = 0
            if ($y -ne ($width-1)) {
                foreach ($i in (($y+1)..($width-1))) {
                    $val = $inputData[$x][$i]
                    if ($val -lt $curr) {
                        $d4++
                    } elseif ($val -ge $curr) {
                        $d4++
                        break
                    } 
                }
            }
            write-host $d4
            break
        }
        $d1 * $d2 * $d3 * $d4
    }
    catch {
        write-host "error"
    }
}


$highest = 0
foreach ($x in (0..($len-1))) {
    foreach ($y in (0..($width-1))) {
        $vd = find $x $y
        if ($vd -gt $highest) {
            $highest = $vd
        }
    }
}



