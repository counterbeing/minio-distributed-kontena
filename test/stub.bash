#!/usr/bin/env bash

# Kudos to nherson for this approach
# https://github.com/sstephenson/bats/issues/38#issuecomment-32118353

FIXDIR=$BATS_TEST_DIRNAME/fixtures
export PATH="$BATS_TEST_DIRNAME/stub:$PATH"

make_stubs_dir() {
  if [ ! -d $BATS_TEST_DIRNAME/stub ]; then
    mkdir $BATS_TEST_DIRNAME/stub
  fi
}

stub() {
  make_stubs_dir
  echo $2 > $BATS_TEST_DIRNAME/stub/$1
  chmod +x $BATS_TEST_DIRNAME/stub/$1
}

stub_fixture() {
  stub $1 "cat $FIXDIR/$2"
}

rm_stubs() {
  rm -rf $BATS_TEST_DIRNAME/stub
}

# Useful for debugging
inspect_output() {
  echo '----- Printing output of all lines --------'
  printf '%s\n' "${lines[@]}"
  echo '----- $status code --------'
  echo $status
  echo '-----'
}
