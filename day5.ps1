$crates = get-content .\input\5crates
$instructions = get-content .\input\5
$stacks = new-object system.collections.arraylist

foreach ($c in $crates) {
    $s = new-object System.Collections.Stack
    $chararr = $c.ToCharArray()
    foreach ($i in $chararr[$chararr.length..0]) {
        $s.Push($i)
    }
    $stacks.Add($s) | out-null
}

foreach ($i in $instructions) {
    $split = $i -split "\s" 
    $numberToMove = $split[1]
    $source = $split[3]
    $destination = $split[5]
    $sourceStack = $stacks[$source - 1]

    #part1
    # 0..($numberToMove - 1) | Foreach-Object {
    #     $stacks[$destination-1].push($stacks[$source-1].pop())
    # }
    
    #part2
    $itemsToMove = @($sourceStack | Select-Object -first $numberToMove)
    [array]::Reverse($itemsToMove)
    0..($numberToMove - 1) | Foreach-Object {
        $stacks[$destination - 1].push($itemsToMove[$_])
        $sourceStack.pop() | out-null
    }
}

$outputString = new-object System.Text.StringBuilder
foreach ($s in $stacks) {
    $outputString.append($s.pop()) | out-null
}

$out = $outputString.ToString() 
Write-host $out