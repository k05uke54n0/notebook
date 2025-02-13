# バイオインフォマ関係の覚書

## 基本的な事項
```php
ssh gw.ddbj.nig.ac.jp
#スパコンへのログイン。この後にqloginを実行して作業ノードへ移る

scp ~/Desctop/hoge kosukesano@gw.ddbj.nig.ac.jp:/home/kosukesano/bio/
#ローカルの~/Desctop/にあるhogeというファイルを遺伝研スパコンの/home/kosukesano/bio/にコピーする。ローカルで実行する。ディレクトリをコピーする場合はscp -rとする。

scp kosukesano@gw.ddbj.nig.ac.jp:/home/kosukesano/bio/hoge　~/Desctop/
#遺伝研スパコンの/home/kosukesano/bio/にあるhogeというファイルをローカルの~/Desctop/にコピーする。**ローカルで実行する。**

source ~/tools/pyenv_env/braker_profile
# braker環境を立ち上げる際、初めに行う。pyenvとcondaにパスを通し、conda環境に入った後にbraker環境に入る。

source ~/pyenv_conda_environment/.pyenv_profile
# pyenvを実行する際、初めに行う。パスを通す。
```

## 2024年4月

### 0430
遺伝研スパコンのホームディレクトリの中身を全てHDDに移した。場所は
`/Volumes/Elements/240430_ddbj_backup/kosukesano$`

```php
# 実行したコード
$ scp -r kosukesano@gw.ddbj.nig.ac.jp:/home/kosukesano/ /Volumes/Elements/240430_ddbj_backup
```

## 2024年5月

### 0501
遺伝研スパコンの`Anaconda3`と`miniforge`を削除した。またホームディレクトリにあったファイルも（ディレクトリ以外は）削除した。

[`anaconda`のアンインストール参考](https://qiita.com/yu_ku/items/efe0513f1b8036c2d2f8)
```php
# Anacondaのアンインストール
$ conda install anaconda-clean
$ anaconda-clean
$ rm -fr /anaconda3
```
[`miniforge`のアンインストール参考](https://zenn.dev/karaage0703/articles/f3254b14898b4d)
```php
# miniforgeのアンインストール
$ rm -rf ~/.conda
# ~/.local/bin/ になぜかmambaがいたので、
$ rm mamba
```

遺伝研の環境初期化ページに倣い、`.bashrc`と`.bash_profile`を書き直した。[遺伝研初期化ページ参考](https://sc.ddbj.nig.ac.jp/faq/faq_software/#ubuntu-initialization)

**変更前の`.bash_profile`**
```php
# .bash_profile

# Get the aliases and functions
#
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

##############################

source ~/.bashrc

#############################


# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH


export GENEMARK_PATH=/home/kosukesano/local/gmes_linux_64_4
export PROTHINT_PATH=/home/kosukesano/local/gmes_linux_64_4/ProtHint/bin
export ALIGNMENT_TOOL_PATH=/home/kosukesano/local/spaln-master
export CDBTOOLS_PATH=/home/kosukesano/local/cdbfasta-master

#source ~/.bash_profile
```

**変更後の`.bash_profile`**
```php
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
```

**変更前の`.bashrc`**
```php
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

##########################################

# If this variable is already set, skip the rest of the script
if [ -n "$BASHRC_LOADED" ]; then
    return
fi

# Set the variable to indicate that the script has been loaded
BASHRC_LOADED=1

# ---

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi





#########################################

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
#module load gcc

# <<< conda initialize <<<

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
```

**変更後の.bashrc**
```php
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
module load gcc
```

元の`.bashrc`にあった記述のうち、色に関わる内容をもう一度記載。

**`.bashrc`への加筆内容**
```php

###ここから下は主に書き加えた部分###

####################################################################################
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
####################################################################################
#↑により、カラー対応の端末で Bash を実行している場合にのみ、色付きのプロンプトが表示される



###################################################################################
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
####################################################################################
#↑ターミナルプロンプトの色や表示を設定する



#####################################################################################
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
#######################################################################################
#↑ls および grep コマンドに色のサポートをつける
```

また、ログイン時にGCCに関わる部分で以下のエラーが発生した。
```php
[kosukesano@gwB1 ~]$ qlogin
Your job 25915671 ("QLOGIN") has been submitted
waiting for interactive job to be scheduled ...
Your interactive job 25915671 has been successfully scheduled.
Establishing /home/geadmin/AGER/utilbin/lx-amd64/qlogin_wrapper session to host at137 ...
Warning: Permanently added '[at137]:41669,[172.19.7.185]:41669' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-87-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed May  1 16:06:51 JST 2024

  System load:  3.0078125           Users logged in:           34
  Usage of /:   32.8% of 823.03GB   IPv4 address for eno1:     172.19.18.185
  Memory usage: 34%                 IPv4 address for eno2:     192.168.50.187
  Swap usage:   27%                 IPv4 address for ibp161s0: 172.19.7.185
  Processes:    2133

  => There is 1 zombie process.

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

11 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

56 additional security updates can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm


Last login: Tue Apr 30 10:14:26 2024 from 172.19.7.250
ERROR: Unable to locate a modulefile for 'gcc'
```

かつての`.bashrc`を見ると`module load gcc`という記述がコメントアウトされていた。暫定的に今回もコメントアウトしておく。
```php
# User specific aliases and functions
#module load gcc
#↑この部分でなんかエラーが出たんだけど、昔のbashrcはコメントアウトしちゃってたので同様の処置をとった。
```

### 0502

**`pyenv`のインストール**
```php
kosukesano@at139:~$ git clone git://github.com/yyuu/pyenv.git ~/.pyenv
# pyenvをgitでインストール
```

`.bash_profile`などにパスを書くと何かミスがあった場合重大なことになるため、別のプロファイルを作ってそこにパスを書く
```php
kosukesano@at139:~$ mkdir pyenv_conda_environment
# pyenv_conda_environmentというディレクトリをホーム直下に作成
kosukesano@at139:~$ cd pyenv_conda_environment/
kosukesano@at139:~/pyenv_conda_environment$ nano .pyenv_profile
# .pyenv_profileというファイルを作成
```

`.pyenv_profile`の中身
```php
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

この後、`pyenv`を打っても`Command not found`と出てしまうが、`source ~/pyenv_conda_environment/.pyenv_profile`で先ほどのプロファイルをソースすると、`pyenv`が機能するようになる。

今後も`pyenv`を使う場合は毎回初めに`source ~/pyenv_conda_environment/.pyenv_profile`を行う。
```php
kosukesano@at137:~$ pyenv
Command 'pyenv' not found, did you mean:
  command 'p7env' from deb libnss3-tools (2:3.68.2-0ubuntu1.2)
Try: apt install <deb name>
kosukesano@at137:~$ source ~/pyenv_conda_environment/.pyenv_profile 
kosukesano@at137:~$ pyenv
pyenv 2.4.0-3-g3ff54e89
Usage: pyenv <command> [<args>]

Some useful pyenv commands are:
   --version   Display the version of pyenv
   .
   .
   .
   .
   .
```

**`pyenv`にて`anaconda3`環境の構築**
```php
kosukesano@at137:~$ pyenv install  anaconda3-2023.09-0
```

↑を作業ノード`@137`で実行したらうまくいかなかった。`conda.exe`が作業ノードに高負荷を与えていると遺伝研の方から言われた。

**原因　`conda`が重い**

メモリをめちゃくちゃ増やしたらなんとかなった
```php
#$ -S /bin/bash
#$ -cwd
#$ -l medium
#$ -pe def_slot 1
#$ -l s_vmem=48G
#$ -l mem_req=48G
date

echo starting at date
source ~/pyenv_conda_environment/.pyenv_profile
pyenv install anaconda3-2020.11

date
```
`/home/kosukesano/.pyenv/version`に`anaconda3-2020.11`を作成した。

`~/tools/pyenv_env`を作成、その下に`braker_profile`を作成した。

```php
source ~/.bash_profile
source ~/pyenv_conda_environment/.pyenv_profile
pyenv global anaconda3-2020.11



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/kosukesano/.pyenv/versions/anaconda3-2020.11/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/kosukesano/.pyenv/versions/anaconda3-2020.11/etc/profile.d/conda.sh" ]; then
        . "/home/kosukesano/.pyenv/versions/anaconda3-2020.11/etc/profile.d/conda.sh"
    else
        export PATH="/home/kosukesano/.pyenv/versions/anaconda3-2020.11/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

conda activate braker
```

**`braker`のインストールの前準備**

うまくいったやつ
```php
conda install -c anaconda perl
conda install -c anaconda biopython
```

うまくいかなかったやつ
```php
conda install -c bioconda perl-app-cpanminus
conda install -c bioconda perl-file-spec
conda install -c bioconda perl-hash-merge
conda install -c bioconda perl-list-util
conda install -c bioconda perl-module-load-conditional
conda install -c bioconda perl-posix
conda install -c bioconda perl-file-homedir
conda install -c bioconda perl-parallel-forkmanager
conda install -c bioconda perl-scalar-util-numeric
conda install -c bioconda perl-yaml
conda install -c bioconda perl-class-data-inheritable
conda install -c bioconda perl-exception-class

```

```php
(braker) kosukesano@at137:~/tools/braker$ conda install -c bioconda perl-list-util
Collecting package metadata (current_repodata.json): done
Solving environment: failed with initial frozen solve. Retrying with flexible solve.
Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.

ResolvePackageNotFound: 
  - python=3.1

(braker) kosukesano@at137:~/tools/braker$ conda install -c bioconda perl-module-load-conditional
Collecting package metadata (current_repodata.json): done
Solving environment: failed with initial frozen solve. Retrying with flexible solve.
Solving environment: failed with repodata from current_repodata.json, will retry with next repodata source.

ResolvePackageNotFound: 
  - python=3.1
```
こんな感じのエラーが出てインストールできなかった

### 0507

**現在の`braker`環境を削除**
```php
(braker) kosukesano@at137:~$ conda deactivate
(base) kosukesano@at137:~$ conda remove -n braker --all

Remove all packages in environment /home/kosukesano/.pyenv/versions/anaconda3-2020.11/envs/braker:


## Package Plan ##

  environment location: /home/kosukesano/.pyenv/versions/anaconda3-2020.11/envs/braker


The following packages will be REMOVED:

  _libgcc_mutex-0.1-main
  _openmp_mutex-5.1-1_gnu
  biopython-1.78-py312h5eee18b_0
  blas-1.0-mkl
  bzip2-1.0.8-h7b6447c_0
  ca-certificates-2023.08.22-h06a4308_0
  expat-2.5.0-h6a678d5_0
  gdbm-1.18-hd4cb3f1_4
  intel-openmp-2023.1.0-hdb19cb5_46306
  ld_impl_linux-64-2.38-h1181459_1
  libffi-3.4.4-h6a678d5_0
  libgcc-ng-11.2.0-h1234567_1
  libgomp-11.2.0-h1234567_1
  libstdcxx-ng-11.2.0-h1234567_1
  libuuid-1.41.5-h5eee18b_0
  mkl-2023.1.0-h213fc3f_46344
  mkl-service-2.4.0-py312h5eee18b_1
  ncurses-6.4-h6a678d5_0
  numpy-1.26.0-py312hc5e2394_0
  numpy-base-1.26.0-py312h0da6c21_0
  openssl-3.0.12-h7f8727e_0
  perl-5.34.0-h5eee18b_2
  pip-23.3-py312h06a4308_0
  python-3.12.0-h996f2a0_0
  readline-8.2-h5eee18b_0
  setuptools-68.0.0-py312h06a4308_0
  sqlite-3.41.2-h5eee18b_0
  tbb-2021.8.0-hdb19cb5_0
  tk-8.6.12-h1ccaba5_0
  tzdata-2023c-h04d1e81_0
  wheel-0.41.2-py312h06a4308_0
  xz-5.4.2-h5eee18b_0
  zlib-1.2.13-h5eee18b_0


Proceed ([y]/n)? y

Preparing transaction: done
Verifying transaction: done
Executing transaction: done
(base) kosukesano@at137
```

**改めて`braker`環境を構築、`python=3.9`に指定**
```php
(base) kosukesano@at137:~/tools$ conda create -n braker python=3.9
Collecting package metadata (current_repodata.json): done
Solving environment: done


==> WARNING: A newer version of conda exists. <==
  current version: 4.9.2
  latest version: 24.4.0

Please update conda by running

    $ conda update -n base -c defaults conda



## Package Plan ##

  environment location: /home/kosukesano/.pyenv/versions/anaconda3-2020.11/envs/braker

  added / updated specs:
    - python=3.9


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    _libgcc_mutex-0.1          |             main           3 KB
    _openmp_mutex-5.1          |            1_gnu          21 KB
    ca-certificates-2024.3.11  |       h06a4308_0         127 KB
    ld_impl_linux-64-2.38      |       h1181459_1         654 KB
    libffi-3.4.4               |       h6a678d5_1         141 KB
    libgcc-ng-11.2.0           |       h1234567_1         5.3 MB
    libgomp-11.2.0             |       h1234567_1         474 KB
    libstdcxx-ng-11.2.0        |       h1234567_1         4.7 MB
    ncurses-6.4                |       h6a678d5_0         914 KB
    openssl-3.0.13             |       h7f8727e_1         5.2 MB
    pip-23.3.1                 |   py39h06a4308_0         2.6 MB
    python-3.9.19              |       h955ad1f_1        25.1 MB
    readline-8.2               |       h5eee18b_0         357 KB
    setuptools-69.5.1          |   py39h06a4308_0        1003 KB
    sqlite-3.45.3              |       h5eee18b_0         1.2 MB
    tk-8.6.14                  |       h39e8969_0         3.4 MB
    tzdata-2024a               |       h04d1e81_0         116 KB
    wheel-0.43.0               |   py39h06a4308_0         109 KB
    xz-5.4.6                   |       h5eee18b_1         643 KB
    zlib-1.2.13                |       h5eee18b_1         111 KB
    ------------------------------------------------------------
                                           Total:        52.2 MB

The following NEW packages will be INSTALLED:

  _libgcc_mutex      pkgs/main/linux-64::_libgcc_mutex-0.1-main
  _openmp_mutex      pkgs/main/linux-64::_openmp_mutex-5.1-1_gnu
  ca-certificates    pkgs/main/linux-64::ca-certificates-2024.3.11-h06a4308_0
  ld_impl_linux-64   pkgs/main/linux-64::ld_impl_linux-64-2.38-h1181459_1
  libffi             pkgs/main/linux-64::libffi-3.4.4-h6a678d5_1
  libgcc-ng          pkgs/main/linux-64::libgcc-ng-11.2.0-h1234567_1
  libgomp            pkgs/main/linux-64::libgomp-11.2.0-h1234567_1
  libstdcxx-ng       pkgs/main/linux-64::libstdcxx-ng-11.2.0-h1234567_1
  ncurses            pkgs/main/linux-64::ncurses-6.4-h6a678d5_0
  openssl            pkgs/main/linux-64::openssl-3.0.13-h7f8727e_1
  pip                pkgs/main/linux-64::pip-23.3.1-py39h06a4308_0
  python             pkgs/main/linux-64::python-3.9.19-h955ad1f_1
  readline           pkgs/main/linux-64::readline-8.2-h5eee18b_0
  setuptools         pkgs/main/linux-64::setuptools-69.5.1-py39h06a4308_0
  sqlite             pkgs/main/linux-64::sqlite-3.45.3-h5eee18b_0
  tk                 pkgs/main/linux-64::tk-8.6.14-h39e8969_0
  tzdata             pkgs/main/noarch::tzdata-2024a-h04d1e81_0
  wheel              pkgs/main/linux-64::wheel-0.43.0-py39h06a4308_0
  xz                 pkgs/main/linux-64::xz-5.4.6-h5eee18b_1
  zlib               pkgs/main/linux-64::zlib-1.2.13-h5eee18b_1


Proceed ([y]/n)? y


Downloading and Extracting Packages
tk-8.6.14            | 3.4 MB    | #################################################################################################################################################### | 100% 
ca-certificates-2024 | 127 KB    | #################################################################################################################################################### | 100% 
libffi-3.4.4         | 141 KB    | #################################################################################################################################################### | 100% 
_openmp_mutex-5.1    | 21 KB     | #################################################################################################################################################### | 100% 
xz-5.4.6             | 643 KB    | #################################################################################################################################################### | 100% 
ld_impl_linux-64-2.3 | 654 KB    | #################################################################################################################################################### | 100% 
sqlite-3.45.3        | 1.2 MB    | #################################################################################################################################################### | 100% 
python-3.9.19        | 25.1 MB   | #################################################################################################################################################### | 100% 
openssl-3.0.13       | 5.2 MB    | #################################################################################################################################################### | 100% 
pip-23.3.1           | 2.6 MB    | #################################################################################################################################################### | 100% 
libgcc-ng-11.2.0     | 5.3 MB    | #################################################################################################################################################### | 100% 
setuptools-69.5.1    | 1003 KB   | #################################################################################################################################################### | 100% 
zlib-1.2.13          | 111 KB    | #################################################################################################################################################### | 100% 
wheel-0.43.0         | 109 KB    | #################################################################################################################################################### | 100% 
libgomp-11.2.0       | 474 KB    | #################################################################################################################################################### | 100% 
tzdata-2024a         | 116 KB    | #################################################################################################################################################### | 100% 
readline-8.2         | 357 KB    | #################################################################################################################################################### | 100% 
_libgcc_mutex-0.1    | 3 KB      | #################################################################################################################################################### | 100% 
libstdcxx-ng-11.2.0  | 4.7 MB    | #################################################################################################################################################### | 100% 
ncurses-6.4          | 914 KB    | #################################################################################################################################################### | 100% 
Preparing transaction: done
Verifying transaction: done
Executing transaction: done
#
# To activate this environment, use
#
#     $ conda activate braker
#
# To deactivate an active environment, use
#
#     $ conda deactivate

(base) kosukesano@at137:~/tools$ source ~/tools/pyenv_env/braker_profile
(braker) kosukesano@at137:~/tools$
```

環境はこうなった
```php
(braker) kosukesano@at137:~/tools$ conda info

     active environment : braker
    active env location : /home/kosukesano/.pyenv/versions/anaconda3-2020.11/envs/braker
            shell level : 2
       user config file : /home/kosukesano/.condarc
 populated config files : 
          conda version : 4.9.2
    conda-build version : 3.20.5
         python version : 3.8.5.final.0
       virtual packages : __glibc=2.35=0
                          __unix=0=0
                          __archspec=1=x86_64
       base environment : /home/kosukesano/.pyenv/versions/anaconda3-2020.11  (writable)
           channel URLs : https://repo.anaconda.com/pkgs/main/linux-64
                          https://repo.anaconda.com/pkgs/main/noarch
                          https://repo.anaconda.com/pkgs/r/linux-64
                          https://repo.anaconda.com/pkgs/r/noarch
          package cache : /home/kosukesano/.pyenv/versions/anaconda3-2020.11/pkgs
                          /home/kosukesano/.conda/pkgs
       envs directories : /home/kosukesano/.pyenv/versions/anaconda3-2020.11/envs
                          /home/kosukesano/.conda/envs
               platform : linux-64
             user-agent : conda/4.9.2 requests/2.24.0 CPython/3.8.5 Linux/5.15.0-87-generic ubuntu/22.04.3 glibc/2.35
                UID:GID : 6811:10086
             netrc file : None
           offline mode : False

(braker) kosukesano@at137:~/tools$
```
昔はこうだったんだけど、なんか変わったんか？
```php
(braker) kosukesano@at137:~$ conda info

     active environment : braker
    active env location : /home/kosukesano/.pyenv/versions/anaconda3-2020.11/envs/braker
            shell level : 2
       user config file : /home/kosukesano/.condarc
 populated config files : 
          conda version : 4.9.2
    conda-build version : 3.20.5
         python version : 3.8.5.final.0
       virtual packages : __glibc=2.35=0
                          __unix=0=0
                          __archspec=1=x86_64
       base environment : /home/kosukesano/.pyenv/versions/anaconda3-2020.11  (writable)
           channel URLs : https://repo.anaconda.com/pkgs/main/linux-64
                          https://repo.anaconda.com/pkgs/main/noarch
                          https://repo.anaconda.com/pkgs/r/linux-64
                          https://repo.anaconda.com/pkgs/r/noarch
          package cache : /home/kosukesano/.pyenv/versions/anaconda3-2020.11/pkgs
                          /home/kosukesano/.conda/pkgs
       envs directories : /home/kosukesano/.pyenv/versions/anaconda3-2020.11/envs
                          /home/kosukesano/.conda/envs
               platform : linux-64
             user-agent : conda/4.9.2 requests/2.24.0 CPython/3.8.5 Linux/5.15.0-87-generic ubuntu/22.04.3 glibc/2.35
                UID:GID : 6811:10086
             netrc file : None
           offline mode : False

(braker) kosukesano@at137:~$
```


**改めて`braker`インストールの前準備を行う**
```php
conda install -c anaconda perl
conda install -c anaconda biopython
conda install -c bioconda perl-app-cpanminus
conda install -c bioconda perl-file-spec
conda install -c bioconda perl-hash-merge
conda install -c bioconda perl-list-util
conda install -c bioconda perl-module-load-conditional
conda install -c bioconda perl-posix
conda install -c bioconda perl-file-homedir
conda install -c bioconda perl-parallel-forkmanager
conda install -c bioconda perl-scalar-util-numeric
conda install -c bioconda perl-yaml
conda install -c bioconda perl-class-data-inheritable
conda install -c bioconda perl-exception-class
conda install -c bioconda perl-test-pod
# なんか変な出力だったけど、多分うまくいってる
conda install -c bioconda perl-file-which # skip if you are not comparing to reference annotation
(braker) kosukesano@at137:~/tools$ conda install -c bioconda perl-file-which # skip if you are not comparing to reference annotation
Collecting package metadata (current_repodata.json): done
Solving environment: done


==> WARNING: A newer version of conda exists. <==
  current version: 4.9.2
  latest version: 24.4.0

Please update conda by running

    $ conda update -n base -c defaults conda



# All requested packages already installed.

(braker) kosukesano@at137:~/tools$ 

conda install -c bioconda perl-mce
conda install -c bioconda perl-threaded

conda install -c bioconda perl-list-util
(braker) kosukesano@at137:~/tools$ conda install -c bioconda perl-list-util
Collecting package metadata (current_repodata.json): done
Solving environment: done


==> WARNING: A newer version of conda exists. <==
  current version: 4.9.2
  latest version: 24.4.0

Please update conda by running

    $ conda update -n base -c defaults conda



# All requested packages already installed.

(braker) kosukesano@at137:~/tools$ 

conda install -c bioconda perl-math-utils
conda install -c bioconda cdbtools
conda install -c eumetsat perl-yaml-xs
conda install -c bioconda perl-data-dumper
```