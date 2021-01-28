#!/bin/sh
set -e

export WAIT_FOR_JOB="build-job-${JOB_ID}"
$(dirname $0)/deploy.sh
