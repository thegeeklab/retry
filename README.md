# retry

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ci/retry/status.svg)](https://drone.owncloud.com/owncloud-ci/retry/)
[![Source: GitHub](https://img.shields.io/badge/source-github-blue.svg?logo=github&logoColor=white)](https://github.com/owncloud-ci/retry)
[![License: Apache-2.0](https://img.shields.io/github/license/owncloud-ci/retry)](https://github.com/owncloud-ci/retry/blob/main/LICENSE)

Retry any shell command with exponential backoff or constant delay.

## Instructions

Install:

retry is a shell script, so drop it somewhere and make sure it's added to your $PATH. Or you can use the following one-liner:

```Shell
curl -SsL -o /usr/local/bin/retry https://raw.githubusercontent.com/owncloud-ops/retry/master/retry && chmod +x /usr/local/bin/retry"
```

## Usage

Help:

```Shell
retry -?

Usage: retry [options] -- execute command
    -h, -?, --help
    -v, --verbose                    Verbose output
    -t, --tries=#                    Set max retries: Default 10
    -s, --sleep=secs                 Constant sleep amount (seconds)
    -m, --min=secs                   Exponential Backoff: minimum sleep amount (seconds): Default 0.3
    -x, --max=secs                   Exponential Backoff: maximum sleep amount (seconds): Default 60
    -f, --fail="script +cmds"        Fail Script: run in case of final failure
```

## Examples

No problem:

```Shell
retry echo u work good

u work good
```

Test functionality:

```Shell
retry 'echo "y u no work"; false'

y u no work
Before retry #1: sleeping 0.3 seconds
y u no work
Before retry #2: sleeping 0.6 seconds
y u no work
Before retry #3: sleeping 1.2 seconds
y u no work
Before retry #4: sleeping 2.4 seconds
y u no work
Before retry #5: sleeping 4.8 seconds
y u no work
Before retry #6: sleeping 9.6 seconds
y u no work
Before retry #7: sleeping 19.2 seconds
y u no work
Before retry #8: sleeping 38.4 seconds
y u no work
Before retry #9: sleeping 60.0 seconds
y u no work
Before retry #10: sleeping 60.0 seconds
y u no work
etc..
```

Limit retries:

```Shell
retry -t 4 'echo "y u no work"; false'

y u no work
Before retry #1: sleeping 0.3 seconds
y u no work
Before retry #2: sleeping 0.6 seconds
y u no work
Before retry #3: sleeping 1.2 seconds
y u no work
Before retry #4: sleeping 2.4 seconds
y u no work
Retries exhausted
```

Bad command:

```Shell
retry poop

bash: poop: command not found
```

Fail command:

```Shell
retry -t 3 -f 'echo "oh poopsickles"' 'echo "y u no work"; false'

y u no work
Before retry #1: sleeping 0.3 seconds
y u no work
Before retry #2: sleeping 0.6 seconds
y u no work
Before retry #3: sleeping 1.2 seconds
y u no work
Retries exhausted, running fail script
oh poopsickles
```

Last attempt passed:

```Shell
retry -t 3 -- 'if [ $RETRY_ATTEMPT -eq 3 ]; then echo Passed at attempt $RETRY_ATTEMPT; true; else echo Failed at attempt $RETRY_ATTEMPT; false; fi;'

Failed at attempt 0
Before retry #1: sleeping 0.3 seconds
Failed at attempt 1
Before retry #2: sleeping 0.6 seconds
Failed at attempt 2
Before retry #3: sleeping 1.2 seconds
Passed at attempt 3
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ci/retry/blob/master/LICENSE) file for details.
