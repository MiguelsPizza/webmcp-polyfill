#!/bin/sh
# Usage: run.sh <none|polyfill> <test paths...>
set -u
mode=$1
shift
inject=""
if [ "$mode" = polyfill ]; then
  inject="--inject-script $GITHUB_WORKSPACE/dist/polyfill.js"
fi
cd "$GITHUB_WORKSPACE/.reference/wpt" || exit 1
python3 wpt --venv _venv_exp run --channel=stable --yes --test-types testharness $inject \
  --manifest MANIFEST.json --no-manifest-download \
  --metadata "$GITHUB_WORKSPACE/experiment/empty-metadata" \
  --log-mach=- --log-wptreport "$GITHUB_WORKSPACE/wpt-results/$mode.json" \
  --no-pause-after-test --processes 1 --retry-unexpected=0 \
  safari "$@"
echo "wpt exit $?"
