$inputData = get-content .\input\4
$total = 0

function checkContains ($group1, $group2) {
    ($null -eq ($group1 | where {$_ -notin $group2})) -or ($null -eq ($group2|where {$_ -notin $group1}))
}

function checkOverlap ($group1, $group2) {
   ($null -ne ($group1 | where {$_ -in $group2})) -or ($null -ne ($group2 | where {$_ -in $group1}))
}

foreach ($line in $inputData) {
    $g1, $g2 = $line -split ","
    $g11, $g12 = $g1 -split "-"
    $g21, $g22 = $g2 -split "-"
    $group1 = $g11..$g12
    $group2 = $g21..$g22
    # if ((checkContains $group1 $group2 )) {
    if ((checkOverlap $group1 $group2 )) {
        $total++
    }
}