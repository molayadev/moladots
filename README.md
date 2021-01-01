███╗   ███╗ ██████╗ ██╗      █████╗ ██╗   ██╗ █████╗ ██████╗ ███████╗██╗   ██╗
████╗ ████║██╔═══██╗██║     ██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝██║   ██║
██╔████╔██║██║   ██║██║     ███████║ ╚████╔╝ ███████║██║  ██║█████╗  ██║   ██║
██║╚██╔╝██║██║   ██║██║     ██╔══██║  ╚██╔╝  ██╔══██║██║  ██║██╔══╝  ╚██╗ ██╔╝
██║ ╚═╝ ██║╚██████╔╝███████╗██║  ██║   ██║   ██║  ██║██████╔╝███████╗ ╚████╔╝ 
╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝  ╚═══╝  
                                                                              	

<p align="center">
  <a href="https://github.com/molayadev/moladots/actions">
    <img alt="build status badge" src="https://github.com/molayadev/moladots/workflows/build/badge.svg?branch=master">
  </a>
  <a href="https://github.com/molayadev/moladots/blob/master/LICENSE">
    <img alt="License: MIT" src="https://img.shields.io/github/license/molayadev/moladots" />
  </a>
  <a href="">
    <img alt="platform: linux and macos" src="https://img.shields.io/badge/platform-GNU/Linux %7C MacOS-blue">
  </a>
</p>


## 🌠 Features

* **Single file manager** (Portable)
* **No config files for moladots** (No `.dotrc` 🤦)
* **No useless arguments** (single command 😎)
* **Easy to use**
* **Fewer Dependencies**
  - **`Bash>=3`**
* **Auto Install Dependencies**
  - **`Git`**
  - **`Cowsay`**
* **Allow to install some common Development Tools**

## 💠 Installation

### via `curl` ➰

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/molayadev/moladots/master/tools/install.sh)"
```

### via `wget` 📥

```shell
sh -c "$(wget -O- https://raw.githubusercontent.com/molayadev/moladots/master/tools/install.sh)"
```

### via `httpie` 🥧

```shell
sh -c "$(http --download https://raw.githubusercontent.com/molayadev/moladots/master/tools/install.sh)"
```

> **moladots** is installed by default in `/home/username/moladots`, your `$HOME` directory.


Now run **`moladots`** for 1st time set-up.

1. Enter repository URL (without `.git`).
2. Specify folder you want to clone the dotfile repo to (relative to `/home/username/`).
3. Open up new terminal 🚀.

### Manually (you ok ?)

1. Just grab **moladots.sh** from [Releases 🔼](https://github.com/molayadev/moladots/releases) and store it anywhere on your system.
2. Change file permissions to be 🏃 executable.
  ```bash
  chmod +x moladots.sh
  ```
3. Set alias for moladots _(optional)_. Alternatively modify your `.bash_aliases` file. 
  ```bash
  alias $(pwd)/moladots.sh=moladots
  ```
4. Run **moladots**.
  ```bash
  moladots.sh
  ```

## Usage

Just run **`moladots`** anywhere in your terminal 🖖.

```bash
moladots
```
Leave the rest to it.


## What else 👀

moladots exports 2 variables in your default shell config (`bashrc`, `zshrc` etc):

1. `MOLADOT_DEST`: used for finding the location of dotfiles repository in your local system.
2. `MOLADOT_REPO`: the url to the remote dotfile repo.

You can change these manually if any one of the info changes.


## Credits
Thanks to much to 🤓 **Bhupesh Varshney**
Based on https://github.com/Bhupesh-V/dotman his developed template.
[Web](https://bhupesh-v.github.io) | [Twitter: @bhupeshimself](https://twitter.com/bhupeshimself) | [DEV: bhupesh](https://dev.to/bhupesh)
[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
<a href="https://liberapay.com/bhupesh/donate">
  <img title="librepay/bhupesh" alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg" width="100">
</a>

## 📝 License

Copyright © 2020 [Marlon Olaya](https://github.com/molayadev).<br />
This project is [MIT](https://github.com/molayadev/moladots/blob/master/LICENSE) licensed.

## 📝 Changelog

See the [CHANGELOG.md](CHANGELOG.md) file for details.
