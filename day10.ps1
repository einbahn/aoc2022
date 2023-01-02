class Point {
    [int]$x
    # [int]$y
    [bool]$lit
    [string]ToString() {
        if ($this.lit) {
            return "#"
        } else {
            return "."
        }
        # return ("{0} {1}" -f $this.x, $this.y)
    }
    Knot(
        [int]$x
        # [int]$y
        ) {
        $this.x = $x
        # $this.y = $y
        $this.lit = $false
    }
}

$X = 1
$cycle = 0
$inputData = get-content .\input\10
$crt = foreach ($i in (0..240)) {
    [Point]::new(0, 0)
}





# function checkCycle {
#     $strength = 0
#     switch ($cycle) {
#         20 { $strength += 20 * $X; break }
#         60 { $strength += 60 * $X; break }
#         100 { $strength += 100 * $X; break }
#         140 { $strength += 140 * $X; break }
#         180 { $strength += 180 * $X; break }
#         220 { $strength += 220 * $X; break }
#     }
#     $strength
# }

function checkCycle {
    # if sprite position overlaps with current pixel
    if ($cycle -in $($x-1, $x, $x+1)) {
        $crt[$cycle].lit = $true
    }

}



foreach ($i in $inputData) {
    if ($i -eq 'noop') {
        $cycle++
        $strength += checkcycle
    }
    else {
        $_, $n = $i -split "\s"
        0..1 | ForEach-Object {
            $cycle++
            $strength += checkcycle
        }
        $X += $n 
    }
}

write-host $strength