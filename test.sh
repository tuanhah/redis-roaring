#!/usr/bin/env bash

set -eu

function unit()
{
  mkdir -p build && \
cd build && \
TEST=1 cmake .. && \
make && \
valgrind --leak-check=full --error-exitcode=1 ./test_reroaring &&
cd -
}
function build_redis_module()
{
  ./build.sh
}
function start_redis()
{
  pkill -f redis
  sleep 1
  ./deps/redis/src/redis-server --loadmodule ./build/libreroaring.so &
}
function run_tests()
{
  ./tests/integration.sh
}
function integration()
{
  build_redis_module && \
start_redis &&
run_tests
}

unit && integration
