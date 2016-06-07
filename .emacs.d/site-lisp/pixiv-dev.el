;;; pixiv-dev --- p(ixi)v -*- coding: utf-8 ; lexical-binding: t -*-

;; Copyright (C) 2016 USAMI Kenta

;; Author: USAMI Kenta <tadsan@zonu.me>
;; Created: 2016-04-01
;; Modified: 2016-04-07
;; Version: 0.4.0
;; Keywords: php
;; URL: https://github.com/zonuexe/dotfiles/tree/master/.emacs.d/site-lisp

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Code:
(require 'psysh nil t)
(require 'flycheck)

(defgroup pixiv-dev '()
  "Develop pixiv.net and other services."
  :group 'programming)

(defcustom pixiv-dev-user-name user-login-name
  "Login name for pixiv-dev(LDAP) or E-mail address.")

(defcustom pixiv-dev-host "pixiv-dev"
  "Host name of your pixiv develop server.")

(defcustom pixiv-dev-working-dir nil
  "`pixiv.git' working directory.")

(defvar pixiv-dev-repository-web "http://gitlab.pixiv.private/pixiv/pixiv"
  "URL of `pixiv.git' repository web.")

(defun pixiv-dev--working-dir ()
  "Wokring directory of `pixiv.git'."
  (or pixiv-dev-working-dir
      (format "/scp:%s:/mnt/ssd1/home/%s/pixiv/" pixiv-dev-host pixiv-dev-user-name)))

;;;###autoload
(flycheck-define-checker pixiv-dev-lint
  "JSON Syntax check using Python json"
  :command ("~/pixiv/dev-script/lint" source)
  :error-patterns
  (;; file:pixiv-lib/Novel/Body.php line:53 desc:${val} 形式の変数埋め込みは使用禁止 ( {$val} 形式を利用)
   (error line-start "file:" (file-name)
          "	line:" line
          "	col:" column "-"
          "	desc:" (message)
          line-end)
   )
  :mode '(php-mode web-mode))
;; (flycheck-select-checker 'pixiv-dev-lint)
;; flycheck-pixiv-dev-lint-executable

;;;###autoload
(defun pixiv-dev-copy-file-url ()
  "Copy pixiv repository file URL."
  (interactive)
  (let (path (working-dir (pixiv-dev--working-dir)))
    (if (or (null buffer-file-name)
            (not (string-prefix-p working-dir buffer-file-name)))
        (error "File is not in pixiv repository!")
      (setq path (concat pixiv-dev-repository-web "/tree/master/"
                         (replace-regexp-in-string working-dir "" buffer-file-name)))
      (kill-new path)
      (message (format "Copy `%s'!" path)))))

;;;###autoload
(defun pixiv-dev-find-file ()
  "Find file in pixiv working directory."
  (interactive)
  (let ((default-directory (pixiv-dev--working-dir)))
    (call-interactively 'find-file nil)))

;;;###autoload
(defun pixiv-dev-shell ()
  "Run PHP interactive shell for pixiv."
  (interactive)
  (let ((current-dir default-directory)
        (buffer      nil))
    (cd (pixiv-dev--working-dir))
    (setq buffer (make-comint "pixiv-shell" "dev-script/shell.php"))
    (cd current-dir)
    (switch-to-buffer buffer))
  (when (fboundp 'psysh-mode)
    (psysh-mode)))

(provide 'pixiv-dev)
;;; pixiv-dev.el ends here
