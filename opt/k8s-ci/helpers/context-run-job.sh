#!/bin/sh

set -e

if [ -n "$CONTEXT_LIST" ]; then
  if [ "$CONTEXT" = "*" ] || [ -z "$CONTEXT" ]; then
    CONTEXT=$CONTEXT_LIST
  fi
fi

runJob() {
  job="{}"
  job=$(echo $job | jq -rc --arg a "$JOB_TYPE_NAME-job-$JOB_ID" '.id = $a')
  job=$(echo $job | jq -rc --arg a $JOB_ID '.contextJobID = $a')
  job=$(echo $job | jq -rc --arg a "$JOB_TYPE_NAME" '.type = $a')
  job=$(echo $job | jq -rc --arg a "$CONTEXT" '.context = $a')
  if result=$(/opt/k8s-ci/jobs/${JOB_TYPE}.sh 2>&1); then
    job=$(echo $job | jq -rc --arg a "$result" '.message = $a')
    job=$(echo $job | jq -rc --arg a "success" '.status = $a')
    jobs=$(echo $jobs | jq -r ". |= .+ [$job]")
  else
    job=$(echo $job | jq -rc --arg a "$result" '.message = $a')
    job=$(echo $job | jq -rc --arg a "error" '.status = $a')
    jobs=$(echo $jobs | jq -r ". |= .+ [$job]")
    return 1
  fi
}

jobs="[]"
runJobTypes() {
  export JOB_ID=$(uuidgen)
  for job_type in $@; do
    export JOB_TYPE=$(echo $job_type | cut -d ':' -f 1)
    export JOB_TYPE_NAME=$(echo $job_type | cut -d ':' -f 2)
    if [ -z "$JOB_TYPE_NAME" ]; then
      JOB_TYPE_NAME=$JOB_TYPE
    fi
    if ! runJob; then
      break
    fi
  done
}

jobTypes=$@
if [ -n "$CONTEXT" ]; then
  CONTEXT_LIST=$CONTEXT
  for context in $(echo $CONTEXT_LIST | sed "s/,/ /g"); do
    export CONTEXT=$context
    runJobTypes $jobTypes
  done
else
  runJobTypes $jobTypes
fi

# echo '{"jobs":[]}' | jq -rc ".jobs = $jobs"
echo '{"jobs":[]}' | jq -r ".jobs = $jobs"
