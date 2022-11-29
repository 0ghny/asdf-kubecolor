# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test kubecolor https://github.com/0ghny/asdf-kubecolor.git "kubecolor --help"
```

Tests are automatically run in GitHub Actions on push and PR.
