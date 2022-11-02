#!/usr/bin/env bats

@test "retry echo should work" {
  run ./retry echo u work good

  [ "$output" = "u work good" ]
}

@test "retry false should fail" {
  run ./retry -t 1 'echo "y u no work"; false'

  [ "$status" -ne 0 ]
  [ "$output" = "y u no work" ]
}
