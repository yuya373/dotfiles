;;; linux-emacs-config.el ---                        -*- lexical-binding: t; -*-

;; Copyright (C) 2017

;; Author:  <yuya373@yuya373>
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
(setq ring-bell-function 'ignore)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; (el-get-bundle xclip)
;; (use-package xclip
;;   :commands (turn-on-xclip)
;;   :init
;;   (setq xclip-select-enable-clipboard t)
;;   (add-hook 'after-init-hook 'turn-on-xclip))

;; [Emacs in WSL and opening links · Various Musings](https://adam.kruszewski.name/2017/09/emacs-in-wsl-and-opening-links/)
(let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
      (cmd-args '("/c" "start")))
  (when (file-exists-p cmd-exe)
    (setq browse-url-generic-program  cmd-exe
          browse-url-generic-args     cmd-args
          browse-url-browser-function 'browse-url-generic)))

(use-package migemo
  :ensure t
  :commands (migemo-init)
  :init
  (setq migemo-options '("--quiet" "--emacs"))
  (setq migemo-command "cmigemo")
  (setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (add-hook 'after-init-hook 'migemo-init))

(use-package exec-path-from-shell
  :ensure t
  :init
  (setq exec-path-from-shell-arguments '("-l"))
  (setq exec-path-from-shell-variables
        '("PATH"
          "MANPATH"
          "LANG"
          "JAVA_HOME"
          "NODE_PATH"
          "SSH_AUTH_SOCK"
          ))
  :config
  (exec-path-from-shell-initialize)
  )

(provide 'linux-emacs-config)
;;; linux-emacs-config.el ends here
