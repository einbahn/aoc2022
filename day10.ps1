$inputData = get-content ./input/10
$x = 1
$cycle = 0
$rowSize = 40
$res = [object[,]]::new(6, 40)

function checkCycle ($crt) {
    $row = [int][math]::floor(($cycle-1)/$rowSize)
    $col = ($cycle-1) % $rowSize
    try {
        if ($col -in (($x-1), $x, ($x+1))) {
            $crt[$row,$col] = "#"
        } else {
            $crt[$row,$col] = "."
        }
    } catch {
        write-host "$($_.Exception.message)"
        write-host "error indexes: $row, $col"
    }
}
 
foreach ($i in $inputData)
{
    if ($i -imatch 'add') {
        $_, $n = $i -split "\s"
        0..1 | foreach-object {
            $cycle++
            checkCycle $res
        }
        $x += $n
    } else {
        $cycle++
        checkCycle $res 
    }
}

foreach ($i in 0..5) {
    $temp = @()
    foreach ($j in 0..39) {
        $temp += $res[$i, $j]
    }
    write-host "$temp"
}