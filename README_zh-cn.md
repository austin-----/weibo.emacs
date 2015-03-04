# Emacs 微博客户端 [![MELPA](http://melpa.org/packages/weibo-badge.svg)](http://melpa.org/#/weibo)

## 安装

从 [MELPA](http://melpa.org/) 安装:

    M-x package-install RET weibo RET

## Setup

你需要自己申请一个 Weibo App（参考 issue [#35](https://github.com/austin-----/weibo.emacs/issues/35) 和 [#36](https://github.com/austin-----/weibo.emacs/issues/36)）并把 `weibo-consumer-key`/`weibo-consumer-secret` 改成你的。

下面是一个示例 Setup（加到你的`~/.emacs.d/init.el`）：

```lisp
(require 'weibo)
(setq weibo-consumer-key "214135744"
      weibo-consumer-secret "1e0487b02bae1e0df794ebb665d12cf6")
```

## 使用

    M-x weibo-timeline RET

*注意* 第一次运行该指令会使用浏览器授权。

## 定制

    M-x customize-group RET weibo RET
