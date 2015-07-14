(add-to-list 'load-path "~/.emacs.d/private/initchart")
(require 'initchart)
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

;; config
(setq gc-cons-threshold 128 * 1024 * 1024 * 1024)
(set-language-environment 'utf-8)
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

;; self hosting el-get
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; use use-package for config description
(setq el-get-generate-autoloads nil)
(setq el-get-is-lazy t)
;; for debug
(setq el-get-verbose t)

(el-get-bundle diminish)
(el-get-bundle bind-key)
(el-get-bundle use-package
  (setq use-package-verbose t))
(require 'use-package)
(require 'diminish)
(require 'bind-key)
;; evil
(el-get-bundle evil)
(el-get-bundle evil-leader)
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
(el-get-bundle smartparens)
(use-package smartparens
  :defer t
  :init
  (use-package smartparens-config)
  :config
  (smartparens-global-mode)
  (show-smartparens-global-mode))
(el-get-bundle evil-lisp-state
  :depends (smartparens))
(use-package evil-lisp-state
  :config
  (add-to-list 'evil-lisp-state-major-modes 'lisp-mode))
(el-get-bundle evil-matchit)
(use-package evil-matchit
  :config
  (global-evil-matchit-mode t))
(el-get-bundle evil-nerd-commenter)
(use-package evil-nerd-commenter
  :commands (evilnc-comment-or-uncomment-lines)
  :init
  (define-key evil-normal-state-map (kbd ",,") 'evilnc-comment-or-uncomment-lines)
  (define-key evil-visual-state-map (kbd ",,") 'evilnc-comment-or-uncomment-lines))
(el-get-bundle evil-numbers)
(use-package evil-numbers
  :commands (evil-numbers/inc-at-pt
             evil-numbers/dec-at-pt)
  :init
  (define-key evil-normal-state-map (kbd "+") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map (kbd "-") 'evil-numbers/dec-at-pt))

(el-get-bundle evil-search-highlight-persist
  :depends (highlight))
(use-package evil-search-highlight-persit
  :commands (global-evil-search-highlight-persist)
  :init
  (use-package highlight)
  :config
  (global-evil-search-highlight-persist))
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
  (setq guide-key/guide-key-sequence '("\\" "," "<SPC>"))
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

;; git
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
(el-get-bundle gist)
(use-package gist
  :commands (gist-list gist-region gist-region-private
                      gist-buffer gist-buffer-private))
(el-get-bundle smeargle)
(use-package smeargle
  :commands (smeargle smeargle-commits smeargle-clear))

;; projectile
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

;; syntax check
(el-get-bundle flycheck)
(el-get-bundle flycheck-pos-tip)
(use-package flycheck
  :commands (global-flycheck-mode)
  :init
  (add-hook 'after-init-hook 'global-flycheck-mode)
  :config
  (use-package flycheck-pos-tip
    :commands (flycheck-pos-tip-error-messages)
    :init
    ;; (custom-set-variables
    ;;  '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))
    ))

;; markdown
(el-get-bundle markdown-mode)
(el-get-bundle markdown-toc)
(use-package markdown-mode
  :mode (("\\.markdown\\'" . markdown-mode)
         ("\\.md\\'" . markdown-mode)))

;; ruby
(el-get-bundle bundler)
(el-get-bundle rbenv)
(el-get-bundle robe)
(el-get-bundle enh-ruby-mode)
(el-get-bundle ruby-test-mode)
(use-package bundler
  :commands (bundle-open bundle-exec bundle-check bundle-gemfile
                         bundle-update bundle-console bundle-install))
(use-package rbenv
  :commands (global-rbenv-mode)
  :init
  (add-hook 'ruby-mode-hook 'global-rbenv-mode))
(use-package robe
  :commands (robe-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (add-hook 'robe-mode 'ac-robe-setup))
(use-package enh-ruby-mode
  :mode ("\\.rb\\'" . enh-ruby-mode)
  :interpreter ("ruby" . enh-ruby-mode))

;; html, erb
(el-get-bundle web-mode)
(use-package web-mode
  :mode (("\\.erb\\'" . web-mode)
         ("\\.html?\\'" . web-mode)))

;; shell
(use-package eshell
  :commands (eshell)
  :config
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-cmpl-cycle-completions nil)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-save-history-on-exit t))
(el-get-bundle exec-path-from-shell)
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))
(el-get-bundle shell-pop)
(use-package shell-pop
  :commands (shell-pop)
  :init
  (define-key evil-normal-state-map (kbd "<SPC>s") 'shell-pop)
  :config
  (setq shell-pop-internal-mode "eshell")
  (setq shell-pop-internal-mode-shell "eshell")
  (setq shell-pop-internal-mode-func (lambda nil (eshell)))
  (setq shell-pop-internal-mode-buffer "*eshell*"))

;; helm
(el-get-bundle async)
(el-get-bundle helm)
(use-package helm-config
  :config
  (helm-mode t)
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  ;; (setq 'helm-buffers-fuzzy-matching t)
  ;; (setq 'helm-recentf-fuzzy-match t)
  (setq helm-autoresize-mode t)
  (define-key evil-normal-state-map (kbd "<SPC>hb") 'helm-buffer-list)
  (define-kdy evil-normal-state-map (kbd "<SPC>hr") 'helm-recentf)
  (define-key evil-normal-state-map (kbd "<SPC>hp") 'helm-projectile)
  (define-key evil-normal-state-map (kbd "<SPC>hf") 'helm-for-files)
  (define-key evil-normal-state-map (kbd "<SPC>hg") 'helm-ag))
