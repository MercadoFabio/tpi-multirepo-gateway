#!/usr/bin/env sh

set -eu

require_text() {
  file="$1"
  expected="$2"

  if ! grep -Fq -- "$expected" "$file"; then
    echo "Expected '$expected' in $file" >&2
    exit 1
  fi
}

config="nginx.conf"
compose="docker-compose.yml"

require_text "$config" "location ^~ /api/v1/"
require_text "$config" "location = /usuarios"
require_text "$config" "location ^~ /usuarios/"
require_text "$config" "location ^~ /productos/"
require_text "$config" "proxy_read_timeout 30s"
require_text "$config" "limit_req zone=login"
require_text "$config" "location = /api/v1/auth/login"
require_text "$config" "add_header Cache-Control \"no-store\" always"
require_text "$config" "proxy_pass http://shell-ssr:4000"
require_text "$config" "proxy_pass http://usuarios-ssr:4000"
require_text "$config" "proxy_pass http://productos-ssr:4000"
require_text "$compose" "target: runtime"
require_text "$compose" "- \"4000\""
require_text "$compose" "users-db:"
require_text "$compose" "products-db:"
require_text "$compose" "session-store:"
require_text "$compose" "REDIS_URL: redis://session-store:6379"
require_text "$compose" "      session-store:"
require_text "$compose" "condition: service_healthy"
require_text "$compose" "USERS_DB_URL: jdbc:postgresql://users-db:5432/tpi_usuarios"
require_text "$compose" "PRODUCTS_DB_URL: jdbc:postgresql://products-db:5432/tpi_productos"
if grep -Fqi 'cors' "$config" "$compose"; then
  echo "CORS must not be configured at the gateway" >&2
  exit 1
fi
