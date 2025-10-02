#!/usr/bin/env bash

# Lightweight proxy script: Set/unset environment variables and Git proxy
# Usage:
#   source proxy.sh set [URL]   # Set proxy (recommend using source to affect current shell)
#   source proxy.sh unset       # Unset proxy (recommend using source)
#   bash proxy.sh show          # Show current settings
#
# Note: If not executed via `source`, environment variables only affect the current process.

DEFAULT_PROXY_URL="${PROXY_URL:-http://127.0.0.1:1080}"
DEFAULT_NO_PROXY="${NO_PROXY:-localhost,127.0.0.1,::1,*.local}"

usage() {
  cat <<EOF
Usage:
  source ./proxy.sh set [URL]   Set proxy, default: ${DEFAULT_PROXY_URL}
  source ./proxy.sh unset       Unset proxy
  bash   ./proxy.sh show        Show current environment and Git proxy

Examples:
  source ./proxy.sh set # Use default http://127.0.0.1:1080
  source ./proxy.sh set http://127.0.0.1:7890
  source ./proxy.sh set socks5://127.0.0.1:1080
EOF
}

normalize_url() {
  local url="$1"
  if [[ -z "$url" ]]; then
    echo "${DEFAULT_PROXY_URL}"
    return 0
  fi
  # If no scheme, default to http://
  if [[ "$url" != *"://"* ]]; then
    echo "http://${url}"
  else
    echo "$url"
  fi
}

set_proxy() {
  local in="$1"
  local url
  url="$(normalize_url "$in")"

  # Environment variables
  export http_proxy="$url"
  export https_proxy="$url"
  export HTTP_PROXY="$url"
  export HTTPS_PROXY="$url"
  export all_proxy="$url"
  export ALL_PROXY="$url"
  export no_proxy="${DEFAULT_NO_PROXY}"
  export NO_PROXY="${DEFAULT_NO_PROXY}"

  # Git proxy (global)
  git config --global http.proxy "$url" >/dev/null 2>&1 || true
  git config --global https.proxy "$url" >/dev/null 2>&1 || true

  echo "Proxy set to: $url"
  echo "NO_PROXY: ${NO_PROXY}"
  echo "Tip: To apply environment variables to current shell, use: source ./proxy.sh set"
}

unset_proxy() {
  # Unset environment variables
  unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY all_proxy ALL_PROXY no_proxy NO_PROXY

  echo "Proxy unset"
  echo "Tip: To apply environment variables to current shell, use: source ./proxy.sh unset"
}

show_status() {
  echo "Environment variables:"
  printf "  http_proxy=%s\n"   "${http_proxy-}"
  printf "  https_proxy=%s\n"  "${https_proxy-}"
  printf "  HTTP_PROXY=%s\n"   "${HTTP_PROXY-}"
  printf "  HTTPS_PROXY=%s\n"  "${HTTPS_PROXY-}"
  printf "  all_proxy=%s\n"    "${all_proxy-}"
  printf "  ALL_PROXY=%s\n"    "${ALL_PROXY-}"
  printf "  no_proxy=%s\n"     "${no_proxy-}"
  printf "  NO_PROXY=%s\n"     "${NO_PROXY-}"
}

cmd="$1"
case "$cmd" in
  set)
    shift || true
    set_proxy "$1"
    ;;
  unset)
    unset_proxy
    ;;
  show)
    show_status
    ;;
  ""|help|-h|--help)
    usage
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    usage
    exit 1
    ;;
esac
