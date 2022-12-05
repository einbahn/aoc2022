$ErrorActionPreference = 'Stop'
$p = @{}
97..122 | %{
    $p[[char]$_] = $_ - 96}
65..90 | % { 
    $p[[char]$_] = $_ - 38 
}

$total = 0
foreach ($line in $inputData) {
    $length = $line.length / 2 
    $aset = @{}
    $bset = @{}
    $line[0..($length-1)] | foreach { $aset[$_] = $null }
    $line[$length..$line.length] | foreach { $bset[$_] = $null}
    $c = [char]($aset.Keys | where {$bset.Keys -ccontains $_})
    $priority = $p[$c]
    $total += $priority
}

Write-Host "The answer to part 1 is $total"

# part 2
$inputData = get-content .\input\3
$total = 0
for ($i = 0; $i -lt $inputData.length-1; $i+=3) {
    $tempi = $i
    $seta = @{}
    $setb = @{}
    $setc = @{}
    $inputData[$tempi].ToCharArray() | foreach { $seta[$_] = $null}
    $inputData[++$tempi].ToCharArray() | foreach { $setb[$_] = $null}
    $inputData[++$tempi].ToCharArray() | foreach { $setc[$_] = $null}
    $c = $seta.Keys | where {$setb.keys -ccontains $_} | where {$setc.Keys -ccontains $_}
    $total += $p[$c]
}

Write-Host "The answer to part 2 is $total"