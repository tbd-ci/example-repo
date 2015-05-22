# example-repo
Example repo for TBD

## Tests

`ls -1 ./ci/*/run | xargs -n 1 bash` will run all the tests, ignoring dependencies, and not log output anywhere.

I'd like to be able to do:

`tbd-build ./ci`

which would do the stuff in ci-sample.sh


```

EXISTING="$PROCESSING/*"
for f in $EXISTING
do
  if [ -f "$f" ] ; then
    echo "File $f is still being processed" 1>&2
    exit 3 # 3 means neither success nor failure
  fi
done

for $f in $( find ./ci/ -iname dependencies -exec tbd-dependencies-met )

```

`find ./ci/ -iname dependencies -exec tbd-dependencies-met `
which would print 'quality' and 'ci/assets/dependencies'
then pipe through
`find -exec tbd-needs-build`
which would still print 'ci/quality/dependencies' and 'ci/assets/dependencies'
then pipe through ``
which just prints 'ci/quality/dependencies'
then ```
COMMAND=read
tbd-run --store-prefix $(git rev-parse head)/rubocop/$(date +%Y%m%d%H%M%S)/$(hostname)-main
```

`tbd-run ./ci/quality/run` and `
