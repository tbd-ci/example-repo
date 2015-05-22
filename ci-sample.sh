#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export ci_dir=${1-'./.tbd'}
export rev=$(git rev-parse head)

if [ ! -d "$ci_dir" ]
then
  echo "Could not find CI dir '$ci_dir'" >&2
  exit 1
fi

dependencies=( tbd-run tbd-dependencies-met tbd-needs-build git date hostname )
for dependency in $dependencies
do
  if ! which "$dependency" > /dev/null
  then
    echo "Could not find '$dependency', exiting"
    exit 1
  fi
done

TRY_AGAIN=0
MADE_PROGRESS=0
for target in $( ls -1 "$ci_dir" )
do
  target_dir="$ci_dir/$target"
  if tbd-dependencies-met "$target_dir/dependencies"
  then
    if tbd-needs-build "$target"
    then
      now=$(date +%Y%m%d%H%M%S)
      store_prefix="$rev/$target/$now/$(hostname)"
      tbd-run "$target_dir/run" --store-prefix "$store_prefix"
      MADE_PROGRESS=1
    fi
  else
    if [ $? -eq 127 ]
    then
      exit 1
    fi
    TRY_AGAIN=1
  fi
done

if [ $TRY_AGAIN -eq 1 ]
then
  if [ $MADE_PROGRESS -eq 1 ]
  then
    "$0" "$@"
  else
    echo "Didnt make progress"
    exit 1
  fi
fi
