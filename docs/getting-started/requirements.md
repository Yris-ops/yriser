# Requirements

Yriser has been written in Shell using the `jq`, `bc` and AWS CLI.

## Install `jq`

| Operating System |                  Installation Instructions                 |          Available jq Versions          |
|:----------------:|:----------------------------------------------------------:|:---------------------------------------:|
| Linux            | sudo apt-get install jq (Debian/Ubuntu)                    | 1.6 (64-bit), 1.5, 1.4, 1.3 (64/32-bit) |
| Linux            | sudo dnf install jq (Fedora)                               |                                         |
| Linux            | sudo zypper install jq (openSUSE)                          |                                         |
| Linux            | sudo pacman -S jq (Arch)                                   |                                         |
| macOS            | brew install jq (Homebrew)                                 | 1.6 (64-bit), 1.5, 1.4, 1.3 (64-bit)    |
| macOS            | port install jq (MacPorts)                                 |                                         |
| macOS            | fink install jq (Fink)                                     |                                         |
| FreeBSD          | pkg install jq (pre-built)                                 |                                         |
| FreeBSD          | make -C /usr/ports/textproc/jq install clean (from source) |                                         |
| Solaris          | pkgutil -i jq (OpenCSW)                                    |                                         |

## Install `bc`

| Operating System | Installation Instructions                              |
|------------------|--------------------------------------------------------|
| Linux            | sudo apt-get install bc (Debian/Ubuntu)                |
| Linux            | sudo dnf install bc (Fedora)                           |
| Linux            | sudo zypper install bc (openSUSE)                      |
| Linux            | sudo pacman -S bc (Arch)                               |
| macOS            | brew install bc (Homebrew)                             |
| macOS            | port install bc (MacPorts)                             |
| macOS            | fink install bc (Fink)                                 |
| FreeBSD          | pkg install bc (pre-built)                             |
| FreeBSD          | make -C /usr/ports/math/bc install clean (from source) |
| Solaris          | pkgutil -i bc (OpenCSW)                                |
| Solaris          | bc 1.07.1 binaries for Solaris 11 (64-bit/32-bit)      |

## AWS

### AWS CLI

Please refer to the [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)

### AWS Authentication

Make sure you have properly configured your AWS-CLI with a valid Access Key and Region or declare AWS variables properly (or instance profile/role):

``` shell
aws configure sso
```

or

``` shell
export AWS_ACCESS_KEY_ID="ASXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXX"
export AWS_SESSION_TOKEN="XXXXXXXXX"
```