#!/usr/bin/env bash
# Starts a local Apache on a copy of the generated build and checks what web/.htaccess does.
#
#   tool/seo/check_htaccess.sh [prod|dev] [build_dir]
#
# Run `flutter build web` and the generator first. `dev` also appends the password block the
# dev workflow adds. This Apache has no TLS, so the test copy of .htaccess reads "is it https?"
# from X-Forwarded-Proto instead of %{HTTPS}; everything else is the versioned file as is.

mode="${1:-prod}"
build="${2:-build/web}"
port="${HTACCESS_PORT:-8089}"
htaccess="${HTACCESS_FILE:-web/.htaccess}"
modules=/usr/libexec/apache2

[ -f "$build/index.html" ] || { echo "Não achei $build/index.html: rode o build e o gerador antes."; exit 2; }
[ -f "$htaccess" ] || { echo "Rode da raiz do repositório."; exit 2; }

work="$(mktemp -d)"
cleanup() {
  [ -f "$work/httpd.pid" ] && kill "$(cat "$work/httpd.pid")" 2>/dev/null
  rm -rf "$work"
}
trap cleanup EXIT

mkdir "$work/www"
cp -R "$build"/. "$work/www/"
cp "$htaccess" "$work/www/.htaccess"
sed -i '' 's/%{HTTPS} !=on/%{HTTP:X-Forwarded-Proto} !https/' "$work/www/.htaccess"

if [ "$mode" = dev ]; then
  htpasswd -bc "$work/htpasswd" tester secret >/dev/null 2>&1
  printf '\nAuthType Basic\nAuthName "dev"\nAuthUserFile "%s"\nRequire valid-user\n' "$work/htpasswd" >> "$work/www/.htaccess"
fi

cat > "$work/httpd.conf" <<CONF
ServerRoot "/usr"
ServerName localhost
Listen 127.0.0.1:$port
PidFile "$work/httpd.pid"
ErrorLog "$work/error.log"
LoadModule mpm_prefork_module $modules/mod_mpm_prefork.so
LoadModule authn_core_module $modules/mod_authn_core.so
LoadModule authn_file_module $modules/mod_authn_file.so
LoadModule authz_core_module $modules/mod_authz_core.so
LoadModule authz_user_module $modules/mod_authz_user.so
LoadModule auth_basic_module $modules/mod_auth_basic.so
LoadModule filter_module $modules/mod_filter.so
LoadModule deflate_module $modules/mod_deflate.so
LoadModule mime_module $modules/mod_mime.so
LoadModule headers_module $modules/mod_headers.so
LoadModule unixd_module $modules/mod_unixd.so
LoadModule autoindex_module $modules/mod_autoindex.so
LoadModule dir_module $modules/mod_dir.so
LoadModule alias_module $modules/mod_alias.so
LoadModule rewrite_module $modules/mod_rewrite.so
TypesConfig /etc/apache2/mime.types
DocumentRoot "$work/www"
<Directory "$work/www">
  AllowOverride All
  Require all granted
</Directory>
CONF

httpd -f "$work/httpd.conf" || { cat "$work/error.log"; exit 2; }
sleep 1

base="http://localhost:$port"
failures=0
https=(-H "X-Forwarded-Proto: https")

# check <description> <expected status> <expected text in headers+body, or ""> <curl args...>
check() {
  local what="$1" status="$2" text="$3"
  shift 3
  local out code
  out="$(curl -s -i --max-time 10 "$@")"
  code="$(printf '%s' "${out%%$'\n'*}" | awk '{print $2}')"
  if [ "$code" != "$status" ] || { [ -n "$text" ] && ! grep -qiF -- "$text" <<<"$out"; }; then
    echo "FALHOU  $what: esperava $status${text:+ com \"$text\"}, veio $code"
    failures=$((failures + 1))
  else
    echo "ok      $what"
  fi
}

# check_absent <description> <text that must not appear> <curl args...>
check_absent() {
  local what="$1" text="$2"
  shift 2
  local out
  out="$(curl -s -i --max-time 10 "$@")"
  if grep -qiF -- "$text" <<<"$out"; then
    echo "FALHOU  $what: apareceu \"$text\""
    failures=$((failures + 1))
  else
    echo "ok      $what"
  fi
}

auth=()
[ "$mode" = dev ] && auth=(-u tester:secret)

# A category with pages after the first has both x.html and the folder x/.
sample=""
for file in "$work"/www/publicacoes/*/*.html; do
  [ -e "$file" ] || continue
  if [ -d "${file%.html}" ]; then sample="${file#"$work/www"}"; sample="${sample%.html}"; break; fi
done

if [ "$mode" = dev ]; then
  check "sem login a página pede senha" 401 "" "${https[@]}" "$base/contato"
  check "sem login o main.dart.js pede senha" 401 "" "${https[@]}" "$base/main.dart.js"
  check "senha errada" 401 "" "${https[@]}" -u tester:wrong "$base/contato"
fi

check "http vai para https em um salto" 301 "Location: https://localhost:$port/contato" "${auth[@]}" "$base/contato"
check "www vai para o endereço sem www em um salto" 301 "Location: https://localhost:$port/contato" "${auth[@]}" "${https[@]}" -H "Host: www.localhost:$port" "$base/contato"
check "/contato é servido por contato.html" 200 '/contato" />' "${auth[@]}" "${https[@]}" "$base/contato"
check "/contato/ redireciona para /contato" 301 "Location: http://localhost:$port/contato" "${auth[@]}" "${https[@]}" "$base/contato/"
check "/contato?x=1 mantém a consulta" 200 "" "${auth[@]}" "${https[@]}" "$base/contato?x=1"
check "a home é a página gerada" 200 'id="seo-content"' "${auth[@]}" "${https[@]}" "$base/"
check "rota de uma página de documento" 200 "<h1>" "${auth[@]}" "${https[@]}" "$base/biblioteca/historia"
if [ -n "$sample" ]; then
  # Small categories have no second page; fake one so the folder + file case is really served.
  if [ ! -f "$work/www$sample/pagina/2.html" ]; then
    mkdir -p "$work/www$sample/pagina"
    echo '<h1>pagina-teste</h1>' > "$work/www$sample/pagina/2.html"
  fi
  check "$sample (arquivo e pasta com o mesmo nome)" 200 "<h1>" "${auth[@]}" "${https[@]}" "$base$sample"
  check "$sample/pagina/2 é servida" 200 "<h1>" "${auth[@]}" "${https[@]}" "$base$sample/pagina/2"
else
  echo "aviso   nenhuma categoria com mais de uma página: o caso arquivo + pasta não foi testado"
fi
check "rota sem arquivo cai no index.html do app" 200 'id="carregamento"' "${auth[@]}" "${https[@]}" "$base/rota/que/nao/existe"
check "/assets não lista a pasta" 403 "" "${auth[@]}" "${https[@]}" "$base/assets"
check_absent "/assets não mostra listagem" "Index of" "${auth[@]}" "${https[@]}" "$base/assets"
check "/assets/ vai para /assets" 301 "Location: http://localhost:$port/assets" "${auth[@]}" "${https[@]}" "$base/assets/"
check "arquivos ocultos dão 404" 404 "" "${auth[@]}" "${https[@]}" "$base/.git/config"
check "Cache-Control no-cache nas páginas" 200 "Cache-Control: no-cache" "${auth[@]}" "${https[@]}" "$base/contato"
check "o main.dart.js é servido como arquivo" 206 "" "${auth[@]}" "${https[@]}" -r 0-10 "$base/main.dart.js"

if [ "$mode" = prod ] && [ -f "$work/www/sitemap.xml" ]; then
  check "sitemap.xml em XML" 200 "Content-Type: application/xml" "${https[@]}" "$base/sitemap.xml"
fi

# SERVE_SECONDS=300 keeps the server up for a browser, which sends no X-Forwarded-Proto: the
# https redirect is switched off so http://localhost works.
if [ -n "${SERVE_SECONDS:-}" ]; then
  sed -i '' 's/%{HTTP:X-Forwarded-Proto} !https/%{HTTP_HOST} ^$/' "$work/www/.htaccess"
  echo "Servindo $base por ${SERVE_SECONDS}s."
  sleep "$SERVE_SECONDS"
fi

echo
if [ "$failures" -gt 0 ]; then echo "$failures verificação(ões) falharam."; exit 1; fi
echo "Tudo certo."
