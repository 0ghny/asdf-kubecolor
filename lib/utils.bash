#!/bin/bash

set -euo pipefail

GH_REPO="https://github.com/hidetatz/kubecolor"
TOOL_NAME="kubecolor"
TOOL_TEST="kubecolor --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kubecolor is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # Change this function if kubecolor has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  local -r platform="$(get_platform)"
  local -r arch="$(get_arch)"
  local -r ext="$(get_file_ext)"
  version="$1"
  filename="$2"

  # https://github.com/hidetatz/kubecolor/releases/download/v0.0.19/kubecolor_0.0.19_Darwin_arm64.tar.gz
  url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_${platform}_${arch}.${ext}"

  echo "* Downloading $TOOL_NAME release $version ${platform}/${arch}..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    echo "Installing from $ASDF_DOWNLOAD_PATH to $install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"
    test -x "$install_path/$TOOL_NAME" || fail "Expected $install_path/$TOOL_NAME binary not found."
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
# .............................................................................
# get_platform: determine platform of running machine
# .............................................................................
get_platform() {
  local platform="Linux"
  case "$(uname -s | tr '[:upper:]' '[:lower:]')" in
    darwin) platform="Darwin" ;;
    linux) platform="Linux" ;;
    *) platform_not_supported; ;;
  esac

  echo -n $platform
}
# .............................................................................
# get_arch: determine architecture of running machine
# .............................................................................
get_arch() {
  local arch="x86_64"
  case "$(uname -m)" in
    arm64|aarch64) arch="arm64"; ;;
    x86_64|amd64) arch="x86_64"; ;;
    ppc64le) arch="ppc64le"; ;;
    *) architecture_not_supported; ;;
  esac
  echo -n "${arch}"
}
# .............................................................................
# get_file_ext: determine file extension based on platform
# .............................................................................
get_file_ext() {
  local ext="tar.gz"
  case "$(uname | tr '[:upper:]' '[:lower:]')" in
    darwin) ext="tar.gz" ;;
    linux) ext="tar.gz" ;;
    ppc64le) ext="tar.gz" ;;
    *) platform_not_supported; ;;
  esac
  echo -n "${ext}"
}
# .............................................................................
# LOG::fail
# .............................................................................
fail() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][FAIL] $*"
  exit 1
}
# .............................................................................
# platform_not_supported: Raise a platform not supported exception
# .............................................................................
platform_not_supported() {
  fail "Platform '$(uname)' not supported!"
}
# .............................................................................
# architecture_not_supported: Raise an architecture not supported exception
# .............................................................................
architecture_not_supported() {
  fail "Platform '$(uname -m)' not supported!"
}
