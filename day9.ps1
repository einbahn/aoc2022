$inputData = get-content .\input\9

class Knot {
    [int]$x
    [int]$y
    [string]ToString() {
        return ("{0} {1}" -f $this.x, $this.y)
    }
    Knot(
        [int]$x,
        [int]$y) {
        $this.x = $x
        $this.y = $y
    }
}

$s = [Knot]::new(0, 0)
# part 1
$knots = 0..1 | Foreach-Object {
# # part 2
# $knots = 0..9 | Foreach-Object {
    [Knot]::new(0, 0)
}
$H = $knots[0]
$T = $knots[-1]
$tailpos = [ordered]@{}
$tailpos[$s] = $null
 
function update-knots ($direction) {
    for ($i = 0; $i -lt $knots.Count - 1; $i++) {
        $curr = $knots[$i]
        $next = $knots[$i + 1]

        # if curr is Head, update curr
        if ($curr -eq $H) {
            switch ($direction) {
                'R' { $curr.x++ }
                'L' { $curr.x-- }
                'U' { $curr.y++ }
                'D' { $curr.y-- }
            }
        }

        # if curr and next are diagonal, overlapping, or adjacent, do nothing
        if (($curr.x + 1 -eq $next.x -and $curr.y + 1 -eq $next.y) -or 
            ($curr.x - 1 -eq $next.x -and $curr.y + 1 -eq $next.y) -or
            ($curr.x + 1 -eq $next.x -and $curr.y - 1 -eq $next.y) -or
            ($curr.x - 1 -eq $next.x -and $curr.y - 1 -eq $next.y) -or
            ($curr.x -eq $next.x -and $curr.y -eq $next.y) -or
            ($curr.x - 1 -eq $next.x -and $curr.y -eq $next.y) -or 
            ($curr.x + 1 -eq $next.x -and $curr.y -eq $next.y) -or
            ($curr.y - 1 -eq $next.y -and $curr.x -eq $next.x) -or
            ($curr.y + 1 -eq $next.y -and $curr.x -eq $next.x)
        ) { continue }

        # current is neither adjacent nor diagonal to next, so an update needs to be made
        switch ($direction) {
            'R' {
                # current vs next
                if ($curr.x -gt $next.x) {
                    $next.x++
                }
                elseif ($curr.x -lt $next.x) {
                    $next.x--
                }
                if ($curr.y -gt $next.y) {
                    $next.y++
                }
                elseif ($curr.y -lt $next.y) {
                    $next.y--
                }
            }
            'L' {
                if ($curr.x -lt $next.x) {
                    $next.x--
                }
                elseif ($curr.x -gt $next.x) {
                    $next.x++
                }
                if ($curr.y -gt $next.y) {
                    $next.y++
                }
                elseif ($curr.y -lt $next.y) {
                    $next.y--
                }
            }
            'U' {
                if ($curr.y -gt $next.y) {
                    $next.y++
                }
                elseif ($curr.y -lt $next.y) {
                    $next.y--
                }
                if ($curr.x -gt $next.x) {
                    $next.x++
                }
                elseif ($curr.x -lt $next.x) {
                    $next.x--
                }

            }
            'D' {
                if ($curr.y -lt $next.y) {
                    $next.y--
                }
                elseif ($curr.y -gt $next.y) {
                    $next.y++
                }
                if ($curr.x -gt $next.x) {
                    $next.x++
                }
                elseif ($curr.x -lt $next.x) {
                    $next.x--
                }
            }
        }
        if ($next -eq $T) { $tailpos[$next.toString()] = $null }
    }
}

foreach ($i in $inputData) {
    $dir, $n = $i -split "\s"
    0..($n - 1) | ForEach-Object {
        switch ($dir) {
            'R' {
                update-knots $dir
            }
            'L' {
                update-knots $dir
            }
            'U' {
                update-knots $dir
            }
            'D' {
                update-knots $dir
            }
        }
    }
}

write-host "$($($tailpos.Keys | measure-object).count)"