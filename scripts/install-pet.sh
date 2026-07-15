#!/usr/bin/env bash
set -euo pipefail

RAW_BASE="${CODEX_PET_RAW_BASE:-https://raw.githubusercontent.com/Earmo/codex-pet-acgn/main}"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

usage() {
  cat <<'EOF'
用法:
  curl -fsSL https://raw.githubusercontent.com/Earmo/codex-pet-acgn/main/scripts/install-pet.sh | bash -s -- <pet-id>

选项:
  --list                 列出可用宠物
  --codex-home <path>    指定 Codex 主目录
  --help                 显示帮助

环境变量:
  CODEX_HOME             默认 ~/.codex
  CODEX_PET_RAW_BASE     覆盖 GitHub Raw 根地址
EOF
}

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "缺少命令: $1" >&2
    exit 1
  fi
}

list_pets() {
  need_command curl
  curl -fsSL --retry 2 "$RAW_BASE/pets.json"
}

download() {
  curl -fsSL --retry 2 "$1" -o "$2"
}

PET_ID=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --help|-h)
      usage
      exit 0
      ;;
    --list)
      list_pets
      exit 0
      ;;
    --codex-home)
      if [ "$#" -lt 2 ]; then
        echo "--codex-home 需要一个路径" >&2
        exit 1
      fi
      CODEX_HOME="$2"
      shift 2
      ;;
    --*)
      echo "未知选项: $1" >&2
      usage
      exit 1
      ;;
    *)
      if [ -n "$PET_ID" ]; then
        echo "只能指定一个宠物 ID" >&2
        exit 1
      fi
      PET_ID="$1"
      shift
      ;;
  esac
done

if [ -z "$PET_ID" ]; then
  usage
  exit 1
fi

if ! printf '%s' "$PET_ID" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "无效的宠物 ID: $PET_ID" >&2
  exit 1
fi

need_command curl
need_command mktemp

if command -v sha256sum >/dev/null 2>&1; then
  HASH_TOOL="sha256sum"
elif command -v shasum >/dev/null 2>&1; then
  HASH_TOOL="shasum"
else
  echo "需要 sha256sum 或 shasum 来校验下载文件" >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

for file in pet.json spritesheet.webp checksums.sha256; do
  download "$RAW_BASE/pets/$PET_ID/$file" "$TMP_DIR/$file"
done

if [ "$HASH_TOOL" = "sha256sum" ]; then
  (
    cd "$TMP_DIR"
    sha256sum -c checksums.sha256
  )
else
  (
    cd "$TMP_DIR"
    shasum -a 256 -c checksums.sha256
  )
fi

TARGET_DIR="$CODEX_HOME/pets/$PET_ID"
mkdir -p "$TARGET_DIR"
cp "$TMP_DIR/pet.json" "$TARGET_DIR/pet.json"
cp "$TMP_DIR/spritesheet.webp" "$TARGET_DIR/spritesheet.webp"

echo "已安装 $PET_ID 到 $TARGET_DIR"
