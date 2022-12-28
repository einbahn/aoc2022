class Monkey {
    [int]$id
    [ulong[]]$startingItems
    [string]$operation
    [int]$test
    [int]$ifTrue
    [int]$ifFalse
    [int]$numInspected
    Monkey(
    [int]$id,
    [ulong[]]$startingItems,
    [string]$operation,
    [int]$test,
    [int]$ifTrue,
    [int]$ifFalse
    ) {
        $this.id = $id
        $this.startingItems = $startingItems
        $this.operation = $operation
        $this.test = $test
        $this.ifTrue = $ifTrue
        $this.ifFalse = $ifFalse
        $this.numInspected = 0
    }
}

$chunks = (get-content ./input/11test -raw ) -split '\n\n'

$monkeys = foreach ($c in $chunks) {
    foreach ($l in ($c -split "\n")) {
        if ($l -match 'Monkey (\d):') {
            $id = $matches[1]
        } elseif ($l -match 'Starting items:') {
            $si = $l -replace "Starting items: " -split "," | foreach {[int]($_)}
        } elseif ($l -imatch 'Operation: ') {
            $operation = ($l -replace "Operation: ").trim()
        } elseif ($l -imatch 'Test:') {
            $test = [int]($l -replace "Test: divisible by ")
        } elseif ($l -imatch 'If true: ') {
            $ifTrue = [int]($l -replace "If true: throw to monkey ")
        } elseif ($l -imatch 'If false: ') {
            $ifFalse = [int]($l -replace "If false: throw to monkey ")
        }
    }
    [Monkey]::new($id, $si, $operation, $test, $ifTrue, $ifFalse)
}

function parseOperation {
    param(
        [ulong]$inputNumber,
        [string]$instruction
    )
    $sp = $instruction -split "\s" 
    $operator = $sp[3]
    $operand = $sp[4]
    if ($operand -eq 'old') {
        $expr = "$inputNumber $operator $inputNumber"
        # #write-host "$expr"
        (invoke-expression "$expr")
    } else {
        $expr = "$inputNumber $operator $operand"
        # #write-host "$expr"
        (invoke-expression "$expr")
    }
}

function calculateMod ($remainder, $modulo) {
    $a = [math]::floor($remainder / $modulo)
    return ($remainder - $a * $modulo)
}

function reverseOp ($number, $operation, $mod) {
    $sp = $operation -split "\s"
    $operator = $sp[3]
    $operand = $sp[4]
    if ($operator -eq '+') {
        $expr = "$number - $operand"
    } elseif ($operator -eq '-') {
        $expr = "$number + $operand"
    } elseif ($operator -eq '*') {
        if ($operand -eq 'old') {
            return [math]::sqrt($number)
        } else {
            while (($number % $operand) -ne 0) {
                $number += $mod
            }
            $expr = "$number / $operand"
        }
    }
    invoke-expression $expr
}
# foreach ($round in (0..9999)) {
foreach ($round in (0..19)) {
    foreach ($m in $monkeys) {
        foreach ($i in $m.startingItems) {
           $worryLevel = parseOperation $i $m.operation
           $remainder = $worryLevel % $m.test
           if ($remainder -eq 0) {
                $mthrow = $monkeys | where {$_.id -eq $m.ifTrue}
           } else {
                $mthrow = $monkeys | where {$_.id -eq $m.ifFalse}
           }
        #    write-host "throwing item with worry level $worrylevel to monkey $($mthrow.id)"
        #    $mthrow.startingItems += $worryLevel
        #    write-host "throwing item with worry level $worrylevel to monkey $($mthrow.id)"
            $throwOpres = parseOperation $worryLevel $mthrow.operation
        #     write-host "after target monkey operation, $($mthrow.operation), item worry level becomes $throwopres"
        #     write-host "testing if $throwopres is divisible by $($mthrow.test)"
            $throwRemain = $throwOpRes % $mThrow.test
            $throwcongruent = $throwRemain + $mthrow.test
        #     write-host "remainder is $throwremain"
        #     write-host "smallest congruent number is $($throwremain + $mthrow.test)"
        #     write-host "worrylevel % mthrow.test = $($throwopres % $mthrow.test); congruent number % mthrowtest = $($throwcongruent % $mthrow.test)"
            $throwRes = reverseOp ($throwRemain + $mThrow.test) $mThrow.operation $mthrow.test
        #     write-host "the number to store is $throwres"
            
        #     write-host
            $mThrow.startingItems += $throwRes
            $m.startingItems = $m.startingItems[1..($m.startingItems.count)]
            $m.numInspected++
        }
    }
}

# $monkeyBusiness = 1
# $monkeys | Sort-Object -property numInspected -Descending | select -first 2 | foreach { $monkeyBusiness *= $_.numInspected }
# #write-host "mb = $monkeybusiness"

$monkeys | foreach {
    write-host "Monkey $($_.id) inspected items $($_.numInspected) times"
}
