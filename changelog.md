# Changelog - VS Code Installer Script
Author: rokhanz

## v1.0.0 - 2025-07-10
✅ Fitur utama:
- Deteksi spek VPS (OS, CPU, RAM, Disk)
- Output emoji dan rekomendasi paket (A/B/C)
- Validasi kapasitas RAM + warning jika paket melebihi
- Konfirmasi user interaktif
- Install Visual Studio Code jika belum terpasang
- Install extensions sesuai paket:
  - Paket A (<2GB): Minimal development (Python, Node, Shell, Git)
  - Paket B (2–4GB): + Docker, Emoji, Remote SSH, ChatGPT
  - Paket C (>4GB): + Blackbox AI, Formatter tambahan, Snippets, Docs tools, Draw.io, Mermaid
- Output extension + keterangan fungsinya
- Tidak menyertakan GitHub Copilot
- Clean bash script dengan error handling
