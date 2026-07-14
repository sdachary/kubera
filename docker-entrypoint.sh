#!/bin/sh
set -e

echo "==> Preparing database..."
bundle exec rails db:prepare 2>&1

echo "==> Starting Puma..."
exec "$@"
