function invoke-pingsweep {
	param
		(
			[Parameter(Mandatory=$true)]$network,
			[Parameter(Mandatory=$true)]$start,
			[Parameter(Mandatory=$true)]$end
		)
	$validatenetwork = $network.split(".")
	if($validatenetwork.length -gt 2){
		$network = $validatenetwork[0] + "." + $validatenetwork[1] + "." + $validatenetwork[2]
	}
	$arr = @()
	while ($start -le $end){
		Write-Progress -Activity "Testing addresses $network from $start to $end" -status "Completed testing $start" -percentComplete ($start / $end * 100)
		$address = $network + "." + $start
		$result = New-Object System.Object
		$result | Add-Member -type NoteProperty -name Address -Value $address
		$test = test-connection -computername $address -quiet -count 1
		$result | Add-Member -type NoteProperty -name SuccessfulPing -Value $test
		$arr += $result
		$start++
	}
	return $arr
}
