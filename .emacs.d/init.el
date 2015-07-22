;;; init.el --- init.el
;;; Commentary:
;;; Code:


;; config
;; split buffer verticaly
;; (defun split-vertically-not-horizontally ()
;;   (interactive)
;;   (if (= (length (window-list nil 'dont-include-minibuffer-even-if-active)) 1)
;;       (split-window-vertically)))
;; (add-hook 'temp-buffer-setup-hook 'split-vertically-not-horizontally)
(setq split-width-threshold 100)
(define-key minibuffer-local-completion-map (kbd "C-w") 'backward-kill-word)
(global-set-key "\C-m" 'newline-and-indent)
(setq large-file-warning-threshold nil)
(fset 'yes-or-no-p 'y-or-n-p)
(add-to-list 'default-frame-alist '(font . "Ricty for Powerline-17"))
(setq gc-cons-threshold (* 128 1024 1024))
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq require-final-newline t)
(modify-syntax-entry ?_ "w")
(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))
(unless (eq window-system 'mac)
  (menu-bar-mode -1))

;; electric
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'electric-indent-mode)
(add-hook 'prog-mode-hook 'electric-layout-mode)

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
;; (setq el-get-verbose t)

(el-get-bundle diminish)
(el-get-bundle bind-key)
(el-get-bundle use-package)
;; (setq use-package-verbose t)
(require 'use-package)
(require 'diminish)
(diminish 'abbrev-mode)
(require 'bind-key)

;; whitespace
(use-package whitespace
  :config
  (setq whitespace-style '(face
                           trailing
                           tabs
                           spaces
                           empty
                           newline
                           newline-mark
                           space-mark
                           tab-mark))
  (setq whitespace-display-mappings
        '((space-mark ?\u3000 [?\　])
          (newline-mark ?\n [?\¬ ?\n])
          (tab-mark ?\t [?\▸ ?\▸])))
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-bold-p 'whitespace-space t)
  (set-face-foreground 'whitespace-space "#d33682")
  (set-face-background 'whitespace-space "#d33682")
  (set-face-bold-p 'whitespace-trailing t)
  (set-face-underline  'whitespace-trailing t)
  (set-face-foreground 'whitespace-trailing "#d33682")
  (set-face-background 'whitespace-trailing "#d33682")
  (set-face-foreground 'whitespace-newline  "headerColor")
  (set-face-background 'whitespace-newline 'nil)
  ;; (setq whitespace-action '(auto-cleanup))
  (global-whitespace-mode)
  (diminish 'global-whitespace-mode))

;; initchart
(el-get-bundle yuttie/initchart)
(use-package initchart
  :commands (initchart-record-execution-time-of))
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

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

;; smartparens
(el-get-bundle smartparens)
(use-package smartparens
  :defer t
  :init
  (use-package smartparens-config
    :defer t)
  :config
  ;; (smartparens-global-mode)
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
;; (el-get-bundle evil-search-highlight-persist)
(el-get-bundle evil-surround)
(el-get-bundle evil-terminal-cursor-changer)
(el-get-bundle evil-visualstar)

(use-package evil
  :init
  ;; DO NOT LOAD evil plugin before here
  (setq evil-fold-level 4
        evil-search-module 'evil-search
        evil-esc-delay 0
        evil-want-C-i-jump t
        evil-want-C-u-scroll t
        evil-shift-width 2
        evil-cross-lines t)
  :config
  (use-package evil-leader :config
    (global-evil-leader-mode)
    (evil-leader/set-leader "<SPC>"))
  ;; init evil-mode
  (evil-mode t)
  (diminish 'undo-tree-mode)
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
  ;; mappings
  (defun open-below-esc ()
    (interactive)
    (evil-open-below 1)
    (evil-normal-state))
  (define-key evil-normal-state-map (kbd "RET") 'open-below-esc)
  (define-key evil-insert-state-map (kbd "C-j") 'evil-normal-state)
  ;; C-h map
  (define-key evil-insert-state-map (kbd "C-h") 'delete-backward-char)
  (define-key evil-ex-search-keymap (kbd "C-h") 'delete-backward-char)
  (define-key evil-ex-completion-map (kbd "C-h") 'delete-backward-char)
  (define-key minibuffer-local-map (kbd "C-h") 'delete-backward-char)
  ;; window move
  (define-key evil-normal-state-map (kbd "C-k") 'windmove-up)
  (define-key evil-normal-state-map (kbd "C-j") 'windmove-down)
  (define-key evil-normal-state-map (kbd "C-h") 'windmove-left)
  (define-key evil-normal-state-map (kbd "C-l") 'windmove-right)
  (define-key evil-normal-state-map (kbd "C-c") 'evil-window-delete)
  ;; describe
  (define-key evil-normal-state-map (kbd ",hf") 'describe-function)
  (define-key evil-normal-state-map (kbd ",hv") 'describe-variable)
  (define-key evil-normal-state-map (kbd ",hs") 'describe-syntax)
  (define-key evil-normal-state-map (kbd ",hp") 'describe-package)
  (define-key evil-normal-state-map (kbd ",hm") 'describe-mode)
  (define-key evil-normal-state-map (kbd ",hb") 'describe-bindings)
  ;; whitespace
  (define-key evil-normal-state-map (kbd ",c") 'whitespace-cleanup)
  ;; comint-mode
  (evil-set-initial-state 'comint-mode 'normal)
  (evil-define-key 'normal comint-mode-map (kbd "C-d") 'evil-scroll-down)
  (evil-define-key 'normal comint-mode-map (kbd "C-c") 'evil-window-delete)
  ;; elisp
  (evil-leader/set-key-for-mode 'emacs-lisp-mode "ec" 'byte-compile-file)
  (evil-leader/set-key-for-mode 'emacs-lisp-mode "er" 'eval-region)
  (evil-leader/set-key-for-mode 'emacs-lisp-mode "es" 'eval-sexp)
  (evil-leader/set-key-for-mode 'emacs-lisp-mode "eb" 'eval-current-buffer)
  (evil-leader/set-key-for-mode 'emacs-lisp-mode "ef" 'eval-defun)
  ;; line move
  (defun evil-swap-key (map key1 key2)
    ;; MAP中のKEY1とKEY2を入れ替え
    "Swap KEY1 and KEY2 in MAP."
    (let ((def1 (lookup-key map key1))
          (def2 (lookup-key map key2)))
      (define-key map key1 def2)
      (define-key map key2 def1)))
  (evil-swap-key evil-motion-state-map "j" "gj")
  (evil-swap-key evil-motion-state-map "k" "gk"))

(use-package eww
  :commands (eww)
  :init
  (evil-define-key 'normal eww-history-mode-map "o" 'eww-history-browse)
  (evil-define-key 'normal eww-history-mode-map "q" 'quit-window)
  (evil-define-key 'normal eww-bookmark-mode-map "o" 'eww-bookmark-browse)
  (evil-define-key 'normal eww-bookmark-mode-map "d" 'eww-bookmark-kill)
  (evil-define-key 'normal eww-bookmark-mode-map "q" 'quit-window)
  (evil-define-key 'normal eww-mode-map "r" 'eww-reload)
  (evil-define-key 'normal eww-mode-map "H" 'eww-back-url)
  (evil-define-key 'normal eww-mode-map "L" 'eww-forward-url)
  (evil-define-key 'normal eww-mode-map "&" 'eww-browse-with-external-browser)
  (evil-define-key 'normal eww-mode-map "B" 'eww-list-bookmarks)
  (evil-define-key 'normal eww-mode-map "b" 'eww-add-bookmark)
  (evil-define-key 'normal eww-mode-map "@" 'eww-list-histories)
  (evil-define-key 'normal eww-mode-map "q" 'quit-window)
  (add-hook 'eww-mode-hook '(lambda () (linum-mode -1)))
  (setq eww-search-prefix "http://www.google.co.jp/search?q="))

;; guide-key
(el-get-bundle guide-key)
(use-package guide-key
  :commands (guide-key-mode)
  :init
  (setq guide-key/idle-delay 0.4)
  (setq guide-key/recursive-key-sequence-flag t)
  (setq guide-key/guide-key-sequence '("\\" "," "<SPC>"))
  (add-hook 'after-init-hook 'guide-key-mode)
  :config
  (diminish 'guide-key-mode))

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
  :config
  (use-package helm-config)
  (helm-mode +1)
  (diminish 'helm-mode)
  (use-package helm-ag
    :config
    (setq helm-ag-insert-at-point t))
  (use-package helm-ls-git
    :init
    (setq helm-ls-git-fuzzy-match t))
  (setq helm-mode-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-completion-in-region-fuzzy-match t
        helm-autoresize-mode t
        helm-ag-fuzzy-match t
        helm-move-to-line-cycle-in-source t
        helm-ff-search-library-in-sexp t
        helm-ff-file-name-history-use-recentf t
        helm-ag-insert-at-point t
        helm-exit-idle-delay 0)
  (evil-leader/set-key "agg" 'helm-do-ag)
  (evil-leader/set-key "agb" 'helm-do-ag-buffers)
  (evil-leader/set-key ":"  'helm-M-x)
  (evil-leader/set-key "bl" 'helm-buffers-list)
  (evil-leader/set-key "fc" 'helm-find-file-at)
  (evil-leader/set-key "fr" 'helm-recentf)
  (evil-leader/set-key "fp" 'helm-browse-project)
  (evil-leader/set-key "ff" 'helm-find-files)
  (evil-leader/set-key "hl" 'helm-resume)
  (evil-leader/set-key "o" 'helm-semantic-or-imenu)
  (evil-leader/set-key "p" 'helm-show-kill-ring)
  (define-key evil-normal-state-map (kbd ",ha") 'helm-apropos)
  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-comp-read-map (kbd "C-o") 'helm-ff-run-switch-other-window)

  (define-key helm-buffer-map (kbd "C-d") 'helm-buffer-run-kill-buffers)
  (define-key helm-buffer-map (kbd "C-o") 'helm-buffer-switch-other-window)

  (define-key helm-find-files-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-find-files-map (kbd "C-o") 'helm-ff-run-switch-other-window)
  (define-key helm-find-files-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-read-file-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-read-file-map (kbd "C-o") 'helm-ff-run-switch-other-window)
  (define-key helm-read-file-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-ag-map (kbd "C-o") 'helm-ag--run-other-window-action))

(el-get-bundle helm-dash)
(use-package helm-dash
  :commands (helm-dash-at-point helm-dash helm-dash-install-docset)
  :init
  (evil-leader/set-key "hdd" 'helm-dash)
  (evil-leader/set-key "hda" 'helm-dash-at-point))

(el-get-bundle rainbow-delimiters)
(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode)
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(el-get-bundle auto-complete)
(use-package auto-complete
  :init
  (setq ac-auto-start 3
        ac-delay 0.2
        ac-quick-help-delay 1
        ac-use-fuzzy t
        ac-fuzzy-enable t
        tab-always-indent 'complete
        ac-dwim t)
  (setq-default ac-sources '(ac-source-filename ac-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
  (add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
  (add-hook 'enh-ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-abbrev)))
  :config
  (use-package auto-complete-config :config (ac-config-default))
  (global-auto-complete-mode t)
  (define-key ac-completing-map (kbd "C-n") 'ac-next)
  (define-key ac-completing-map (kbd "C-p") 'ac-previous)
  (define-key ac-completing-map (kbd "<S-tab>") 'ac-previous)
  (ac-set-trigger-key "TAB")
  (diminish 'auto-complete-mode))

(use-package eldoc
  :commands (turn-on-eldoc-mode)
  :init
  (add-hook 'prog-mode-hook 'turn-on-eldoc-mode)
  :config
  (diminish 'eldoc-mode))

;; git
(el-get-bundle magit)
(el-get-bundle magit-gh-pulls)
(el-get-bundle gist)
(el-get-bundle git-gutter)

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
    (setq magit-status-buffer-switch-function 'switch-to-buffer)
    (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))

  (evil-set-initial-state 'magit-mode 'normal)
  (evil-set-initial-state 'magit-status-mode 'normal)
  (evil-set-initial-state 'magit-diff-mode 'normal)
  (evil-set-initial-state 'magit-log-mode 'normal)
  (evil-set-initial-state 'magit-reflog-mode 'normal)
  (evil-set-initial-state 'magit-process-mode 'normal)

  (define-key magit-mode-map "\s" nil) ;space I use space as my evil-leader key
  (define-key magit-diff-mode-map "\s" nil) ;space
  (define-key magit-diff-mode-map "j" nil)

  (define-key magit-status-mode-map "j" 'next-line) ;may be should evil-next-line
  (define-key magit-mode-map "j" 'next-line)
  (define-key magit-mode-map "k" 'previous-line)
  (define-key magit-file-section-map "K" 'magit-discard)
  (define-key magit-file-section-map "k" nil)
  (define-key magit-hunk-section-map "K" 'magit-discard)
  (define-key magit-hunk-section-map "k" nil)
  (define-key magit-unstaged-section-map "k" nil)
  (define-key magit-unstaged-section-map "K" 'magit-discard)
  (define-key magit-staged-section-map "K" 'magit-discard)
  (define-key magit-staged-section-map "k" nil)
  (define-key magit-stash-section-map "K" 'magit-stash-drop)
  (define-key magit-stash-section-map "k" nil)
  (define-key magit-stashes-section-map "K" 'magit-stash-clear)
  (define-key magit-stashes-section-map "k" nil)

  (define-key magit-untracked-section-map "K" 'magit-discard)
  (define-key magit-untracked-section-map "k" nil)

  (define-key magit-branch-section-map "K" 'magit-branch-delete)
  (define-key magit-branch-section-map "k" nil)

  (define-key magit-remote-section-map "K" 'magit-remote-remove)
  (define-key magit-remote-section-map "k" nil)

  (define-key magit-tag-section-map "k" nil)
  (define-key magit-tag-section-map "K" 'magit-tag-delete))

(use-package gist
  :commands (gist-list gist-region gist-region-private
                       gist-buffer gist-buffer-private))

(use-package git-gutter
  :commands (git-gutter-mode)
  :init
  (add-hook 'projectile-mode-hook 'git-gutter-mode)
  (evil-leader/set-key "gP" 'git-gutter:popup-hunk)
  (evil-leader/set-key "gn" 'git-gutter:next-hunk)
  (evil-leader/set-key "gp" 'git-gutter:previous-hunk)
  (evil-leader/set-key "gs" 'git-gutter:stage-hunk)
  (evil-leader/set-key "gr" 'git-gutter:revert-hunk)
  (setq git-gutter:update-interval 2)
  :config
  (custom-set-variables
   '(git-gutter:modified-sign "**")
   '(git-gutter:added-sign "++")
   '(git-gutter:deleted-sign "--"))
  (set-face-foreground 'git-gutter:modified "#eee8d5")
  (set-face-foreground 'git-gutter:added "#859900")
  (set-face-foreground 'git-gutter:deleted "#dc322f")
  (diminish 'git-gutter-mode)
  (git-gutter:linum-setup))

;; projectile
(el-get-bundle projectile)
(use-package helm-projectile
  :commands (helm-projectile-on))
(use-package projectile
  :commands (projectile-global-mode)
  :init
  (setq projectile-enable-caching t
        projectile-completion-system 'helm)
  (add-hook 'after-init-hook 'projectile-global-mode)
  (add-hook 'projectile-global-mode-hook 'helm-projectile-on)
  (evil-leader/set-key "tG" 'projectile-regenerate-tags)
  (evil-leader/set-key "bk" 'projectile-kill-buffers)
  (evil-leader/set-key "agp" 'helm-projectile-ag)
  (evil-leader/set-key "fd" 'helm-projectile-find-dir)
  (evil-leader/set-key "fp" 'helm-projectile-find-file)
  (evil-leader/set-key "fc" 'helm-projectile-find-file-dwim)
  (evil-leader/set-key "bw" 'projectile-switch-to-buffer-other-window)
  (evil-leader/set-key "bs" 'helm-projectile-switch-to-buffer))

;; rails
(el-get-bundle evil-rails)
(el-get-bundle projectile-rails)
(use-package projectile-rails
  :commands (projectile-rails-on)
  :init
  (evil-define-key 'normal projectile-rails-mode-map ",rfm" 'projectile-rails-find-model)
  (evil-define-key 'normal projectile-rails-mode-map ",rfc" 'projectile-rails-find-controller)
  (evil-define-key 'normal projectile-rails-mode-map ",rfv" 'projectile-rails-find-view)
  (evil-define-key 'normal projectile-rails-mode-map ",rfs" 'projectile-rails-find-spec)
  (evil-define-key 'normal projectile-rails-mode-map ",rfl" 'projectile-rails-find-lib)
  (evil-define-key 'normal projectile-rails-mode-map ",rfi" 'projectile-rails-find-initializer)
  (evil-define-key 'normal projectile-rails-mode-map ",rfe" 'projectile-rails-find-environment)
  (evil-define-key 'normal projectile-rails-mode-map ",rcm" 'projectile-rails-find-current-model)
  (evil-define-key 'normal projectile-rails-mode-map ",rcc" 'projectile-rails-find-current-controller)
  (evil-define-key 'normal projectile-rails-mode-map ",rcv" 'projectile-rails-find-current-view)
  (evil-define-key 'normal projectile-rails-mode-map ",rcs" 'projectile-rails-find-current-spec)
  (evil-define-key 'normal projectile-rails-mode-map ",ric" 'projectile-rails-console)
  (evil-define-key 'normal projectile-rails-mode-map ",ris" 'projectile-rails-server)
  (evil-define-key 'normal projectile-rails-mode-map ",rir" 'projectile-rails-rake)
  (evil-define-key 'normal projectile-rails-mode-map ",rig" 'projectile-rails-generate)
  (evil-define-key 'normal projectile-rails-mode-map ",rer" 'projectile-rails-extract-region)
  (evil-define-key 'normal projectile-rails-mode-map "gf" 'projectile-rails-goto-file-at-point)
  (evil-define-key 'normal projectile-rails-mode-map "gm" 'projectile-rails-goto-gemfile)
  (evil-define-key 'normal projectile-rails-mode-map "gr" 'projectile-rails-goto-routes)
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
  (evil-leader/set-key "el" 'flycheck-list-errors)
  (evil-leader/set-key "en" 'flycheck-next-error)
  (evil-leader/set-key "ep" 'flycheck-previous-error)
  :config
  (use-package flycheck-pos-tip
    :commands (flycheck-pos-tip-error-messages)
    :init
    (custom-set-variables
     '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))
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
(el-get-bundle ruby-end)
(use-package bundler
  :commands (bundle-open bundle-exec bundle-check bundle-gemfile
                         bundle-update bundle-console bundle-install))
(use-package rbenv
  :commands (global-rbenv-mode rbenv-use-corresponding)
  :init
  (add-hook 'enh-ruby-mode-hook 'global-rbenv-mode)
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
  :config
  (diminish 'robe-mode))
(use-package enh-ruby-mode
  :mode (("\\(Rake\\|Thor\\|Guard\\|Gem\\|Cap\\|Vagrant\\|Berks\\|Pod\\|Puppet\\)file\\'" . enh-ruby-mode)
         ("\\.\\(rb\\|rabl\\|ru\\|builder\\|rake\\|thor\\|gemspec\\|jbuilder\\|schema\\)\\'" . enh-ruby-mode)
         ("Schema" . enh-ruby-mode))
  :interpreter ("ruby" . enh-ruby-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'auto-complete-mode)
  (add-hook 'enh-ruby-mode-hook '(lambda ()
                                   (abbrev-mode)
                                   (electric-pair-mode)
                                   (electric-indent-mode)
                                   (electric-layout-mode)))
  (custom-set-faces
   '(enh-ruby-op-face ((t (:foreground "headerColor"))))
   '(enh-ruby-string-delimiter-face ((t (:foreground "#d33682")))))
  :config
  (setq enh-ruby-add-encoding-comment-on-save nil))
(use-package ruby-test-mode
  :commands (ruby-test-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'ruby-test-mode)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tt") 'ruby-test-run-at-point)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tb") 'ruby-test-run)
  :config
  (diminish 'ruby-test-mode))
(use-package ruby-end
  :commands (ruby-end-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'ruby-end-mode)
  :config
  (diminish 'ruby-end-mode))

;; html, erb
(el-get-bundle web-mode)
(use-package web-mode
  :mode (("\\.erb\\'" . web-mode)
         ("\\.html?\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2))

;; shell
(use-package eshell
  :commands (eshell)
  :init
  (use-package pcomplete)
  (add-to-list 'ac-modes 'eshell-mode)
  (ac-define-source pcomplete
    '((candidates . pcomplete-completions)))
  (add-hook 'eshell-mode-hook '(lambda ()
                                 (setq ac-sources
                                       '(ac-source-pcomplete
                                         ac-source-filename
                                         ac-source-files-in-current-dir
                                         ac-source-words-in-buffer
                                         ac-source-dictionary))
                                 (evil-define-key 'insert eshell-mode-map (kbd "C-p") 'helm-eshell-history)))
  :config
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-cmpl-cycle-completions nil)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-save-history-on-exit t)
  (setq eshell-command-aliases-list
        (append (list
                 (list "emacs" "find-file $1")
                 (list "ppr" "find-file PULLREQ_MSG")
                 (list "pr" "hub pull-request -b $1 -F PULLREQ_MSG")
                 (list "b" "bundle exec $1")
                 (list "rc" "bundle exec rails c")
                 (list "rct" "bundle exec rails c test")
                 (list "ridgepole-test" "bundle exec rake db:ridgepole:apply[test]")
                 (list "ridgepole-dev" "bundle exec rake db:ridgepole:apply[development]"))
                ())))
(el-get-bundle exec-path-from-shell)
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))
(el-get-bundle shell-pop)
(use-package shell-pop
  :commands (shell-pop)
  :init
  (evil-leader/set-key "s" 'shell-pop)
  :config
  (setq shell-pop-internal-mode "eshell")
  (setq shell-pop-internal-mode-shell "eshell")
  (setq shell-pop-internal-mode-func (lambda nil (eshell)))
  (setq shell-pop-internal-mode-buffer "*eshell*"))

;; imenu
(use-package imenu
  :defer t
  :init
  (setq imenu-auto-rescan t)
  (add-hook 'imenu-after-jump-hook '(lambda ()
                                      (recenter 10))))

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
  (evil-leader/set-key "<SPC>" 'ace-jump-word-mode)
  (evil-leader/set-key "l" 'ace-jump-line-mode))

(el-get-bundle expand-region)
(use-package expand-region
  :commands (er/expand-region er/contract-region)
  :init
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region)
  (define-key evil-visual-state-map (kbd "C-v") 'er/contract-region))

(el-get-bundle popwin)
(use-package popwin
  :init
  (setq popwin:popup-window-position 'bottom)
  :config
  (popwin-mode t)
  (evil-leader/set-key "bp" 'popwin:pop-to-buffer)
  (evil-leader/set-key "bf" 'popwin:find-file)
  (push '("*Warnings*" :height 0.3 :noselect t) popwin:special-display-config)
  (push '("*Flycheck errors*" :stick t :height 0.3 :noselect t) popwin:special-display-config)
  (push '("*compilation*" :stick t :height 0.2 :tail t :noselect t) popwin:special-display-config)
  (push "*slime-apropos*" popwin:special-display-config)
  (push "*slime-macroexpansion*" popwin:special-display-config)
  (push "*slime-description*" popwin:special-display-config)
  (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
  (push "*slime-xref*" popwin:special-display-config)
  (push '(sldb-mode :stick t) popwin:special-display-config)
  (push '(slime-repl-mode :noselect t :position bottom :height 0.3) popwin:special-display-config)
  (push 'slime-connection-list-mode popwin:special-display-config))

(el-get-bundle hydra)
(use-package hydra
  :config
  (defhydra helm-like-unite (:hint nil
                                   :color pink)
    "
-----------------------------------------------------------------------
[K] ScrollUp   | [k] move up   | [m] mark   | [v] view   | [i] cancel |
[J] ScrollDown | [j] move down | [t] toggle | [H] help   | [o] quit   |
| [h] left      |     mark   | [d] delete |            |
| [l] right     | [u] unmark | [y] yank   | [w] toggle |
|               |     all    | [f] follow |     window |
-----------------------------------------------------------------------
"
    ("h" helm-beginning-of-buffer)
    ("j" helm-next-line)
    ("k" helm-previous-line)
    ("l" helm-end-of-buffer)
    ("g" helm-beginning-of-buffer)
    ("G" helm-end-of-buffer)
    ("K" helm-scroll-other-window-down)
    ("J" helm-scroll-other-window)
    ("m" helm-toggle-visible-mark)
    ("t" helm-toggle-all-marks)
    ("u" helm-unmark-all)
    ("<escape>" keyboard-escape-quit "" :exit t)
    ("o" keyboard-escape-quit :exit t)
    ("i" nil)
    ("n" helm-next-source)
    ("p" helm-previous-source)
    ("H" helm-help)
    ("v" helm-execute-persistent-action)
    ("y" helm-yank-selection)
    ("w" helm-toggle-resplit-and-swap-windows)
    ("a" helm-select-action)
    ("d" helm-delete-marked-files)
    ("r" helm-ff-run-rename-file)
    ("f" helm-follow-mode))
  (define-key helm-map (kbd "<escape>") 'helm-like-unite/body)
  (define-key helm-map (kbd "C-k") 'helm-like-unite/body)
  (define-key helm-map (kbd "C-o") 'helm-like-unite/body))

;; lisp
(el-get-bundle slime)
(el-get-bundle ac-slime)
(use-package slime
  :commands (slime-mode)
  :init
  (add-hook 'slime-repl-mode-hook '(lambda () (electric-pair-mode -1)))
  (add-hook 'lisp-mode-hook 'slime-mode)
  (setq slime-complete-symbol*-fancy t)
  (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
  (setq inferior-lisp-program (executable-find "clisp"))
  (setq slime-contribs '(slime-repl slime-fancy slime-banner slime-fuzzy))
  (evil-define-key 'normal slime-mode-map (kbd ",cc") 'slime-compile-file)
  (evil-define-key 'normal slime-mode-map (kbd ",cC") 'slime-compile-and-load-file)
  (evil-define-key 'normal slime-mode-map (kbd ",cf") 'slime-compile-defun)
  (evil-define-key 'normal slime-mode-map (kbd ",cr") 'slime-compile-region)
  (evil-define-key 'normal slime-mode-map (kbd ",eb") 'slime-eval-buffer)
  (evil-define-key 'normal slime-mode-map (kbd ",ef") 'slime-eval-defun)
  (evil-define-key 'normal slime-mode-map (kbd ",ee") 'slime-eval-last-sexp)
  (evil-define-key 'normal slime-mode-map (kbd ",er") 'slime-eval-region)
  (evil-define-key 'normal slime-mode-map (kbd ",gg") 'slime-inspect-definition)
  (evil-define-key 'normal slime-mode-map (kbd ",ha") 'slime-apropos)
  (evil-define-key 'normal slime-mode-map (kbd ",hh") 'slime-hyperspec-lookup)
  (evil-define-key 'normal slime-mode-map (kbd ",hf") 'slime-describe-function)
  (evil-define-key 'normal slime-mode-map (kbd ",si") 'slime)
  (evil-define-key 'normal slime-mode-map (kbd ",sq") 'slime-quit-lisp)
  (evil-define-key 'normal slime-mode-map (kbd ",sr") 'slime-restart-inferior-lisp)
  (add-hook 'slime-repl-mode-hook (lambda () (linum-mode -1)))
  :config
  (slime-setup '(slime-repl slime-fancy slime-banner slime-fuzzy slime-indentation))
  (use-package ac-slime
    :commands (set-up-slime-ac)
    :init
    (add-hook 'slime-mode-hook '(lambda () (set-up-slime-ac t)))
    (add-hook 'slime-repl-mode '(lambda () (set-up-slime-ac t)))))

;; theme
(el-get-bundle bbatsov/solarized-emacs)
(setq solarized-distinct-fringe-background t)
(setq solarized-use-variable-pitch nil)
(setq solarized-high-contrast-mode-line t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/solarized-emacs")
(load-theme 'solarized-dark t)

;; (el-get-bundle color-theme-solarized)
;; (set-frame-parameter nil 'background-mode 'dark)
;; (set-terminal-parameter nil 'background-mode 'dark)
;; (load-theme 'solarized)

(el-get-bundle powerline)
(el-get-bundle powerline-evil)
(use-package powerline-evil
  :init
  (setq powerline-default-separator 'arrow)
  (setq powerline-evil-tag-style 'verbose)
  :config
  (custom-set-faces
   '(mode-line ((t (:background "#002b36" :foreground "#fdf6e3" :inverse-video t :box nil))))
   '(mode-line-inactive ((t (:background "#eee8d5" :foreground "#586e75" :inverse-video t :box nil))))
   '(powerline-active1 ((t (:background "#002b36" :foreground "#eee8d5"))))
   '(powerline-active2 ((t (:background "#002b36" :foreground "#eee8d5"))))
   '(powerline-evil-base-face ((t (:background "#fdf6e3" :foreground "#002b36" :width extra-expanded))))
   '(powerline-evil-insert-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#657b83"))))
   '(powerline-evil-normal-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#268bd2"))))
   '(powerline-evil-operator-face ((t (:inherit powerline-evil-operator-face :background "#fdf6e3" :foreground "#b58900"))))
   '(powerline-evil-visual-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#d33682"))))
   '(powerline-inactive1 ((t (:inherit mode-line-inactive :background "#fdf6e3" :foreground "#586e75"))))
   '(powerline-inactive2 ((t (:inherit mode-line-inactive :foreground "#586e75")))))
  (powerline-evil-vim-color-theme))

(el-get-bundle indent-guide)
(use-package indent-guide
  :commands (indent-guide-mode)
  :init
  (evil-leader/set-key "ig" 'indent-guide-mode)
  (setq indent-guide-recursive t)
  :config
  (diminish 'indent-guide-mode))

(el-get-bundle krisajenkins/helm-spotify)
(use-package helm-spotify
  :commands (helm-spotify)
  :init
  (evil-leader/set-key "hs" 'helm-spotify))

;; (el-get-bundle golden-ratio)
;; (use-package golden-ratio
;;   :init
;;   (setq golden-ratio-exclude-modes '(slime-repl-mode))
;;   (setq golden-ratio-exclude-buffer-names '("*compilation*"
;;                                             "*Flycheck errors*"
;;                                             "slime-apropos*"
;;                                             "*slime-description*"
;;                                             "*slime-compilation*"
;;                                             "*guide-key*"
;;                                             "*Help*"
;;                                             "*Warnings*"))
;;   (setq golden-ratio-auto-scale t)
;;   :config
;;   (golden-ratio-mode 1)
;;   (diminish 'golden-ratio-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(evil-shift-width 2)
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
 '(git-gutter:added-sign "++")
 '(git-gutter:deleted-sign "--")
 '(git-gutter:modified-sign "##"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(enh-ruby-op-face ((t (:foreground "headerColor"))))
 '(enh-ruby-string-delimiter-face ((t (:foreground "#d33682"))))
 '(mode-line ((t (:background "#002b36" :foreground "#fdf6e3" :inverse-video t :box nil))))
 '(mode-line-inactive ((t (:background "#eee8d5" :foreground "#586e75" :inverse-video t :box nil))))
 '(powerline-active1 ((t (:background "#002b36" :foreground "#eee8d5"))))
 '(powerline-active2 ((t (:background "#002b36" :foreground "#eee8d5"))))
 '(powerline-evil-base-face ((t (:background "#fdf6e3" :foreground "#002b36" :width extra-expanded))))
 '(powerline-evil-insert-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#657b83"))))
 '(powerline-evil-normal-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#268bd2"))))
 '(powerline-evil-operator-face ((t (:inherit powerline-evil-operator-face :background "#fdf6e3" :foreground "#b58900"))))
 '(powerline-evil-visual-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#d33682"))))
 '(powerline-inactive1 ((t (:inherit mode-line-inactive :background "#fdf6e3" :foreground "#586e75"))))
 '(powerline-inactive2 ((t (:inherit mode-line-inactive :foreground "#586e75")))))
