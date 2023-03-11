param(
	[string] $repo,
	[string] $pattern
	)

$defaultPattern = "(story|feature|bug)/([0-9]{3,})/?([0-9]{3,})?"
if(!$repo){
	Write-Host "Please enter the path of the repo in which to place the hook:"
	$repo = Read-Host
	if(!$repo){
		Write-Host "Installing the hook was cancelled."
		exit 0
	}
}
if(!$(Test-Path -Path $repo -PathType container)){
	Write-Error "$repo is not a directory"
	exit 1;
}
if(!$(Test-Path -Path "$repo/.git" -PathType container)){
	Write-Error "$repo does not seem to be a git repository"
	exit 1;
}
if(!$pattern){
	Write-Host "Please enter the branch name pattern to use.`nPress enter to use the default, which is $defaultPattern.`nSee https://www.gnu.org/software/grep/manual/html_node/Regular-Expressions.html for the pattern syntax to use."
	$pattern = Read-Host "Pattern: ([enter] for default) "
	if(!$pattern){
		$pattern = $defaultPattern
	}
}
$hookContent = Get-Content -Path ./commit-msg
$hookContent = $hookContent.replace('BRANCH_NAME_PATTERN=""', "BRANCH_NAME_PATTERN=`"$pattern`"")
Set-Content -Path "$repo/.git/hooks/commit-msg" -Value $hookContent
Push-Location
cd $repo
git config core.commentchar "%"
Pop-Location
Write-Host "commit hook successfully installed in repo $repo"