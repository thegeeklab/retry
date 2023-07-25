# retry

Poor-mans servie synchronizer

[![Build Status](https://ci.thegeeklab.de/api/badges/4/status.svg)](https://ci.thegeeklab.de/4)
[![Docker Hub](https://img.shields.io/badge/dockerhub-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/thegeeklab/retry)
[![Quay.io](https://img.shields.io/badge/quay-latest-blue.svg?logo=docker&logoColor=white)](https://quay.io/repository/thegeeklab/retry)
[![GitHub contributors](https://img.shields.io/github/contributors/thegeeklab/retry)](https://github.com/thegeeklab/retry/graphs/contributors)
[![Source: GitHub](https://img.shields.io/badge/source-github-blue.svg?logo=github&logoColor=white)](https://github.com/thegeeklab/retry)
[![License: MIT](https://img.shields.io/github/license/thegeeklab/retry)](https://github.com/thegeeklab/retry/blob/main/LICENSE)

Retry any shell command with exponential backoff or constant delay.

## Instructions

Install:

retry is a shell script, so drop it somewhere and make sure it's added to your \$PATH. Or you can use the following one-liner:

```Shell
curl -SsfL -o /usr/local/bin/retry https://raw.githubusercontent.com/thegeeklab/retry/main/retry && chmod +x /usr/local/bin/retry
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

## Contributors

Special thanks to all [contributors](https://github.com/thegeeklab/retry/graphs/contributors). If you would like to contribute, please see the [instructions](https://github.com/thegeeklab/retry/blob/main/CONTRIBUTING.md).

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/thegeeklab/retry/blob/main/LICENSE) file for details.
