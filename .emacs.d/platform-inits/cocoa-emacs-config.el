;;; cocoa-emacs-config.el ---                        -*- lexical-binding: t; -*-

;; Copyright (C) 2015  南優也

;; Author: 南優也 <yuyaminami@minamiyuunari-no-MacBook-Pro.local>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(when window-system
  (setq ring-bell-function 'ignore)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  ;; (el-get-bundle flycheck-pos-tip)
  ;; (use-package flycheck-pos-tip
  ;;   :commands (flycheck-pos-tip-mode)
  ;;   :init
  ;;   (add-hook 'flycheck-mode-hook 'flycheck-pos-tip-mode))
  )

(el-get-bundle emacschrome)
(use-package edit-server
  :commands (edit-server-start)
  :init
  (add-hook 'evil-mode-hook 'edit-server-start)
  (setq edit-server-new-frame nil)
  :config
  (evil-define-key 'normal edit-server-text-mode-map
    ",k" 'edit-server-abort
    ",c" 'edit-server-done))

(use-package ls-lisp
  :defer t
  :init
  (setq ls-lisp-use-insert-directory-program nil))

(el-get-bundle exec-path-from-shell)
(use-package exec-path-from-shell
  ;; :commands (exec-path-from-shell-initialize)
  :init
  ;; (add-hook 'before-init-hook 'exec-path-from-shell-initialize)
  (setq exec-path-from-shell-arguments '("-l"))
  (setq exec-path-from-shell-variables '("PATH" "MANPATH" "LANG" "JAVA_HOME" "NODE_PATH" "GOPATH"))
  :config
  (setenv "SHELL" "/usr/local/bin/zsh")
  (setenv "PKG_CONFIG_PATH" "/usr/local/opt/zlib/lib/pkgconfig:/usr/local/opt/libffi/lib/pkgconfig:/usr/local/lib/pkgconfig")
  (exec-path-from-shell-initialize))

(el-get-bundle migemo)
(use-package migemo
  :commands (migemo-init)
  :init
  (setq migemo-command "cmigemo")
  (setq migemo-options '("-q" "--emacs"))
  ;; Set your installed path
  (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (add-hook 'after-init-hook 'migemo-init))

(setq woman-manpath '("/usr/local/share/man/ja_JP.UTF-8/"
                      "/usr/local/opt/coreutils/libexec/gnuman/"))

(provide 'cocoa-emacs-config)
;;; cocoa-emacs-config.el ends here
