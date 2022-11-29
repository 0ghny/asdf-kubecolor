<div align="center">

# asdf-kubecolor [![Build](https://github.com/0ghny/asdf-kubecolor/actions/workflows/build.yml/badge.svg)](https://github.com/0ghny/asdf-kubecolor/actions/workflows/build.yml) [![Lint](https://github.com/0ghny/asdf-kubecolor/actions/workflows/lint.yml/badge.svg)](https://github.com/0ghny/asdf-kubecolor/actions/workflows/lint.yml)


[kubecolor](https://github.com/hidetatz/kubecolor) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-kubecolor  ](#asdf-kubecolor--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add kubecolor
# or
asdf plugin add kubecolor https://github.com/0ghny/asdf-kubecolor.git
```

kubecolor:

```shell
# Show all installable versions
asdf list-all kubecolor

# Install specific version
asdf install kubecolor latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kubecolor latest

# Now kubecolor commands are available
kubecolor --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/0ghny/asdf-kubecolor/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [0ghny](https://github.com/0ghny/)
