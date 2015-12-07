;;; 03-util.el --- util                              -*- lexical-binding: t; -*-

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
(eval-when-compile
  (require 'evil))

(el-get-bundle which-key)
(use-package which-key
  :diminish which-key-mode
  :commands (which-key-mode)
  :init
  (setq which-key-use-C-h-for-paging nil)
  (setq which-key-idle-delay 0.3)
  (setq which-key-separator " - ")
  (setq which-key-show-prefix 'echo)
  (setq which-key-popup-type 'side-window)
  (setq which-key-side-window-location 'bottom)
  (setq which-key-side-window-max-height 0.50)
  (add-hook 'after-init-hook 'which-key-mode)
  :config
  ;; (which-key-add-key-based-replacements "SPC r" " Rest")
  (which-key-add-key-based-replacements "SPC a" " Ag")
  (which-key-add-key-based-replacements "SPC d" " Dash")
  (which-key-add-key-based-replacements "SPC f" " Find-File")
  (which-key-add-key-based-replacements "SPC h" " Helm")
  (which-key-add-key-based-replacements "SPC p" " Projectile")
  (which-key-add-key-based-replacements "SPC u" " Undo-Tree")
  (which-key-add-key-based-replacements "SPC b" " Buffers")
  (which-key-add-key-based-replacements "SPC e" " Errors")
  (which-key-add-key-based-replacements "SPC i" " Indent-Guides")
  (which-key-add-key-based-replacements "SPC t" " Tags, Transrate")
  (which-key-add-key-based-replacements "SPC w" " Windows")
  (which-key-add-key-based-replacements "SPC g" " Git")
  (which-key-add-key-based-replacements "SPC h g" " Helm-Github")
  (which-key-add-key-based-replacements ", h" " Help")
  (which-key-add-key-based-replacements "SPC m" " Memo, Message")
  (which-key-add-key-based-replacements "SPC m u" " slack-update")

  (which-key-add-major-mode-key-based-replacements 'emacs-lisp-mode
    ", e" " Eval")
  (which-key-add-major-mode-key-based-replacements 'enh-ruby-mode
    ", b" " Bundler"
    ", r" " Rails"
    ", g" " Goto"
    ", t" " Test, Tags"))

(el-get-bundle popwin)
(use-package popwin
  :commands (popwin-mode)
  :init
  (setq popwin:adjust-other-windows t)
  (setq popwin:popup-window-position 'bottom)
  (setq popwin:popup-window-height 0.3)
  (add-hook 'after-init-hook #'(lambda () (popwin-mode t)))
  :config
  (push '("^\\*git-gutter:.*\\*$") popwin:special-display-config)
  (push '(twittering-mode :stick t) popwin:special-display-config)
  (push '("*R*" :tail t :noselect t :stick t) popwin:special-display-config)
  (push '(comint-mode :tail t :noselect t :stick t) popwin:special-display-config)
  (push '(ensime-inspector-mode) popwin:special-display-config)
  (push '("*ensime-inferior-scala*" :tail t :noselect t :stick t) popwin:special-display-config)
  (push '(sbt-mode :tail t :noselect t) popwin:special-display-config)
  (push '("*ensime-update*" :tail t) popwin:special-display-config)
  (push '("*HTTP Response*" :noselect t :stick t) popwin:special-display-config)
  (push '("*quickrun*" :tail t :stick t) popwin:special-display-config)
  (push '(inferior-python-mode :tail t :stick t) popwin:special-display-config)
  (push '(cider-inspector-mode) popwin:special-display-config)
  (push '(cider-popup-buffer-mode) popwin:special-display-config)
  (push '("*cider grimoire*") popwin:special-display-config)
  (push '("*cider-error*") popwin:special-display-config)
  (push '("*cider-result*") popwin:special-display-config)
  (push '(cider-repl-mode :tail t :stick t) popwin:special-display-config)
  (push '("*Backtrace*") popwin:special-display-config)
  (push '("*Messages*") popwin:special-display-config)
  (push '(slack-edit-message-mode) popwin:special-display-config)
  (push '(slack-mode :height 0.25 :noselect t :stick t :tail t :regexp t)
        popwin:special-display-config)
  (push '("*Bundler*" :noselect t) popwin:special-display-config)
  (push '(inf-ruby-mode :stick t) popwin:special-display-config)
  (push '("*Process List*" :noselect t) popwin:special-display-config)
  (push '("*Warnings*" :noselect t) popwin:special-display-config)
  (push '("*Flycheck errors*" :stick t :noselect t) popwin:special-display-config)
  (push '("*compilation*" :stick t :tail t :noselect t)
        popwin:special-display-config)
  (push '("*Codic Result*" :noselect t :stick t) popwin:special-display-config)
  (push "*slime-apropos*" popwin:special-display-config)
  (push '("*slime-macroexpansion*" :noselect t) popwin:special-display-config)
  (push "*slime-description*" popwin:special-display-config)
  (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
  (push "*slime-xref*" popwin:special-display-config)
  (push '("*inferior-lisp*" :noselect t :tail t :stick t) popwin:special-display-config)
  (push '(sldb-mode :stick t) popwin:special-display-config)
  (push '(slime-repl-mode :stick t :position bottom) popwin:special-display-config)
  (push 'slime-connection-list-mode popwin:special-display-config)
  (push '("*alchemist-eval-mode*" :noselect t :height 0.2) popwin:special-display-config)
  (push '("*Alchemist-IEx*" :noselect t :height 0.2) popwin:special-display-config)
  (push '("*alchemist help*" :noselect t) popwin:special-display-config)
  (push '("*elixirc*" :noselect t) popwin:special-display-config))

(el-get-bundle indent-guide)
(use-package indent-guide
  :diminish indent-guide-mode
  :commands (indent-guide-mode)
  :init
  (setq indent-guide-recursive t)
  (add-hook 'lisp-mode-hook 'indent-guide-mode))

(el-get-bundle golden-ratio)
(use-package golden-ratio
  :commands (golden-ratio-mode)
  :diminish golden-ratio-mode
  :init
  (setq golden-ratio-exclude-modes '("bs-mode"
                                     "calc-mode"
                                     "ediff-mode"
                                     "dired-mode"
                                     "comint-mode"
                                     "slime-repl-mode"))
  (setq golden-ratio-exclude-buffer-names '("*compilation*"
                                            "*which-key*"
                                            "*Flycheck errors*"
                                            "slime-apropos*"
                                            "*slime-description*"
                                            "*slime-compilation*"
                                            "*Proccess List*"
                                            "*Help*"
                                            "*LV*"
                                            "*Warnings*"))
  (setq golden-ratio-auto-scale t))

(el-get-bundle google-translate)
(use-package google-translate
  :commands (google-translate-at-point
             google-translate-query-translate
             google-translate-query-translate-reverse)
  :config
  (setq google-translate-default-source-language "en"
        google-translate-default-target-language "ja"))

(el-get-bundle syohex/emacs-codic)
(use-package codic
  :commands (codic codic-translate))

(el-get-bundle quickrun)
(use-package quickrun
  :commands (quickrun
             quickrun-region
             quickrun-with-arg
             quickrun-shell)
  :init
  (setq quickrun-focus-p nil))

(el-get-bundle restclient)
(use-package restclient
  :commands (restclient-mode)
  :init
  (setq restclient-client-buf-name "*RestClient - Client*")
  :config
  (defun create-restclient-buffer ()
    (interactive)
    (let ((buf (get-buffer-create restclient-client-buf-name)))
      (switch-to-buffer-other-window buf)
      (with-current-buffer (restclient-mode))))
  (evil-define-key 'normal restclient-mode-map
    ",y"  'restclient-copy-curl-command
    ",ss" 'restclient-http-send-current
    ",sr" 'restclient-http-send-current-raw
    ",sv" 'restclient-http-send-current-stay-in-window
    ",n"  'restclient-jump-next
    ",p"  'restclient-jump-prev
    ",m"  'restclient-mark-current))

;; esup
(el-get-bundle esup)
(use-package esup
  :commands (esup))

;; auto-save
(el-get-bundle auto-save-buffers-enhanced)
(use-package auto-save-buffers-enhanced
  :init
  (setq make-backup-files nil)
  (setq auto-save-list-file-prefix nil)
  (setq create-lockfiles nil)
  (setq auto-save-buffers-enhanced-interval 0.5)
  (setq auto-save-buffers-enhanced-quiet-save-p t)
  :config
  (defun auto-save-buffers-enhanced-save-buffers-if-normal-state ()
    (if (eq evil-state 'normal)
        (auto-save-buffers-enhanced-save-buffers)))
  (defun auto-save-buffers-enhanced (flag)
    (when flag
      (run-with-idle-timer
       auto-save-buffers-enhanced-interval t
       'auto-save-buffers-enhanced-save-buffers-if-normal-state)))
  (auto-save-buffers-enhanced t))
(use-package server
  :commands (server-start)
  :config
  (defun start-server ()
    (unless (server-running-p)
      (server-start)))
  (add-hook 'after-init-hook 'start-server))

(el-get-bundle ddskk)
(use-package skk
  :commands (skk-mode skk-auto-fill-mode)
  :init
  (setq skk-tut-file (concat user-emacs-directory
                             "el-get/ddskk/etc/SKK.tut"))
  (setq define-input-method "japanese-skk")
  (add-hook 'skk-mode-hook 'skk-auto-fill-mode)
  :config
  (use-package skk-tut)
  (use-package skk-cus)
  (use-package skk-cursor)
  (use-package skk-study))

(provide '03-util)
;;; 03-util.el ends here
