#!/bin/bash
PROJECT="$(cd -- "$(dirname -- "$0")" && pwd -P)"
exec /bin/bash "$PROJECT/scripts/start_macos.sh" "$@"
