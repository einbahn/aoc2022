$inputData = get-content .\input\6

function proc_ ($line, $numChars) {
    $idx = 0
    $found = $false
    while (-not $Found) {
        if ( ($line[$idx..($idx+$numChars-1)] | sort | get-unique | measure-object).count -eq $numChars) {
            $found = $True
        } else {
            $idx++
        }
    }
    return $idx + $numChars
}

foreach ($i in $inputData) {
    # part 1
    write-host "$(proc_ $i 4)"

    # part 2
    write-host "$(proc_ $i 14)"
}