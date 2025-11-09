if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
  Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile "$env:USERPROFILE\dotnet-install.ps1"
  & "$env:USERPROFILE\dotnet-install.ps1" -InstallDir "$env:ProgramFiles\dotnet" -Channel 8.0
}
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) {
  if (Get-Command choco -ErrorAction SilentlyContinue) {
    choco install neovim -y
  } else {
    winget install Neovim.Neovim -e
  }
}
cd $env:USERPROFILE
if (-not (Test-Path "dotfiles")) {
  git clone https://github.com/KitcatCatlord/dotfiles.git dotfiles
}
$ConfigPath = "$env:LOCALAPPDATA\nvim"
if (Test-Path $ConfigPath) {
  Remove-Item $ConfigPath -Recurse -Force
}
New-Item -ItemType SymbolicLink -Path $ConfigPath -Target "$env:USERPROFILE\dotfiles\.config\nvim" -Force
nvim --headless "+Lazy! sync" +qa