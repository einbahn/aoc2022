$d = get-content .\input\2

$items = @{
    'a' = 1 # rock
    'b' = 2 # paper
    'c' = 3 # scissors
}

$items1 = @{
    'x' = 1 #'rock'
    'y' = 2 #'paper'
    'z' = 3 #'scissors'
}

$outcomes = @{
    'x' = 'lose'
    'y' = 'draw'
    'z' = 'win'
}

$values = @{
    'lose' = 0
    'draw' = 3
    'win' = 6
}

$comp1 = @{
    'ax' = 'draw' # rock rock
    'ay' = 'lose' # rock paper
    'az' = 'win' # rock scissors
    'bx' = 'win' # paper rock
    'by' = 'draw' # paper paper
    'bz' = 'lose' # paper scissors
    'cx' = 'lose' # scissors rock
    'cy' = 'win' #scissors paper
    'cz' = 'draw' #scissors scissors
}

$comp = @{
    'ax' = 'scissors' # lose to rock 
    'ay' = 'rock' #rock draw
    'az' = 'paper' #rock win
    'bx' = 'rock' #lose to paper
    'by' = 'paper' #paper draw
    'bz' = 'scissors' #win against paper
    'cx' = 'paper' # lose to scissors
    'cy' = 'scissors' #scissors draw
    'cz' = 'rock' #win against scissors
}

$values1 = @{
    'rock' = 1
    'paper' = 2
    'scissors' = 3
}

# part 1
$sum = 0
foreach ($i in $d) {
    $line = $i -replace "\s", ""
    $y = $line[1].toString()
    $sum += $items1[$y] + $values[$comp1[$line]]
}

Write-Output "The answer to part 1 is $sum"

# part 2
$sum = 0
foreach ($i in $d) {
   $line = $i -replace "\s", ""
   $sum+=$values[$outcomes[$line[1].tostring()]] + $values1[$comp[$line]]
}
$sum

Write-Output "The answer to part 2 is $sum"