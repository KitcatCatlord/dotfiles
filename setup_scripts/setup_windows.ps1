if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { choco install git -y }
if (-not (Get-Command nvim -ErrorAction SilentlyContinue)) { choco install neovim -y }
if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) { choco install dotnet-8.0-sdk -y }
if (-not (Get-Command alacritty -ErrorAction SilentlyContinue)) { choco install alacritty -y }
if (-not (Get-Command tmux -ErrorAction SilentlyContinue)) { choco install tmux -y }

cd $env:USERPROFILE
if (-not (Test-Path "dotfiles")) { git clone https://github.com/KitcatCatlord/dotfiles.git dotfiles }
else { cd dotfiles; git pull; cd .. }

$nvimConfig = "$env:LOCALAPPDATA\nvim"
$alacrittyConfig = "$env:APPDATA\alacritty"
$tmuxConfig = "$env:USERPROFILE"

if (Test-Path $nvimConfig) { Remove-Item $nvimConfig -Recurse -Force }
if (Test-Path $alacrittyConfig) { Remove-Item $alacrittyConfig -Recurse -Force }

New-Item -ItemType Directory -Path $nvimConfig | Out-Null
New-Item -ItemType Directory -Path $alacrittyConfig | Out-Null

Copy-Item "$env:USERPROFILE\dotfiles\nvim\*" -Destination $nvimConfig -Recurse -Force
Copy-Item "$env:USERPROFILE\dotfiles\alacritty\*" -Destination $alacrittyConfig -Recurse -Force
Copy-Item "$env:USERPROFILE\dotfiles\tmux.conf" -Destination "$tmuxConfig\.tmux.conf" -Force

nvim --headless "+Lazy! sync" +qa