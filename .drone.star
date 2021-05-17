def main(ctx):
    before = testing(ctx)

    stages = []

    after = release(ctx) + notification(ctx)

    for b in before:
        for s in stages:
            s["depends_on"].append(b["name"])

    for s in stages:
        for a in after:
            a["depends_on"].append(s["name"])

    return before + stages + after

def testing(ctx):
    return [{
        "kind": "pipeline",
        "type": "docker",
        "name": "testing",
        "platform": {
            "os": "linux",
            "arch": "amd64",
        },
        "steps": [
            {
                "name": "lint",
                "image": "koalaman/shellcheck-alpine:stable",
                "commands": [
                    "shellcheck ./retry",
                ],
            },
        ],
        "trigger": {
            "ref": [
                "refs/heads/master",
                "refs/tags/**",
                "refs/pull/**",
            ],
        },
    }]

def release(ctx):
  return [{
    "kind": "pipeline",
    "type": "docker",
    "name": "release",
    "steps": [
        {
            "name": "changelog",
            "image": "thegeeklab/git-chglog",
            "commands": [
                "git fetch -tq",
                "git-chglog --no-color --no-emoji %s" % (ctx.build.ref.replace("refs/tags/", "") if ctx.build.event == "tag" else "--next-tag unreleased unreleased"),
                "git-chglog --no-color --no-emoji -o CHANGELOG.md %s" % (ctx.build.ref.replace("refs/tags/", "") if ctx.build.event == "tag" else "--next-tag unreleased unreleased"),
            ]
        },
        {
           "name": "release",
           "image": "plugins/github-release",
           "settings": {
               "api_key": {
                   "from_secret": "github_token",
               },
               "note": "CHANGELOG.md",
               "overwrite": True,
               "title": ctx.build.ref.replace("refs/tags/", ""),
               "files": [
                   "retry"
                ],
           },
           "when": {
             "ref": [
                "refs/tags/**",
             ],
          },
        }
    ],
    "depends_on": [
        "testing",
    ],
    "trigger": {
        "ref": [
            "refs/heads/master",
            "refs/tags/**",
            "refs/pull/**",
        ],
    },
  }]

def notification(ctx):
  return [{
    "kind": "pipeline",
    "type": "docker",
    "name": "notify",
    "clone": {
        "disable": True,
    },
    "steps": [
        {
            "name": "notify",
            "image": "plugins/slack",
            "settings": {
            "webhook": {
                "from_secret": "private_rocketchat",
            },
            "channel": "builds",
            },
        }
    ],
    "depends_on": [
        "release",
    ],
    "trigger": {
        "ref": [
            "refs/heads/master",
            "refs/tags/**",
        ],
        "status": [
            "success",
            "failure",
        ],
    },
  }]
