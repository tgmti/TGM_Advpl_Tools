cls
$aActPath = $MYINVOCATION.InvocationName.Split("\")
$cActPath = [System.String]::Join("\", $aActPath[0..($aActPath.Length-2)])

. $cActPath\config.ps1

$thisVar = configVars
$thisVar
$nTimeStop