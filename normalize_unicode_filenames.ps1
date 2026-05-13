param(
	[Parameter(Position = 0)]
	[string]$Path = ".",

	[switch]$Recurse,

	[switch]$DryRun,

	[switch]$IncludeDirectories = $true,

	[switch]$IncludeFiles = $true
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-NormalizedName {
	param(
		[Parameter(Mandatory = $true)]
		[string]$Name,

		[System.Text.NormalizationForm]$Form = [System.Text.NormalizationForm]::FormC
	)

	return $Name.Normalize($Form)
}

function Test-NameChanged {
	param(
		[Parameter(Mandatory = $true)]
		[string]$OriginalName,

		[Parameter(Mandatory = $true)]
		[string]$NormalizedName
	)

	return -not [string]::Equals($OriginalName, $NormalizedName, [System.StringComparison]::Ordinal)
}

function Rename-ToNormalizedName {
	param(
		[Parameter(Mandatory = $true)]
		[System.IO.FileSystemInfo]$Item,

		[switch]$DryRunMode
	)

	$originalName = $Item.Name
	$normalizedName = Get-NormalizedName -Name $originalName

	if (-not (Test-NameChanged -OriginalName $originalName -NormalizedName $normalizedName)) {
		return $false
	}

	$parentPath = $Item.DirectoryName
	if (-not $parentPath) {
		$parentPath = Split-Path -LiteralPath $Item.FullName -Parent
	}

	$targetPath = Join-Path -Path $parentPath -ChildPath $normalizedName

	if ((Test-Path -LiteralPath $targetPath) -and ($targetPath -ne $Item.FullName)) {
		Write-Warning "Skipped: '$($Item.FullName)' -> '$targetPath' (target already exists)"
		return $false
	}

	if ($DryRunMode) {
		Write-Host "[DRY-RUN] $($Item.FullName) -> $targetPath"
		return $true
	}

	Rename-Item -LiteralPath $Item.FullName -NewName $normalizedName
	Write-Host "[RENAMED] $($Item.FullName) -> $targetPath"
	return $true
}

$resolvedPath = Resolve-Path -LiteralPath $Path
$rootPath = $resolvedPath.Path

$items = Get-ChildItem -LiteralPath $rootPath -Force -Recurse:$Recurse

$renameTargets = @()

if ($IncludeFiles) {
	$renameTargets += $items | Where-Object { -not $_.PSIsContainer }
}

if ($IncludeDirectories) {
	$renameTargets += $items |
		Where-Object { $_.PSIsContainer } |
		Sort-Object { $_.FullName.Length } -Descending
}

$changedCount = 0

foreach ($item in $renameTargets) {
	if (Rename-ToNormalizedName -Item $item -DryRunMode:$DryRun) {
		$changedCount++
	}
}

Write-Host ""
Write-Host "Completed. Renamed or planned: $changedCount item(s)."
Write-Host "Normalization form: FormC (NFC)."
