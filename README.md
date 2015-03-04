# A Weibo client for Emacs [![MELPA](http://melpa.org/packages/weibo-badge.svg)](http://melpa.org/#/weibo)

## Installation

Install from [MELPA](http://melpa.org/) with:

    M-x package-install RET weibo RET

## Setup

Nowadays, you must apply a Weibo app yourself to use this package (see
issue [#35](https://github.com/austin-----/weibo.emacs/issues/35) and
[#36](https://github.com/austin-----/weibo.emacs/issues/36)) and
change `weibo-consumer-key`/`weibo-consumer-secret` to yours.

Here is a sample setup (add to your `~/.emacs.d/init.el`):

```lisp
(require 'weibo)
(setq weibo-consumer-key "214135744"
      weibo-consumer-secret "1e0487b02bae1e0df794ebb665d12cf6")
```

## Usage

    M-x weibo-timeline RET

*Note* if you invoke this command for the first time, authorization
 within Web Browse will be processed.

## Customization

    M-x customize-group RET weibo RET
