;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

(add-to-list 'load-path "~/.emacs.d/private/initchart")
(require 'initchart)
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

;; config
(setq gc-cons-threshold 134217728)
(prefer-coding-system 'utf-8)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (tooltip-mode -1)
;; (setq tooltip-use-echo-area t)
(unless (eq window-system 'mac)
  (menu-bar-mode -1))
(setq linum-format "%4d ")
(global-linum-mode t)
(setq ad-redefinition-action 'accept)
(keyboard-translate ?\C-h ?\C-?)
(setq auto-save-timeout 1
      auto-save-interval 1)
(setq-default tab-width 2
              tab-always-indent t
              indent-tabs-mode nil)
(add-to-list 'auto-mode-alist '("\\.schema$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("PULLREQ_MSG" . markdown-mode))
(auto-insert-mode)
(setq auto-insert-directory "~/dotfiles/vim/template")
(define-auto-insert "PULLREQ_MSG" "PULLREQ_MSG")

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))
(setq el-get-generate-autoloads nil)
(setq el-get-verbose t)

(el-get-bundle diminish :lazy t)
(el-get-bundle bind-key :lazy t)
(el-get-bundle use-package
  :features (use-package diminish bind-key)
  (setq use-package-verbose t))
;; evil
(el-get-bundle evil :lazy t)
(el-get-bundle evil-leader :lazy t)
(use-package evil
  :init
  (setq evil-want-C-i-jump t)
  (setq evil-want-C-u-scroll t)
  :config
  (use-package evil-leader
    :config
    (global-evil-leader-mode))
  (evil-mode t))
(el-get-bundle evil-jumper)
(use-package evil-jumper
  :config
  (evil-jumper-mode))
(el-get-bundle evil-lisp-state
  :depends (smartparens))
(use-package evil-lisp-state
  :init
  (use-package smartparens)
  :config
  (add-to-list 'evil-lisp-state-major-modes 'lisp-mode))
(el-get-bundle evil-matchit)
(use-package evil-matchit
  :config
  (global-evil-matchit-mode t))
(el-get-bundle evil-nerd-commenter
  (define-key evil-normal-state-map (kbd ",,") 'evilnc-comment-or-uncomment-lines))
(use-package evil-nerd-commenter
  :commands (evilnc-comment-or-uncomment-lines)
  :init
  (define-key evil-normal-state-map (kbd ",,") 'evilnc-comment-or-uncomment-lines))
(el-get-bundle evil-numbers)
(use-package evil-numbers
  :commands (evil-numbers/inc-at-pt
             evil-numbers/dec-at-pt)
  :init
  (define-key evil-normal-state-map (kbd "+") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "-") 'evil-numbers/dec-at-pt))

(el-get-bundle juanjux/evil-search-highlight-persist
  :depends (highlight))
(use-package evil-search-highlight-persit
  :init
  (use-package highlight)
  :config
  (global-evil-search-highlight-persist t))
(el-get-bundle evil-surround)
(use-package evil-surround
  :config
  (global-evil-surround-mode t))
(el-get-bundle evil-terminal-cursor-changer)
(use-package evil-terminal-cursor-changer)
(el-get-bundle evil-visualstar)
(use-package evil-visualstar
  :config
  (global-evil-visualstar-mode))
;; guide-key
(el-get-bundle guide-key)
(use-package guide-key
  :init
  (setq guide-key/idle-delay 0.4)
  (setq guide-key/recursive-key-sequence-flag t)
  (setq guide-key/guide-key-sequence '("\\" ","))
  :config
  (guide-key-mode 1))

(el-get-bundle rainbow-delimiters)
(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode)
  :init
  ;;(add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
  (add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode))

(el-get-bundle auto-complete)
(use-package auto-complete
  :init
  (setq ac-auto-start 0
        ac-delay 0.2
        ac-quick-help-delay 1.
        ac-use-fuzzy t
        ac-fuzzy-enable t
        tab-always-indent 'complete
        ac-dwim t)
  :config
  (ac-set-trigger-key "TAB")
  (use-package auto-complete-config
    :config
    (ac-config-default)))

(use-package eldoc
  :init
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode))

(el-get-bundle magit)
(el-get-bundle magit-gh-pulls)
(use-package magit
  :commands (magit-status)
  :init
  (evil-leader/set-key "gb" 'magit-blame)
  (evil-leader/set-key "gs" 'magit-status)
  :config
  (use-package ert)
  (use-package magit-gh-pulls
    :commands (turn-on-magit-gh-pulls)
    :init
    (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls)
    ))
(el-get-bundle projectile
  :depends (grizzl))
(use-package projectile
  :commands (projectile-mode)
  :init
  (setq projectile-completion-system 'grizzl)
  :config
  (add-hook 'ruby-mode-hook 'projectile-mode)
  (use-package grizzl))
(el-get-bundle projectile-rails)
(use-package projectile-rails
  :commands (projectile-rails-on)
  :init
  (add-hook 'projectile-mode-hook 'projectile-rails-on))

                                        ; (defconst spacemacs-version          "0.103.2" "Spacemacs version.")
                                        ; (defconst spacemacs-emacs-min-version   "24.3" "Minimal version of Emacs.")
                                        ;
                                        ; (defun spacemacs/emacs-version-ok ()
                                        ;   (version<= spacemacs-emacs-min-version emacs-version))
                                        ;
                                        ; (when (spacemacs/emacs-version-ok)
                                        ;   (load-file (concat user-emacs-directory "core/core-load-paths.el"))
                                        ;   (require 'core-spacemacs)
                                        ;   (require 'core-configuration-layer)
                                        ;   (spacemacs/init)
                                        ;   (configuration-layer/sync)
                                        ;   (spacemacs/setup-after-init-hook)
                                        ;   (spacemacs/maybe-install-dotfile)
                                        ;   (require 'server)
                                        ;   (unless (server-running-p) (server-start)))
