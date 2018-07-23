function Add-DockerSQLToHostfile{
		

function hostfile-add([string]$containerip,[string]$containername) {
	hostfile-remove $containername
	$containerip + "`t" + $containername | Out-File -encoding ASCII -append "C:\users\johan\hosts"
}

function hostfile-remove([string]$containername) {
	$hostfile = Get-Content "C:\users\johan\hosts"
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
	Clear-Content "C:\users\johan\hosts"
	foreach ($line in $newfile) {
		$line | Out-File -encoding ASCII -append "C:\users\johan\hosts"
	}
}}



$images = docker images --format "{{.Repository}}"
$sqlimages = $images -like "*sql*"

$sqlcontainers = docker ps -a -f ancestor=$sqlimages --format "{{.ID}}"

$namewithip = docker inspect --format "{{.Name}}`t{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $sqlcontainers

foreach ($line in $namewithip){
	$clean = $line.remove(0,1)
	$containername,$containerip = $clean.split("`t")
	
	hostfile-add $containerip $containername
	}}


function remove-DockerSQLToHostfile{
	


function hostfile-remove([string]$containername) {
	$hostfile = Get-Content "C:\users\johan\hosts"
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
	Clear-Content "C:\users\johan\hosts"
	foreach ($line in $newfile) {
		$line | Out-File -encoding ASCII -append "C:\users\johan\hosts"
	}
}}



$images = docker images --format "{{.Repository}}"
$sqlimages = $images -like "*sql*"

$sqlcontainers = docker ps -a -f ancestor=$sqlimages --format "{{.ID}}"

$namewithip = docker inspect --format "{{.Name}}`t{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" $sqlcontainers

foreach ($line in $namewithip){
	$clean = $line.remove(0,1)
	$containername,$containerip = $clean.split("`t")
	
	hostfile-remove $containername
	}}

	add-DockerSQLToHostfile