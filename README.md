## Features

* Root indicator

<img src="https://cloud.githubusercontent.com/assets/4973929/26007208/ce48aa0c-373f-11e7-9148-e2061776d0b1.png" alt="Root indicator" width="300px" />

* Git tracking

<img src="https://cloud.githubusercontent.com/assets/4973929/26007167/ab2c326e-373f-11e7-93ec-e748f1a29b37.png" alt="Git tracking" width="500px" />

* Node version

<img src="https://cloud.githubusercontent.com/assets/4973929/26007058/405a99c6-373f-11e7-91be-6a2c1eaac628.png" alt="Node version" width="560px" />

* PHP version

<img src="https://cloud.githubusercontent.com/assets/4973929/26029464/fd641424-3835-11e7-8c3a-5d0d13b11ad3.png" alt="PHP version" width="560px" />

* Hostname including SSH

<img src="https://cloud.githubusercontent.com/assets/4973929/26019527/1dfcfcca-3776-11e7-960f-61d9ff7297f4.png" alt="Hostname including SSH" width="360px" />

* Vagrant status

<img src="https://cloud.githubusercontent.com/assets/4973929/26019461/b29aa7c0-3775-11e7-865f-38956172dc84.png" alt="Vagrant status" width="610px">

* Configurable

Additional prompts can be disabled

## Getting Started

### Prerequisites

* `Oh My Zsh` should be installed
* `wget` should be installed

### Installation

```shell
sh -c "$(wget https://raw.githubusercontent.com/gorzechowski/zsh-theme/master/install.sh -O -)"
```

After theme is installed, switch theme in `~/.zshrc` file

```shell
ZSH_THEME="gorzechowski"
```

### Setup

Default settings are

| Property name                              | Value   |
| -----------------------------------------: | :-----: |
| GORZECHOWSKI_THEME_VAGRANT_MACHINE_PROMPT  | false   |
| GORZECHOWSKI_THEME_NODE_VERSION_PROMPT     | true    |
| GORZECHOWSKI_THEME_GIT_PROMPT              | true    |
| GORZECHOWSKI_THEME_GIT_STATUS_PROMPT       | true    |
| GORZECHOWSKI_THEME_HOSTNAME_PROMPT         | true    |
| GORZECHOWSKI_THEME_PHP_VERSION_PROMPT      | true    |

Overwrite properties in `~/.zshrc` file

```shell
GORZECHOWSKI_THEME_VAGRANT_MACHINE_PROMPT=true
```
