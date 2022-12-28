$inputData = get-content ./input/12
$len = $inputData.Length
$wid = $inputData[0].Length

class Node {
    [int]$x
    [int]$y
    [char]$value
    [Node[]]$adjacency
    [string]ToString() {
        return ("{0} {1} {2}" -f $this.x, $this.y, $this.value)
    }
    Node(
        [int]$x,
        [int]$y,
        [char]$value
    ) {
        $this.x = $x
        $this.y = $y
        $this.value = $value

    }
}

$map = [object[,]]::new($len, $wid)
for ($i = 0; $i -lt $len; $i++) {
    for ($j = 0; $j -lt $wid; $j++) {
        $map[$i, $j] = [Node]::new($i, $j, $inputData[$i][$j])
    }
}

foreach ($i in (0..($len-1))) {
    foreach ($j in (0..($wid-1))) {
        $curr = $map[$i, $j]
        $indexes = @(
            (($i+1), $j),
            (($i-1), $j),
            ($i, ($j+1)),
            ($i, ($j-1))
        )
        foreach ($idx in $indexes) {
            if ($idx[0] -ge 0 -and $idx[1] -ge 0 -and $idx[0] -lt $len -and $idx[1] -lt $wid) {
                $adj = $map[$idx[0], $idx[1]]
                switch -Exact -CaseSensitive ($adj.value) {
                    'S' { $adjVal = 'a'; break}
                    'E' { $adjVal = 'z'; break}
                    default { $adjVal = $adj.value; break}
                }

                switch -Exact -CaseSensitive ($curr.value) {
                    'S' { $currVal = 'a'; break}
                    'E' { $currVal = 'z'; break}
                    default { $currVal = $curr.value; break}
                }
                
                if (([byte][char]$currVal - [byte][char]$adjVal) -ge -1) {
                    $curr.adjacency += $adj
                }
            }
        }
    }
}

function bfs ($start, $stop){
    $shortestDistance = -1
    $previous = @{}
    $visited = @{}
    $queue = [system.collections.queue]::new()
    $queue.Enqueue([pscustomobject]@{
        Node = $start
        Distance = 0
    })
    $visited.Add($start, $null) 
    while ($queue.Length -gt 0) {
        $res = $queue.Dequeue()
        $node = $res.Node
        $distance = $res.distance
        if ($node -eq $stop) {
            return ($distance, $previous)
        }
         
        foreach ($neighbor in $node.adjacency) {
            if (-not ($neighbor -in $visited.keys)) {
                $previous[$neighbor] = $node
                $queue.Enqueue([pscustomobject]@{
                    Node = $neighbor
                    Distance = ($distance + 1)
                })
                $visited.Add($neighbor, $null) 
            }
        }
    }
    return ($shortestDistance, $previous)
}

$startNode = $map | where {$_.Value -ceq 'S'}
$stopNode = $map | where {$_.Value -ceq 'E'}
$d, $prev = bfs $startNode $stopNode

# function buildPath ($stopNode, $previous) {
#     $path = [system.collections.stack]::new()
#     $path.push($stopNode)
#     $next = $previous[$stopNode]
#     while ($null -ne $next) {
#         $path.push($next)
#         $next = $previous[$next]
#     }
#     return $path
# }
# $path = buildPath $stopNode $res[1]