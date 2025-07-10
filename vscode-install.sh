#!/bin/bash
#
# Visual Studio Code Installer Script
# Author: rokhanz
# License: MIT
# Version: 1.0.0

clear
sleep 2
# ASCII Banner Gradasi
echo -e "\e[90m$$$$$$$\   $$$$$$\  $$\   $$\ $$\   $$\  $$$$$$\  $$\   $$\ $$$$$$$$\\"
echo -e "\e[90m$$  __$$\ $$  __$$\ $$ | $$  |$$ |  $$ |$$  __$$\ $$$\  $$ |\____$$  |"
echo -e "\e[37m$$ |  $$ |$$ /  $$ |$$ |$$  / $$ |  $$ |$$ /  $$ |$$$$\ $$ |    $$  / "
echo -e "\e[37m$$$$$$$  |$$ |  $$ |$$$$$  /  $$$$$$$$ |$$$$$$$$ |$$ $$\$$ |   $$  /  "
echo -e "\e[97m$$  __$$< $$ |  $$ |$$  $$<   $$  __$$ |$$  __$$ |$$ \$$$$ |  $$  /   "
echo -e "\e[97m$$ |  $$ |$$ |  $$ |$$ |\$$\  $$ |  $$ |$$ |  $$ |$$ |\$$$ | $$  /    "
echo -e "\e[97m$$ |  $$ | $$$$$$  |$$ | \$$\ $$ |  $$ |$$ |  $$ |$$ | \$$ |$$$$$$$$\\"
echo -e "\e[0m\__|  \__| \______/ \__|  \__|\__|  \__|\__|  \__|\__|  \__|\________|"

set -e
sleep 2
# 🟢 Validasi apakah VS Code CLI sudah terpasang
if command -v code >/dev/null 2>&1; then
  echo "✅ Visual Studio Code CLI sudah terpasang."
else
  echo "🔹 Visual Studio Code belum terpasang. Memulai instalasi..."
  # Tambahkan repo Microsoft
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg

  sudo apt update
  sudo apt install -y code
fi

# 🟢 Validasi apakah desktop file ada untuk GUI
if [ -f "/usr/share/applications/code.desktop" ]; then
  echo "✅ Visual Studio Code GUI Desktop Integration sudah terpasang."
else
  echo "🔹 Visual Studio Code Desktop Integration belum ada. Memasang .deb resmi..."
  wget -O vscode-latest.deb "https://update.code.visualstudio.com/latest/linux-deb-x64/stable"
  sudo apt install -y ./vscode-latest.deb
  rm vscode-latest.deb
fi
sleep 1

# 🟢 Fungsi deteksi RAM dalam GB
detect_ram() {
  local mem_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
  echo $((mem_kb / 1024 / 1024))
}

# 🟢 Deteksi Spek VPS
echo "🔍 Mendeteksi spesifikasi VPS Anda..."

OS=$(lsb_release -d | cut -f2)
CPU=$(nproc)
RAM=$(detect_ram)
DISK=$(df -h / | awk '/\// {print $2}')

echo "🖥️  OS     : $OS"
echo "💻  vCPU   : $CPU"
echo "💾  RAM    : ${RAM} GB"
echo "📀  Disk   : $DISK"

# 🟢 Tampilkan Paket Rekomendasi
echo ""
echo "✨ Paket A (<2GB RAM):"
echo "   - ms-python.python            (Python Development)"
echo "   - dbaeumer.vscode-eslint      (JavaScript/Node Linting)"
echo "   - esbenp.prettier-vscode      (Code Formatter)"
echo "   - timonwong.shellcheck        (Shell Script Linter)"
echo "   - eamodio.gitlens             (Enhanced Git Integration)"
echo ""
echo "✨ Paket B (2–4GB RAM):"
echo "   + Semua Paket A"
echo "   - ms-azuretools.vscode-docker (Docker Support)"
echo "   - bierner.emojisense          (Emoji Autocomplete)"
echo "   - genieai.chatgpt-vscode      (ChatGPT Assistant)"
echo "   - ms-vscode-remote.remote-ssh (Remote SSH Development)"
echo "   - ms-vscode-remote.remote-ssh-edit (Remote SSH Config Helper)"
echo ""
echo "✨ Paket C (>4GB RAM):"
echo "   + Semua Paket B"
echo "   - blackboxapp.blackbox             (Blackbox AI Autocomplete)"
echo "   - formulahendry.auto-rename-tag    (HTML Auto Rename Tag)"
echo "   - formulahendry.auto-close-tag     (HTML Auto Close Tag)"
echo "   - christian-kohler.path-intellisense (Path Suggestions)"
echo "   - zainchen.json                    (JSON Tools)"
echo "   - xabikos.javascriptsnippets       (JavaScript Snippets)"
echo "   - ms-toolsai.jupyter               (Jupyter Notebook Support)"
echo "   - shd101wyy.markdown-preview-enhanced (Markdown Preview & Image)"
echo "   - streetsidesoftware.code-spell-checker (Spell Checker)"
echo "   - hediet.vscode-drawio             (Draw.io Diagram Editor)"
echo "   - bierner.markdown-mermaid         (Mermaid Diagram Support)"
echo ""

# 🟢 Rekomendasi Paket Berdasarkan RAM
if [ "$RAM" -lt 2 ]; then
  RECOMMENDED="A"
elif [ "$RAM" -lt 4 ]; then
  RECOMMENDED="B"
else
  RECOMMENDED="C"
fi

echo "✅ Anda disarankan untuk menginstall **Paket $RECOMMENDED**."
read -p "Apakah Anda setuju? (y/n): " AGREEMENT

if [[ "$AGREEMENT" =~ ^[Yy]$ ]]; then
  CHOSEN="$RECOMMENDED"
else
  read -p "Silakan pilih paket yang Anda inginkan (A/B/C): " CHOSEN
fi

# 🟢 Validasi input
if [[ ! "$CHOSEN" =~ ^[ABCabc]$ ]]; then
  echo "❌ Input tidak valid. Silakan jalankan ulang script."
  exit 1
fi

# 🟢 Warning jika RAM tidak sesuai
if [[ "$CHOSEN" == "C" && "$RAM" -lt 4 ]]; then
  echo "⚠️ Peringatan: RAM VPS Anda hanya ${RAM}GB. Paket C disarankan untuk >4GB RAM."
  read -p "Tetap lanjutkan instalasi Paket C? (y/n): " CONTINUE
  if [[ ! "$CONTINUE" =~ ^[Yy]$ ]]; then
    echo "❌ Instalasi dibatalkan."
    exit 1
  fi
fi

echo ""
echo "🚀 Memulai instalasi VS Code dan extensions..."

# 🟢 Install dependensi
sudo apt update
sudo apt install -y wget gpg curl

# 🟢 Install VS Code jika belum ada
if ! command -v code >/dev/null 2>&1; then
  echo "🔹 Menginstal Visual Studio Code..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg

  sudo apt update
  sudo apt install -y code
else
  echo "✅ Visual Studio Code sudah terpasang."
fi

# 🟢 Daftar extensions per paket
EXT_A=(
  "ms-python.python"
  "dbaeumer.vscode-eslint"
  "esbenp.prettier-vscode"
  "timonwong.shellcheck"
  "eamodio.gitlens"
)

EXT_B=(
  "ms-azuretools.vscode-docker"
  "bierner.emojisense"
  "genieai.chatgpt-vscode"
  "ms-vscode-remote.remote-ssh"
  "ms-vscode-remote.remote-ssh-edit"
)

EXT_C=(
  "blackboxapp.blackbox"
  "formulahendry.auto-rename-tag"
  "formulahendry.auto-close-tag"
  "christian-kohler.path-intellisense"
  "zainchen.json"
  "xabikos.javascriptsnippets"
  "ms-toolsai.jupyter"
  "shd101wyy.markdown-preview-enhanced"
  "streetsidesoftware.code-spell-checker"
  "hediet.vscode-drawio"
  "bierner.markdown-mermaid"
)

# 🟢 Gabungkan extensions sesuai paket
INSTALL_EXT=("${EXT_A[@]}")
if [[ "$CHOSEN" =~ [BbCc] ]]; then
  INSTALL_EXT+=("${EXT_B[@]}")
fi
if [[ "$CHOSEN" =~ [Cc] ]]; then
  INSTALL_EXT+=("${EXT_C[@]}")
fi

# 🟢 Install extensions satu per satu dengan keterangan
for ext in "${INSTALL_EXT[@]}"; do
  if code --list-extensions | grep -q "$ext"; then
    echo "✅ $ext sudah terpasang."
  else
    echo "🔹 Menginstal $ext ..."
    code --install-extension "$ext"
  fi
done

echo ""
echo "🎉 Instalasi selesai. Semua extensions berhasil dipasang."
echo "🚀 Silakan buka VS Code dan nikmati pengembangan yang lebih nyaman!"
