# Ensure the script stops on error
$ErrorActionPreference = "Stop"

# Install Git
Write-Host "Installing Git using winget..."
winget install --id Git.Git -e --source winget

# Install Python 3.11
Write-Host "Installing Python 3.11 using winget..."
$pythonPackage = winget search "Python 3.11" | Where-Object { $_.Id -match "^Python\.Python\.3\.11" } | Select-Object -First 1

if ($pythonPackage) {
    winget install --id $pythonPackage.Id -e --source winget
} else {
    Write-Error "Could not find Python 3.11 in winget."
}

# Set paths
$docsPath = [Environment]::GetFolderPath("MyDocuments")
$repoUrl = "https://github.com/basicallymaria/BSA"
$repoName = "BSA"
$repoPath = Join-Path $docsPath $repoName

# Clone the repository
Write-Host "Cloning the repository into $repoPath..."
git clone $repoUrl $repoPath

# Set up Python virtual environment
$venvPath = Join-Path $repoPath "venv"
Write-Host "Creating Python virtual environment in $venvPath..."
& "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe" -m venv $venvPath

# Activate the virtual environment and install requirements
$activateScript = Join-Path $venvPath "Scripts\Activate.ps1"
$requirementsFile = Join-Path $repoPath "requirements.txt"

Write-Host "Installing Python packages from requirements.txt..."
& powershell -ExecutionPolicy Bypass -NoProfile -Command "& '$activateScript'; pip install -r '$requirementsFile'"
