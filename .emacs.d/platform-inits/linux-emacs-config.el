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
(setq x-select-enable-clipboard t)
(setq x-select-enable-primary t)

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

;; [[Home] Copy And Paste](https://www.emacswiki.org/emacs/CopyAndPaste)
;; credit: yorickvP on Github
(when (string-match-p "--with-pgtk" system-configuration-options)
  (setq wl-copy-process nil)
  (defun wl-copy (text)
    (setq wl-copy-process (make-process :name "wl-copy"
                                        :buffer nil
                                        :command '("wl-copy" "-f" "-n")
                                        :connection-type 'pipe))
    (process-send-string wl-copy-process text)
    (process-send-eof wl-copy-process))
  (defun wl-paste ()
    (if (and wl-copy-process (process-live-p wl-copy-process))
        nil ; should return nil if we're the current paste owner
      (shell-command-to-string "wl-paste -n | tr -d \r")))
  (setq interprogram-cut-function 'wl-copy)
  (setq interprogram-paste-function 'wl-paste))

(el-get-bundle migemo)
(use-package migemo
  :commands (migemo-init)
  :init
  (setq migemo-options '("--quiet" "--emacs"))
  (setq migemo-command "cmigemo")
  (setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (add-hook 'after-init-hook 'migemo-init))

(el-get-bundle exec-path-from-shell)
(use-package exec-path-from-shell
  ;; :commands (exec-path-from-shell-initialize)
  :init
  ;; (add-hook 'before-init-hook 'exec-path-from-shell-initialize)
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
  ;; (exec-path-from-shell-copy-env "SSH_AUTH_SOCK")
  )

(provide 'linux-emacs-config)
;;; linux-emacs-config.el ends here
