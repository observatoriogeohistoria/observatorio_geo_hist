#!/usr/bin/env bash
# Gera os ícones e a imagem de compartilhamento de web/ a partir das páginas
# desta pasta, "fotografadas" pelo Google Chrome em modo headless.
#
# Uso:  tool/web_icons/gerar.sh [pasta_de_saida]
# Sem argumento, grava direto em web/. Só precisa rodar de novo se a marca
# (assets/images/logo.svg) mudar; lembre de manter os SVG destas páginas iguais.
set -euo pipefail

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
DIR="$(cd "$(dirname "$0")" && pwd)"
RAIZ="$(cd "$DIR/../.." && pwd)"
SAIDA="${1:-$RAIZ/web}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$SAIDA/icons"

# foto <página?parâmetros> <largura> <altura> <arquivo> [transparente]
foto() {
  local pagina="$1" largura="$2" altura="$3" arquivo="$4" fundo="${5:-}"
  local extra=()
  if [[ "$fundo" == "transparente" ]]; then
    extra+=(--default-background-color=00000000)
  fi
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars \
    --force-device-scale-factor=1 --allow-file-access-from-files \
    --virtual-time-budget=3000 \
    --window-size="$largura,$altura" ${extra[@]+"${extra[@]}"} \
    --screenshot="$arquivo" "file://$DIR/$pagina" >/dev/null 2>&1
  local l a
  l=$(sips -g pixelWidth "$arquivo" | awk '/pixelWidth/ {print $2}')
  a=$(sips -g pixelHeight "$arquivo" | awk '/pixelHeight/ {print $2}')
  if [[ "$l" != "$largura" || "$a" != "$altura" ]]; then
    echo "Tamanho inesperado em $arquivo: ${l}x${a} (esperado ${largura}x${altura})" >&2
    exit 1
  fi
  echo "ok  $arquivo (${l}x${a})"
}

# Ícones pequenos são renderizados em 512 e reduzidos com o sips, porque o
# Chrome headless não abre janelas menores que algumas centenas de pixels.
reduz() {
  local origem="$1" tamanho="$2" arquivo="$3"
  cp "$origem" "$arquivo"
  sips -z "$tamanho" "$tamanho" "$arquivo" >/dev/null
  echo "ok  $arquivo (${tamanho}x${tamanho})"
}

foto "icon.html" 512 512 "$SAIDA/icons/Icon-512.png" transparente
reduz "$SAIDA/icons/Icon-512.png" 192 "$SAIDA/icons/Icon-192.png"
reduz "$SAIDA/icons/Icon-512.png" 32 "$SAIDA/favicon.png"

foto "maskable.html" 512 512 "$SAIDA/icons/Icon-maskable-512.png"
reduz "$SAIDA/icons/Icon-maskable-512.png" 192 "$SAIDA/icons/Icon-maskable-192.png"

foto "icon.html?fundo=branco" 512 512 "$TMP/apple-512.png"
reduz "$TMP/apple-512.png" 180 "$SAIDA/icons/apple-touch-icon.png"

foto "og.html" 1200 630 "$SAIDA/og-image.png"

# Ícone da aba em vetor: a marca sem largura/altura fixas.
sed -e 's/ width="34" height="34"//' "$RAIZ/assets/images/logo.svg" > "$SAIDA/favicon.svg"
echo "ok  $SAIDA/favicon.svg"
