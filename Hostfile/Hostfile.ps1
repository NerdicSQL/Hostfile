# Function to add all Docker SQL Server images to the hosts file.
# Some functionality taken from https://gist.github.com/markembling/173887
# Rewritten and expanded on the concept - but Mark's code was the basis, really.
function Docker-SQLToHostfile{

	try {
	if ($args[0] -NotIn ("add","remove")) {
		throw "Argument must be'add' or 'remove'"
	}

	if ($args.Count -gt 1) {
		throw "Only one argument can be used!"
	}

$hostfilename = "c:\windows\system32\drivers\etc\hosts"

function hostfile-add([string]$containerip,[string]$containername) {
	hostfile-remove $containername
	$containerip + "`t" + $containername | Out-File -encoding ASCII -append $hostfilename
}

function hostfile-remove([string]$containername) {
	$hostfile = Get-Content $hostfilename
	$newfile = @()
	
	foreach ($line in $hostfile) {
		if ($line.Substring(0,1) -eq "#") {

			$newfile += $line
			}
		else {
			$line = ($line).trim()
			$split = [regex]::Split($line, "\s+")

			if ($split[1] -ne $containername) {
					$newfile += $line
			}}

	
	# Write file
	Clear-Content $hostfilename
	foreach ($line in $newfile) {
		$line | Out-File -encoding ASCII -append $hostfilename
	}
}}



$images = docker images --format "{{.Repository}}"
$sqlimages = $images -like "*sql*"

$sqlcontainers = docker ps -a -f ancestor=$sqlimages --format "{{.ID}}"

$namewithip = docker inspect --format "{{.Name}}`t{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $sqlcontainers

foreach ($line in $namewithip){
	$clean = $line.remove(0,1)
	$containername,$containerip = $clean.split("`t")
	
	if ($args -eq "add") {
		hostfile-add $containerip $containername
	}
	else {
		hostfile-remove $containername
	}
	}}

	catch{
		Write-host $error[0]
		Write-Host "`nUsage: `nDocker-SQLToHostfile remove `nDocker-SQLToHostfile add"
	}}
