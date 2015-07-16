;;; init.el --- init.el
;;; Commentary:
;;; Code:


;; config
(add-to-list 'default-frame-alist '(font . "Ricty for Powerline-17"))
(setq gc-cons-threshold (* 128 1024 1024))
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq require-final-newline t)
(modify-syntax-entry ?_ "w" (standard-syntax-table))
;; (tooltip-mode -1)
;; (setq tooltip-use-echo-area t)
(unless (eq window-system 'mac)
  (menu-bar-mode -1))

;; dired
(setq dired-use-ls-dired t)

;; linum
(setq linum-format "%4d ")
(global-linum-mode t)
(setq ad-redefinition-action 'accept)

;; tab
(setq-default tab-width 2
              indent-tabs-mode nil)
;; auto-insert
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
(setq el-get-use-autoloads nil)
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

;; whitespace
(use-package whitespace
  :config
  (setq whitespace-style '(face
                           trailing
                           tabs
                           spaces
                           empty
                           space-mark
                           tab-mark))
  ;; (setq whitespace-action '(auto-cleanup))
  (global-whitespace-mode))

;; initchart
(el-get-bundle yuttie/initchart)
(use-package initchart
  :commands (initchart-record-execution-time-of))
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

;; eww
(use-package eww
             :commands (eww)
             :init
             (setq eww-search-prefix "http://www.google.co.jp/search?q="))

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
  :config
  (auto-save-buffers-enhanced t))

;; theme
(el-get-bundle color-theme-solarized)
(add-to-list 'custom-theme-load-path default-directory)
(set-frame-parameter nil 'background-mode 'dark)
(set-terminal-parameter nil 'background-mode 'dark)
(load-theme 'solarized t)

;; smartparens
(el-get-bundle smartparens)
(use-package smartparens
  :defer t
  :init
  (use-package smartparens-config
    :defer t)
  :config
  (smartparens-global-mode)
  (show-smartparens-global-mode))

;; evil
(el-get-bundle evil)
(el-get-bundle evil-leader)
(el-get-bundle anzu)
(el-get-bundle evil-anzu)
(el-get-bundle evil-args)
(el-get-bundle evil-jumper)
(el-get-bundle evil-lisp-state)
(el-get-bundle evil-matchit)
(el-get-bundle evil-nerd-commenter)
(el-get-bundle evil-numbers)
(el-get-bundle highlight)
(el-get-bundle evil-search-highlight-persist)
(el-get-bundle evil-surround)
(el-get-bundle evil-terminal-cursor-changer)
(el-get-bundle evil-visualstar)

(use-package evil
  :init
  (setq evil-fold-level 4)
  (setq evil-search-module 'evil-search)
  (setq evil-esc-delay 0)
  (setq evil-want-C-i-jump t)
  (setq evil-want-C-u-scroll t)
  :config
  (use-package evil-leader :config (global-evil-leader-mode))
  ;; init evil-mode
  (evil-mode t)
  (use-package evil-lisp-state
    :init
    (defun evil-lisp-state-lisp-mode-hook ()
      (require 'evil-lisp-state)
      (add-to-list 'evil-lisp-state-major-modes 'lisp-mode))
    (add-hook 'lisp-mode-hook 'evil-lisp-state-lisp-mode-hook)

    (defun evil-lisp-state-emacs-lisp-mode-hook ()
      (require 'evil-lisp-state))
    (add-hook 'emacs-lisp-mode-hook 'evil-lisp-state-emacs-lisp-mode-hook))
  (use-package evil-visualstar :config (global-evil-visualstar-mode))
  (use-package evil-terminal-cursor-changer)
  (use-package evil-surround :config (global-evil-surround-mode t))
  (use-package evil-search-highlight-persist :config (global-evil-search-highlight-persist))
  (use-package evil-numbers
    :commands (evil-numbers/inc-at-pt evil-numbers/dec-at-pt)
    :init
    (define-key evil-normal-state-map (kbd "+") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map (kbd "-") 'evil-numbers/dec-at-pt))
  (use-package evil-nerd-commenter
    :commands (evilnc-comment-or-uncomment-lines)
    :init
    (define-key evil-normal-state-map (kbd ",,") 'evilnc-comment-or-uncomment-lines)
    (define-key evil-visual-state-map (kbd ",,") 'evilnc-comment-or-uncomment-lines))
  (use-package evil-matchit :config (global-evil-matchit-mode t))
  (use-package evil-anzu)
  (use-package evil-jumper :config (evil-jumper-mode))
  (use-package evil-args
    :commands (evil-inner-arg evil-outer-arg)
    :init
    (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
    (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))
  (define-key evil-insert-state-map (kbd "C-h") 'delete-backward-char)
  (define-key evil-ex-search-keymap (kbd "C-h") 'delete-backward-char)
  (define-key evil-ex-completion-map (kbd "C-h") 'delete-backward-char)
  ;; window move
  (define-key evil-normal-state-map (kbd "C-k") 'windmove-up)
  (define-key evil-normal-state-map (kbd "C-j") 'windmove-down)
  (define-key evil-normal-state-map (kbd "C-h") 'windmove-left)
  (define-key evil-normal-state-map (kbd "C-l") 'windmove-right)
  (define-key evil-normal-state-map (kbd "C-c") 'evil-window-delete)
  (define-key evil-normal-state-map (kbd ",hf") 'describe-function)
  (define-key evil-normal-state-map (kbd ",hv") 'describe-variable)
  (define-key evil-normal-state-map (kbd ",hs") 'describe-syntax)
  (define-key evil-normal-state-map (kbd ",hp") 'describe-package)
  (evil-set-initial-state 'comint-mode 'normal)
  (evil-define-key 'normal comint-mode-map (kbd "C-d") 'evil-scroll-down)
  (evil-define-key 'normal comint-mode-map (kbd "C-c") 'evil-window-delete)
  (custom-set-variables '(evil-shift-width 2))
  (defun evil-swap-key (map key1 key2)
    ;; MAP中のKEY1とKEY2を入れ替え
    "Swap KEY1 and KEY2 in MAP."
    (let ((def1 (lookup-key map key1))
          (def2 (lookup-key map key2)))
      (define-key map key1 def2)
      (define-key map key2 def1)))
  (evil-swap-key evil-motion-state-map "j" "gj")
  (evil-swap-key evil-motion-state-map "k" "gk"))

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
  (setq ac-auto-start 2
        ac-delay 0
        ac-quick-help-delay 0.5
        ac-use-fuzzy t
        ac-fuzzy-enable t
        ac-show-menu-immediately-on-auto-complete t)
  (setq-default ac-sources '(ac-source-filename ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
  (add-hook 'enh-ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-abbrev)))
  :config
  (use-package auto-complete-config :config (ac-config-default))
  (global-auto-complete-mode t)
  (define-key ac-completing-map (kbd "C-n") 'ac-next)
  (define-key ac-completing-map (kbd "C-p") 'ac-previous)
  (ac-set-trigger-key "TAB"))

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
  (evil-leader/set-key "gg" 'magit-status)
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
(el-get-bundle grizzl)
(el-get-bundle projectile)
(use-package projectile
  :commands (projectile-mode)
  :init
  (setq projectile-completion-system 'grizzl)
  (add-hook 'enh-ruby-mode-hook 'projectile-mode)
  :config
  (use-package grizzl))

;; rails
(el-get-bundle evil-rails)
(el-get-bundle projectile-rails)
(use-package projectile-rails
  :commands (projectile-rails-on)
  :init
  (define-key evil-normal-state-map (kbd ",rm") 'projectile-rails-find-model)
  (define-key evil-normal-state-map (kbd ",rc") 'projectile-rails-find-controller)
  (define-key evil-normal-state-map (kbd ",rv") 'projectile-rails-find-view)
  (define-key evil-normal-state-map (kbd ",rs") 'projectile-rails-find-spec)
  (define-key evil-normal-state-map (kbd ",rl") 'projectile-rails-find-lib)
  (define-key evil-normal-state-map (kbd "gf") 'projectile-rails-goto-file-at-point)
  (add-hook 'projectile-mode-hook 'projectile-rails-on)
  :config
  (use-package evil-rails))

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
         ("\\.md\\'" . markdown-mode)
         ("PULLREQ_MSG" . markdown-mode)))

;; ruby
(setq ruby-insert-encoding-magic-comment nil)
(el-get-bundle bundler)
(el-get-bundle rbenv)
(el-get-bundle robe)
(el-get-bundle inf-ruby)
(el-get-bundle enh-ruby-mode)
(el-get-bundle ruby-test-mode)
(el-get-bundle elpa:ruby-electric)
(use-package bundler
  :commands (bundle-open bundle-exec bundle-check bundle-gemfile
                         bundle-update bundle-console bundle-install))
(use-package rbenv
  :commands (global-rbenv-mode)
  :init
  (global-rbenv-mode)
  (add-hook 'enh-ruby-mode-hook (lambda () (rbenv-use-corresponding))))
(use-package inf-ruby
  :commands (inf-ruby inf-ruby-minor-mode inf-ruby-console-auto)
  :init
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode))
(use-package ac-robe
  :commands (ac-robe-setup)
  :init
  (add-hook 'robe-mode-hook 'ac-robe-setup))
(use-package robe
  :commands (robe-mode robe-start)
  :init
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (add-hook 'robe-mode-hook 'robe-start)
  (add-hook 'robe-mode-hook 'ac-robe-setup)
  )
(use-package enh-ruby-mode
  :mode (("\\(Rake\\|Thor\\|Guard\\|Gem\\|Cap\\|Vagrant\\|Berks\\|Pod\\|Puppet\\)file\\'" . enh-ruby-mode)
         ("\\.\\(rb\\|rabl\\|ru\\|builder\\|rake\\|thor\\|gemspec\\|jbuilder\\|schema\\)\\'" . enh-ruby-mode)
         ("Schema" . enh-ruby-mode))
  :interpreter ("ruby" . enh-ruby-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'auto-complete-mode)
  :config
  (setq enh-ruby-add-encoding-comment-on-save nil))
(use-package ruby-test-mode
  :commands (ruby-test-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'ruby-test-mode)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tt") 'ruby-test-run-at-point)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tb") 'ruby-test-run))

(use-package ruby-electric
  :init
  (add-hook 'enh-ruby-mode-hook 'ruby-electric-mode))

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
(el-get-bundle helm-ls-git)
(el-get-bundle helm-ag)
(use-package helm
  ;; :commands (helm-M-x helm-buffers-list helm-recent helm-browse-project
  ;;                     helm-for-files helm-do-ag-project-root
  ;;                     helm-do-ag-buffers)
  :init
  ;; (setq helm-exit-idle-delay 0)
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  (setq helm-autoresize-mode t)
  (setq helm-ag-fuzzy-match t)
  (setq helm-ag-insert-at-point t)
  (define-key evil-normal-state-map (kbd ",gp") 'helm-do-ag-project-root)
  (define-key evil-normal-state-map (kbd ",gb") 'helm-do-ag-buffers)
  (define-key evil-normal-state-map (kbd "<SPC>:")  'helm-M-x)
  (define-key evil-normal-state-map (kbd "<SPC>hb") 'helm-buffers-list)
  (define-key evil-normal-state-map (kbd "<SPC>hr") 'helm-recentf)
  (define-key evil-normal-state-map (kbd "<SPC>hp") 'helm-browse-project)
  (define-key evil-normal-state-map (kbd "<SPC>hf") 'helm-find-files)
  (define-key evil-normal-state-map (kbd "<SPC>hl") 'helm-resume)
  :config
  (helm-mode +1)
  (use-package helm-ls-git)
  (use-package helm-ag)
  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action))

(el-get-bundle helm-dash)
(use-package helm-dash
  :commands (helm-dash-at-point helm-dash helm-dash-install-docset)
  :init
  (define-key evil-normal-state-map (kbd "<SPC>hdd") 'helm-dash)
  (define-key evil-normal-state-map (kbd "<SPC>hda") 'helm-dash-at-point))

;; yaml
(el-get-bundle yaml-mode)
(use-package yaml-mode
  :mode ("\\.yaml\\'" . yaml-mode))

(el-get-bundle ace-jump-mode)
(use-package ace-jump-mode
  :commands (ace-jump-word-mode ace-jump-char-mode ace-jump-line-mode)
  :init
  (setq ace-jump-mode-scope 'window)
  (define-key evil-normal-state-map (kbd "f") 'ace-jump-char-mode)
  (define-key evil-normal-state-map (kbd "<SPC><SPC>") 'ace-jump-word-mode)
  (define-key evil-normal-state-map (kbd "<SPC>l") 'ace-jump-line-mode))

(el-get-bundle expand-region)
(use-package expand-region
  :commands (er/expand-region er/contract-region)
  :init
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region)
  (define-key evil-visual-state-map (kbd "C-v") 'er/contract-region))

(el-get-bundle popwin)
(use-package popwin
  :config
  (popwin-mode t)
  (push '("*compilation*" :stick t :height 0.3 :tail t :noselect t) popwin:special-display-config))

(el-get-bundle powerline)
(use-package powerline
  :config (powerline-vim-theme))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(evil-shift-width 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(enh-ruby-op-face ((t (:foreground "headerColor"))))
 '(enh-ruby-string-delimiter-face ((t (:foreground "#d33682")))))
