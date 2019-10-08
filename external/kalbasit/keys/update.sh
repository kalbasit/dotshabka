#! /usr/bin/env bash

set -euo pipefail

readonly here="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
readonly shabka_path="/run/current-system/shabka"

echo "{\"url\":\"https://github.com/kalbasit.keys\",\"sha256\":\"$(nix-prefetch-url https://github.com/kalbasit.keys)\"}" > "${here}/version.json"
