;;; init.el --- init.el
;;; Commentary:
;;; Code:


(add-to-list 'load-path "~/.emacs.d/el-get/initchart")
(require 'initchart)
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

;; (defun auto-compile-init-file ()
;;   (if (string= "init.el" (buffer-name (current-buffer)))
;;       (byte-compile-file (buffer-file-name (current-buffer)))))
;; (add-hook 'after-save-hook 'auto-compile-init-file)

;; config

(setq split-width-threshold 110)
(when window-system
  ;; Ricty フォントの利用
  (create-fontset-from-ascii-font "Ricty for Powerline-17:weight=normal:slant=normal" nil "ricty")
  (set-fontset-font "fontset-ricty"
                    'unicode
                    (font-spec :family "Ricty for Powerline" :size 17)
                    nil
                    'append)
  (add-to-list 'default-frame-alist '(font . "fontset-ricty"))
  ;; 警告音の代わりに画面フラッシュ
  ;; (setq visible-bell t)
  ;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
  (setq ring-bell-function 'ignore))
;; スクリプトを保存する時，自動的に chmod +x を行う
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
(define-key minibuffer-local-completion-map (kbd "C-w") 'backward-kill-word)
(global-set-key "\C-m" 'newline-and-indent)
(setq large-file-warning-threshold nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq gc-cons-threshold (* 128 1024 1024))
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (menu-bar-mode -1)
(setq require-final-newline t)
(setq ad-redefinition-action 'accept)
(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

;; linum
(setq linum-format "%4d ")
(add-hook 'prog-mode-hook 'linum-mode)

;; line wrap
(add-hook 'prog-mode-hook 'visual-line-mode)

;; tab
(setq tab-always-indent t)
(setq-default indent-tabs-mode nil)
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
(el-get-bundle use-package)
;; (setq use-package-verbose t)
(require 'use-package)
(require 'diminish)
(diminish 'abbrev-mode)
(diminish 'visual-line-mode)

(el-get-bundle el-get-lock
  :type github
  :pkgname "tarao/el-get-lock"
  :name el-get-lock)

(use-package el-get-lock
  :commands (el-get-lock))

(el-get-bundle exec-path-from-shell)
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package hideshow
  :commands (hs-minor-mode)
  :diminish hs-minor-mode
  :config
  (add-hook 'prog-mode-hook 'hs-minor-mode))

;; whitespace
(use-package whitespace
  :diminish global-whitespace-mode
  :config
  (setq whitespace-style '(face
                           trailing
                           tabs
                           spaces
                           ;; empty
                           newline
                           newline-mark
                           space-mark
                           tab-mark))
  (setq whitespace-display-mappings
        '((space-mark ?\u3000 [?\　])
          (newline-mark ?\n [?\¬ ?\n])
          (tab-mark ?\t [?\▸ ?\▸])))
  (setq whitespace-space-regexp "\\(\u3000+\\)")
  (set-face-bold 'whitespace-space t)
  (set-face-foreground 'whitespace-space "#d33682")
  (set-face-background 'whitespace-space "#d33682")
  (set-face-bold 'whitespace-trailing t)
  (set-face-underline  'whitespace-trailing t)
  (set-face-foreground 'whitespace-trailing "#d33682")
  (set-face-background 'whitespace-trailing "#d33682")
  (set-face-foreground 'whitespace-newline  "headerColor")
  (set-face-background 'whitespace-newline 'nil)
  (set-face-background 'whitespace-tab 'nil)
  (global-whitespace-mode))

                                        ; initchart
(el-get-bundle yuttie/initchart)
;; (use-package initchart
;;   :commands (initchart-record-execution-time-of))
;; (initchart-record-execution-time-of load file)
;; (initchart-record-execution-time-of require feature)

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
(use-package smartparens-config
  :diminish smartparens-mode
  :commands (smartparens-mode turn-on-smartparens-mode)
  :init
  (add-hook 'prog-mode-hook 'smartparens-mode)
  :config
  )

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
(el-get-bundle evil-surround)
(el-get-bundle evil-terminal-cursor-changer)
(el-get-bundle evil-visualstar)
(el-get-bundle expand-region)
(el-get-bundle evil-indent-textobject)
(el-get-bundle evil-exchange)
(el-get-bundle evil-org-mode)
(el-get-bundle evil-snipe)
(el-get-bundle ace-jump-mode)

(use-package evil-leader
  :commands (global-evil-leader-mode)
  :init
  (add-hook 'after-init-hook 'global-evil-leader-mode)
  (add-hook 'global-evil-leader-mode-hook '(lambda () (evil-mode t)))
  (defun toggle-window-maximized ()
    (interactive)
    (if window-system
        (let ((current-size (frame-parameter nil 'fullscreen)))
          (message "%s" current-size)
          (if (null current-size)
              (set-frame-parameter nil 'fullscreen 'maximized)
            (set-frame-parameter nil 'fullscreen nil)))))
  (defun toggle-frame-alpha ()
    (interactive)
    (if window-system
        (let ((current-alpha (frame-parameter nil 'alpha)))
          (if (or (null current-alpha) (= current-alpha 100))
              (set-frame-parameter nil 'alpha 78)
            (set-frame-parameter nil 'alpha 100)))))
  (defun toggle-folding ()
    (interactive)
    (set-selective-display
     (unless selective-display
       4
       ;; (1+ (current-column))
       ))
    (recenter))
  :config
  (evil-leader/set-leader "<SPC>")
  (use-package evil-org)
  (evil-leader/set-key "di" 'helm-dash-install-docset)
  (evil-leader/set-key "dd" 'helm-dash)
  (evil-leader/set-key "da" 'helm-dash-at-point)
  (evil-leader/set-key "gf" 'magit-fetch-popup)
  (evil-leader/set-key "gb" 'magit-blame-popup)
  (evil-leader/set-key "gg" 'magit-status)
  (evil-leader/set-key "gu" 'git-gutter:update-all-windows)
  (evil-leader/set-key "gv" 'git-gutter:popup-hunk)
  (evil-leader/set-key "gn" 'git-gutter:next-hunk)
  (evil-leader/set-key "gp" 'git-gutter:previous-hunk)
  (evil-leader/set-key "gs" 'git-gutter:stage-hunk)
  (evil-leader/set-key "gr" 'git-gutter:revert-hunk)
  (evil-leader/set-key "gm" 'git-messenger:popup-message)
  (evil-leader/set-key "gt" 'git-timemachine)
  (evil-leader/set-key "ps" 'projectile-switch-project)
  (evil-leader/set-key "pk" 'projectile-invalidate-cache)
  (evil-leader/set-key "tG" 'projectile-regenerate-tags)
  (evil-leader/set-key "tt" 'helm-etags-select)
  (evil-leader/set-key "ta" 'google-translate-at-point)
  (evil-leader/set-key "tq" 'google-translate-query-translate)
  (evil-leader/set-key "tQ" 'google-translate-query-translate-reverse)
  (evil-leader/set-key "fd" 'helm-projectile-find-dir)
  (evil-leader/set-key "fp" 'helm-projectile-find-file)
  (evil-leader/set-key "fc" 'helm-projectile-find-file-dwim)
  (evil-leader/set-key "bk" 'projectile-kill-buffers)
  (evil-leader/set-key "bw" 'projectile-switch-to-buffer-other-window)
  (evil-leader/set-key "bl" 'popwin:popup-last-buffer)
  (evil-leader/set-key "bp" 'popwin:pop-to-buffer)
  ;; (evil-leader/set-key "bn" 'switch-to-next-buffer)
  ;; (evil-leader/set-key "bp" 'switch-to-prev-buffer)
  (evil-leader/set-key "el" 'flycheck-list-errors)
  (evil-leader/set-key "en" 'flycheck-next-error)
  (evil-leader/set-key "ep" 'flycheck-previous-error)
  (evil-leader/set-key "s" 'shell-pop)
  (evil-leader/set-key "bf" 'popwin:find-file)
  (evil-leader/set-key "<SPC>" 'ace-jump-word-mode)
  (evil-leader/set-key "wb" 'balance-windows)
  (evil-leader/set-key "wg" 'golden-ratio-mode)
  (evil-leader/set-key "wm" 'toggle-window-maximized)
  (evil-leader/set-key "wt" 'toggle-frame-alpha)
  (evil-leader/set-key "l" 'toggle-folding)
  (evil-leader/set-key "uv" 'undo-tree-visualize)
  (evil-leader/set-key "rp" 'helm-projectile-ag)
  (evil-leader/set-key "rr" 'helm-do-ag)
  (evil-leader/set-key "rb" 'helm-do-ag-buffers)
  (evil-leader/set-key ":"  'helm-M-x)
  (evil-leader/set-key "bb" 'helm-buffers-list)
  (evil-leader/set-key "fc" 'helm-find-file-at)
  (evil-leader/set-key "fr" 'helm-recentf)
  (evil-leader/set-key "fp" 'helm-browse-project)
  (evil-leader/set-key "ff" 'helm-find-files)
  (evil-leader/set-key "hl" 'helm-resume)
  (evil-leader/set-key "hm" 'helm-mini)
  (evil-leader/set-key "ho" 'helm-semantic-or-imenu)
  (evil-leader/set-key "hp" 'helm-show-kill-ring)
  (evil-leader/set-key "ig" 'indent-guide-mode)
  (evil-leader/set-key "hgf" 'helm-open-github-from-file)
  (evil-leader/set-key "hgc" 'helm-open-github-from-commit)
  (evil-leader/set-key "hgi" 'helm-open-github-from-issues)
  (evil-leader/set-key "hgp" 'helm-open-github-from-pull-requests)
  (evil-leader/set-key "rc" 'restclient-mode)
  (defun open-junk-dir ()
    (interactive)
    (let ((junk-dir "~/Dropbox/junk/"))
      (helm-find-files-1 (expand-file-name junk-dir))))
  (evil-leader/set-key "ml" 'open-junk-dir)
  (evil-leader/set-key "mn" 'open-junk-file)
  (evil-leader/set-key "aw" 'ace-window))
(use-package evil
  :commands (evil-mode)
  :diminish undo-tree-mode
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
  (add-hook 'evil-insert-state-entry-hook 'evil-ex-nohighlight)
  (use-package evil-exchange
    :config
    (evil-exchange-install))
  (use-package evil-indent-textobject)
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
  (use-package evil-matchit
    :config
    (global-evil-matchit-mode t))
  (use-package evil-anzu)
  (use-package evil-jumper
    :init
    (setq evil-jumper--debug nil)
    ;; (setq evil-jumper-file "~/.emacs.d/.evil-jumper")
    ;; (setq evil-jumper-auto-save-interval 1)
    (setq evil-jumper-auto-center t)
    :config (global-evil-jumper-mode))
  (use-package evil-args
    :commands (evil-inner-arg evil-outer-arg)
    :init
    (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
    (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))
  (use-package evil-snipe
    :diminish evil-snipe-mode
    :init
    (setq evil-snipe-repeat-keys t)
    ;; or 'buffer, 'whole-visible or 'whole-buffer
    (setq evil-snipe-tab-increment t)
    (setq evil-snipe-scope 'whole-visible)
    (setq evil-snipe-repeat-scope 'whole-visible)
    (setq evil-snipe-enable-highlight t)
    (setq evil-snipe-enble-incremental-highlight t)
    (setq evil-snipe-override-evil-repeat-keys t)
    :config
    (evil-snipe-mode 1)
    (evil-snipe-override-mode 1))

  (use-package evil-integration
    :config
    (use-package ace-jump-mode
      :commands (ace-jump-word-mode)
      :config
      (define-key evil-operator-state-map (kbd "f") #'evil-ace-jump-char-mode)      ; similar to f
      (define-key evil-operator-state-map (kbd "t") #'evil-ace-jump-char-to-mode) ; similar to t
      (setq ace-jump-mode-scope 'window)
      (setq ace-jump-mode-move-keys
            '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?q ?w ?e ?r ?u ?i ?o ?v ?b ?n ?m))))


  ;; cleanup whitespace
  (defun evil-cleanup-whitespace ()
    (interactive)
    (unless (evil-insert-state-p)
      (whitespace-cleanup-region (point-min) (point-max))))
  (add-hook 'before-save-hook 'evil-cleanup-whitespace)


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

  (define-key evil-motion-state-map (kbd "C-k") 'windmove-up)
  (define-key evil-motion-state-map (kbd "C-j") 'windmove-down)
  (define-key evil-motion-state-map (kbd "C-h") 'windmove-left)
  (define-key evil-motion-state-map (kbd "C-l") 'windmove-right)
  (define-key evil-motion-state-map (kbd "C-c") 'evil-window-delete)
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
  (evil-define-key 'normal emacs-lisp-mode-map ",c" 'byte-compile-file)
  (evil-define-key 'visual emacs-lisp-mode-map (kbd ",er") 'eval-region)
  (evil-define-key 'normal emacs-lisp-mode-map ",es" 'eval-sexp)
  (evil-define-key 'normal emacs-lisp-mode-map ",eb" 'eval-buffer)
  (evil-define-key 'normal emacs-lisp-mode-map ",ef" 'eval-defun)
  ;; expand-region
  (use-package expand-region
    :commands (er/expand-region er/contract-region))
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region)
  (define-key evil-visual-state-map (kbd "C-v") 'er/contract-region)
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


(el-get-bundle ace-window)
(use-package ace-window
  :commands (ace-window aw-select aw-switch-to-window)
  :init
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))


(use-package eww
  :commands (eww)
  :init
  (add-hook 'eww-mode-hook '(lambda () (linum-mode -1)))
  (setq eww-search-prefix "http://www.google.co.jp/search?q=")
  :config
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
  (evil-define-key 'normal eww-mode-map "q" 'quit-window))

;; guide-key
;; (el-get-bundle guide-key)
;; (use-package guide-key
;;   :diminish guide-key-mode
;;   :commands (guide-key-mode)
;;   :init
;;   (setq guide-key/idle-delay 0.4
;;         guide-key/text-scale-amount 1
;;         guide-key/guide-key-sequence '("\\" "," "<SPC>")
;;         guide-key/recursive-key-sequence-flag t
;;         guide-key/popup-window-position 'bottom)
;;   (add-hook 'after-init-hook 'guide-key-mode))

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
  (which-key-add-key-based-replacements "SPC r" " text-replacement")
  (which-key-add-key-based-replacements "SPC d" " dash")
  (which-key-add-key-based-replacements "SPC f" " find-file")
  (which-key-add-key-based-replacements "SPC h" " helm")
  (which-key-add-key-based-replacements "SPC p" " projectile")
  (which-key-add-key-based-replacements "SPC u" " undo-tree")
  (which-key-add-key-based-replacements "SPC b" " buffers")
  (which-key-add-key-based-replacements "SPC e" " errors")
  (which-key-add-key-based-replacements "SPC i" " indent-guides")
  (which-key-add-key-based-replacements "SPC t" " tags, transrate")
  (which-key-add-key-based-replacements "SPC w" " windows")
  (which-key-add-key-based-replacements "SPC g" " git")
  (which-key-add-key-based-replacements ", h" " help")

  (which-key-add-major-mode-key-based-replacements 'emacs-lisp-mode
    ", e" " eval")
  )

;; helm
;; (el-get-bundle async)
(el-get-bundle helm)
(el-get-bundle helm-ls-git)
(el-get-bundle helm-ag)

(use-package helm
  :diminish helm-mode
  :commands (helm-etags-select
             helm-do-ag
             helm-do-ag-buffers
             helm-M-x
             helm-buffers-list
             helm-find-file-at
             helm-recentf
             helm-browse-project
             helm-find-files
             helm-resume
             helm-mini
             helm-semantic-or-imenu
             helm-show-kill-ring)
  :init
  (setq helm-M-x-fuzzy-match t
        helm-apropos-fuzzy-match t
        helm-file-cache-fuzzy-match t
        helm-imenu-fuzzy-match t
        helm-lisp-fuzzy-completion t
        helm-locate-fuzzy-match t
        helm-recentf-fuzzy-match t
        helm-semantic-fuzzy-match t
        helm-ag-fuzzy-match t
        helm-mode-fuzzy-match t
        helm-completion-in-region-fuzzy-match t
        helm-buffers-fuzzy-matching t)
  (setq helm-prevent-escaping-from-minibuffer t
        helm-buffers-truncate-lines t
        helm-buffer-max-length nil
        helm-ff-transformer-show-only-basename t
        helm-bookmark-show-location t
        helm-display-header-line t
        helm-split-window-in-side-p nil
        helm-always-two-windows t
        helm-autoresize-mode t
        helm-ff-file-name-history-use-recentf t
        helm-exit-idle-delay 0
        helm-ff-search-library-in-sexp t
        helm-move-to-line-cycle-in-source nil
        helm-echo-input-in-header-line t)
  :config
  (use-package helm-config)
  (use-package helm-ls-git
    :init
    (setq helm-ls-git-default-sources '(helm-source-ls-git))
    (setq helm-ls-git-fuzzy-match t))
  (use-package helm-ag
    :config
    (setq helm-ag-insert-at-point 'symbol))
  (helm-mode +1)


  (defun switch-window-if-gteq-3-windows ()
    (if (>= (length (window-list)) 3)
        (aw-switch-to-window (aw-select "Ace - Window"))))

  (defun my-evil-vsplit-window (file-name)
    (let ((evil-vsplit-window-right t)
          (evil-auto-balance-windows t))
      (evil-window-vsplit nil (expand-file-name file-name))))

  (defun my-evil-split-window (file-name)
    (let ((evil-split-window-below nil)
          (evil-auto-balance-windows t))
      (evil-window-split nil (expand-file-name file-name))))

  (defun ace-split-find-file (candidate)
    (switch-window-if-gteq-3-windows)
    (my-evil-split-window candidate))
  (defun helm-ace-split-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-split-find-file)))

  (defun ace-split-switch-to-buffer (buffer-or-name)
    (switch-window-if-gteq-3-windows)
    (let ((file-name (buffer-file-name buffer-or-name)))
      (if file-name
          (my-evil-split-window file-name)
        (let ((window (split-window (selected-window) nil 'above)))
          (unwind-protect
              (progn
                (aw-switch-to-window window)
                (switch-to-buffer buffer-or-name)))))))
  (defun helm-ace-split-sb ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-split-switch-to-buffer)))

  (defun ace-vsplit-find-file (candidate)
    (switch-window-if-gteq-3-windows)
    (my-evil-vsplit-window candidate))
  (defun helm-ace-vsplit-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-vsplit-find-file)))

  (defun ace-vsplit-switch-to-buffer (buffer-or-name)
    (switch-window-if-gteq-3-windows)
    (let ((file-name (buffer-file-name buffer-or-name)))
      (if file-name
          (my-evil-vsplit-window file-name)
        (let ((window (split-window-right)))
          (unwind-protect
              (progn
                (aw-switch-to-window window)
                (switch-to-buffer buffer-or-name)))))))

  (defun helm-ace-vsplit-sb ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-vsplit-switch-to-buffer)))

  (defun ace-helm-find-file (candidate)
    (popwin:close-popup-window)
    (if (one-window-p)
        (find-file-other-window (expand-file-name candidate))
      (let ((buf (find-file-noselect (expand-file-name candidate)))
            (window (aw-select "Ace - Window")))
        (unwind-protect
            (progn
              (aw-switch-to-window window)
              (switch-to-buffer buf))))))
  (defun helm-ace-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-helm-find-file)))
  (defun ace-helm-switch-to-buffer (buffer-or-name)
    (popwin:close-popup-window)
    (if (= (length (window-list)) 1)
        (switch-to-buffer-other-window buffer-or-name)
      (let ((buf buffer-or-name)
            (window (aw-select "Ace - Window")))
        (unwind-protect
            (progn
              (aw-switch-to-window window)
              (switch-to-buffer buf))))))
  (defun helm-ace-sb ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-helm-switch-to-buffer)))

  (define-key evil-normal-state-map (kbd ",ha") 'helm-apropos)

  (define-key helm-map (kbd "C-,") 'helm-toggle-visible-mark)
  (define-key helm-map (kbd "C-a") 'helm-select-action)
  (define-key helm-map (kbd "C-k") 'helm-previous-source)
  (define-key helm-map (kbd "C-j") 'helm-next-source)
  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-comp-read-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-comp-read-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-comp-read-map (kbd "C-o") 'helm-ace-ff)

  (define-key helm-buffer-map (kbd "C-s") 'helm-ace-split-sb)
  (define-key helm-buffer-map (kbd "C-v") 'helm-ace-vsplit-sb)
  (define-key helm-buffer-map (kbd "C-d") 'helm-buffer-run-kill-buffers)
  (define-key helm-buffer-map (kbd "C-o") 'helm-ace-sb)

  (define-key helm-find-files-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-find-files-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-find-files-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-find-files-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-find-files-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-read-file-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-read-file-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-read-file-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-read-file-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-read-file-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-generic-files-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-generic-files-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-generic-files-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-generic-files-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-generic-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-generic-files-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-ag-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-ag-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-ag-map (kbd "C-o") 'helm-ag--run-other-window-action))

(el-get-bundle helm-dash)
(use-package helm-dash
  :commands (helm-dash-at-point helm-dash helm-dash-install-docset)
  :init
  (setq helm-dash-min-length 1)
  (setq helm-dash-browser-func 'eww)
  (setq helm-dash-docsets-path (expand-file-name "~/.docsets"))
  (add-hook 'markdown-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Markdown"))))
  (add-hook 'enh-ruby-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Ruby"))))
  (add-hook 'projectile-rails-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Ruby" "Ruby on Rails"))))
  (add-hook 'emacs-lisp-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Emacs" "Emacs Lisp"))))
  (defun helm-lisp-mode ()
    (setq-local helm-dash-docsets '("Common Lisp")))
  (add-hook 'lisp-mode-hook 'helm-lisp-mode)
  (add-hook 'slime-repl-mode-hook 'helm-lisp-mode))

(el-get-bundle helm-gtags)
(use-package helm-gtags
  :diminish helm-gtags-mode
  :commands (helm-gtags-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'helm-gtags-mode)
  (setq helm-gtags-update-interval-second 1)
  (setq helm-gtags-auto-update t)
  (setq helm-gtags-preselect t)
  (setq helm-gtags-use-input-at-cursor t)
  (setq helm-gtags-path-style 'root)
  (setq helm-gtags-display-style 'detail)
  :config
  (defun helm-gtags-update-all-tags ()
    (interactive)
    (let ((how-to 'entire-update)
          (interactive-p (called-interactively-p 'interactive))
          (current-time (float-time (current-time))))
      (when (helm-gtags--update-tags-p how-to interactive-p current-time)
        (let* ((cmds (helm-gtags--update-tags-command how-to))
               (proc (apply 'start-file-process "helm-gtags-update-tag" nil cmds)))
          (if (not proc)
              (message "Failed: %s" (mapconcat 'identity cmds " "))
            (set-process-sentinel proc (helm-gtags--make-gtags-sentinel 'update))
            (setq helm-gtags--last-update-time current-time))))))
  (evil-define-key 'normal helm-gtags-mode-map
    (kbd "\C-]") 'helm-gtags-find-tag-from-here
    (kbd "\C-t") 'helm-gtags-pop-stack
    ",tc" 'helm-gtags-create-tags
    ",tf" 'helm-gtags-select
    ",tu" 'helm-gtags-update-tags
    ",tU" 'helm-gtags-update-all-tags
    ",td" 'helm-gtags-find-tag
    ",tr" 'helm-gtags-find-rtag
    ",tn" 'helm-gtags-next-history
    ",tp" 'helm-gtags-previous-history)
  )

(el-get-bundle helm-open-github)
(use-package helm-open-github
  :commands (helm-open-github-from-file
             helm-open-github-from-commit
             helm-open-github-from-issues
             helm-open-github-from-pull-requests))

(el-get-bundle rainbow-delimiters)
(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode)
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(el-get-bundle auto-complete)
(use-package auto-complete-config
  :diminish auto-complete-mode
  :commands (ac-config-default)
  :init
  (add-hook 'evil-mode-hook 'ac-config-default)
  :config
  (use-package auto-complete
    :init
    (setq ac-auto-start 3
          ac-delay 0.2
          ac-auto-show-menu t
          ac-max-width 0.4
          ac-quick-help-delay 0.5
          ac-quick-help-prefer-pos-tip t
          ac-use-fuzzy t
          ac-use-comphist t
          ac-fuzzy-enable t
          tab-always-indent t
          ac-use-menu-map t
          ac-dwim t)
    (setq-default ac-sources '(ac-source-filename
                               ac-abbrev
                               ac-source-dictionary
                               ac-source-words-in-same-mode-buffers))
    (add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
    :config
    (evil-define-key 'insert ac-menu-map (kbd "C-n") 'ac-next)
    (evil-define-key 'insert ac-menu-map (kbd "C-p") 'ac-previous)
    (evil-define-key 'insert ac-menu-map (kbd "<S-tab>") 'ac-previous)
    (ac-set-trigger-key "TAB")))

(use-package eldoc
  :diminish eldoc-mode
  :commands (eldoc-mode)
  :init
  (add-hook 'prog-mode-hook 'eldoc-mode))

;; git
(el-get-bundle magit)
(el-get-bundle magit-gh-pulls)
(el-get-bundle gist)
(el-get-bundle git-gutter)
(el-get-bundle git-messenger)
(el-get-bundle git-timemachine)

(use-package git-timemachine
  :commands (git-timemachine)
  :config
  (evil-set-initial-state 'git-timemachine-mode 'motion)
  (evil-define-key 'motion git-timemachine-mode-map
    "p" 'git-timemachine-show-previous-revision
    "n" 'git-timemachine-show-next-revision
    "g" 'git-timemachine-show-nth-revision
    "q" 'git-timemachine-quit
    "w" 'git-timemachine-kill-abbreviated-revision
    "W" 'git-timemachine-kill-revision))

(use-package git-messenger
  :commands (git-messenger:popup-message))

(use-package magit
  :commands (magit-status magit-blame-popup
                          magit-fetch-popup magit-branch-popup)
  :init
  (add-hook 'magit-mode-hook '(lambda () (linum-mode -1)))
  (add-hook 'magit-status-mode-hook 'delete-other-windows)
  (setq magit-push-always-verify nil)
  (setq magit-branch-arguments nil)
  (setq magit-status-buffer-switch-function 'switch-to-buffer)
  :config
  (use-package ert)
  ;; (use-package magit-gh-pulls
  ;;   :commands (turn-on-magit-gh-pulls)
  ;;   :init
  ;;   (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))
  (evil-set-initial-state 'magit-mode 'normal)
  (evil-set-initial-state 'magit-status-mode 'insert)
  (evil-set-initial-state 'magit-diff-mode 'insert)
  (evil-set-initial-state 'magit-log-mode 'insert)
  (evil-set-initial-state 'magit-reflog-mode 'normal)
  (evil-set-initial-state 'magit-process-mode 'normal)
  (evil-set-initial-state 'magit-blame-mode 'motion)
  (evil-set-initial-state 'magit-revision-mode 'normal)

  (define-key magit-blame-mode-map "q" 'magit-blame-quit)
  (define-key magit-blame-mode-map "b" 'magit-blame-popup)
  (define-key magit-blame-mode-map "r" 'magit-show-commit)
  (define-key magit-blame-mode-map "s" 'magit-diff-show-or-scroll-up)
  (define-key magit-blame-mode-map "d" 'magit-diff-show-or-scroll-down)
  (define-key magit-blame-mode-map "n" 'magit-blame-next-chunk)
  (define-key magit-blame-mode-map "N" 'magit-blame-next-chunk-same-commit)
  (define-key magit-blame-mode-map "p" 'magit-blame-previous-chunk)
  (define-key magit-blame-mode-map "P" 'magit-blame-previous-chunk-same-commit)
  (define-key magit-blame-mode-map "t" 'magit-blame-toggle-headings)
  (define-key magit-blame-mode-map "y" 'magit-blame-copy-hash)

  (define-key magit-mode-map "\s" nil) ;space I use space as my evil-leader key
  (define-key magit-diff-mode-map "\s" nil) ;space
  (define-key magit-diff-mode-map "j" 'next-line)

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
  (define-key magit-tag-section-map "K" 'magit-tag-delete)

  (use-package git-rebase
    :config
    (define-key git-rebase-mode-map "RET" 'git-rebase-show-commit)
    (define-key git-rebase-mode-map "x" 'git-rebase-exec)
    (define-key git-rebase-mode-map "u" 'git-rebase-undo)
    (define-key git-rebase-mode-map "p" 'git-rebase-pick)
    (define-key git-rebase-mode-map "e" 'git-rebase-edit)
    (define-key git-rebase-mode-map "f" 'git-rebase-fixup)
    (define-key git-rebase-mode-map "s" 'git-rebase-squash)
    (define-key git-rebase-mode-map "K" 'git-rebase-kill-line)
    (define-key git-rebase-mode-map "k" 'git-rebase-move-line-up)
    (define-key git-rebase-mode-map "j" 'git-rebase-move-line-down)))

(use-package gist
  :commands (gist-list gist-region gist-region-private
                       gist-buffer gist-buffer-private))

(use-package git-gutter
  :diminish git-gutter-mode
  :commands (git-gutter-mode)
  :init
  (add-hook 'projectile-mode-hook 'git-gutter-mode)
  (setq git-gutter:update-interval 2)
  :config
  (setq git-gutter:modified-sign "**"
        git-gutter:added-sign    "++"
        git-gutter:deleted-sign  "--")
  (set-face-foreground 'git-gutter:modified "#eee8d5")
  (set-face-foreground 'git-gutter:added "#859900")
  (set-face-foreground 'git-gutter:deleted "#dc322f")
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
  (add-hook 'evil-mode-hook 'projectile-global-mode)
  (add-hook 'projectile-global-mode-hook 'helm-projectile-on))

;; rails
(el-get-bundle projectile-rails)
(use-package projectile-rails
  :commands (projectile-rails-on)
  :init
  (add-hook 'enh-ruby-mode-hook 'projectile-rails-on)
  (defun set-projectile-rails-tags-command ()
    (interactive)
    (when (projectile-rails-root)
      (setq projectile-tags-command (concat "ctags -Re -f TAGS --languages=+Ruby --languages=-JavaScript " (projectile-rails-root)))))
  (add-hook 'projectile-rails-mode-hook 'set-projectile-rails-tags-command)
(defun define-rails-find-file-in (dir)
    (let* ((normalized-dir (subst-char-in-string ?/ ?- (substring dir 0 -1)))
           (fname (intern (concat "find-file-in-" normalized-dir))))
      `(defun ,fname ()
         (interactive)
         (let* ((rails-root (projectile-rails-root))
                (target-dir (concat rails-root ,dir)))
           (message target-dir)
           (helm-find-files-1 target-dir)))))
(defmacro rails-find-file-in (dirs)
    `(progn
       ,@(mapcar #'define-rails-find-file-in
                 dirs)))
(defmacro rails-find-file-current (dir re fallback)
    `(let* ((singular (projectile-rails-current-resource-name))
            (plural (pluralize-string singular))
            (abs-current-file (buffer-file-name (current-buffer)))
            (current-file (if abs-current-file
                              (file-relative-name abs-current-file
                                                  (projectile-project-root))))
            (choices (projectile-rails-choices
                      (list (list ,dir (s-lex-format ,re)))))
            (files (projectile-rails-hash-keys choices))
            (target-dir (concat (projectile-rails-root)
                                (f-dirname (gethash (-first-item files) choices)))))
       (message "target-dir: %s" target-dir)
       (if (eq files ())
           (funcall ,fallback)
         (helm-find-files-1 target-dir))))
  (defun find-file-current-model ()
    (interactive)
    (rails-find-file-current "app/models/"
                             "/${singular}\\.rb$"
                             'projectile-rails-find-model))

  (defun find-file-current-controller ()
    (interactive)
    (rails-find-file-current "app/controllers/"
                             "app/controllers/\\(.*${plural}\\)_controller\\.rb$"
                             'projectile-rails-find-controller))

  (defun find-file-current-view ()
    (interactive)
    (rails-find-file-current "app/views/"
                             "/${plural}/\\(.+\\)$"
                             'projectile-rails-find-view))
  :config
  (evil-define-key 'normal projectile-rails-mode-map ",ris" 'projectile-rails-server)
  (evil-define-key 'normal projectile-rails-mode-map ",rir" 'projectile-rails-rake)
  (evil-define-key 'normal projectile-rails-mode-map ",rig" 'projectile-rails-generate)
  (evil-define-key 'normal projectile-rails-mode-map ",rer" 'projectile-rails-extract-region)
  (evil-define-key 'normal projectile-rails-mode-map ",gf" 'projectile-rails-goto-file-at-point)
  (evil-define-key 'normal projectile-rails-mode-map ",gm" 'projectile-rails-goto-gemfile)
  (evil-define-key 'normal projectile-rails-mode-map ",gr" 'projectile-rails-goto-routes)

  (rails-find-file-in ("spec/"
                       "spec/controllers/"
                       "spec/factories/"
                       "spec/features/"
                       "spec/jobs/"
                       "spec/lib/"
                       "spec/mailers/"
                       "spec/models/"
                       "spec/requests/"
                       "spec/routing/"
                       "spec/services/"))

  (evil-define-key 'normal projectile-rails-mode-map ",rtt" 'find-file-in-spec)
  (evil-define-key 'normal projectile-rails-mode-map ",rtc" 'find-file-in-spec-controllers)
  (evil-define-key 'normal projectile-rails-mode-map ",rtf" 'find-file-in-spec-factories)
  (evil-define-key 'normal projectile-rails-mode-map ",rtj" 'find-file-in-spec-jobs)
  (evil-define-key 'normal projectile-rails-mode-map ",rtl" 'find-file-in-spec-lib)
  (evil-define-key 'normal projectile-rails-mode-map ",rtm" 'find-file-in-spec-models)
  (evil-define-key 'normal projectile-rails-mode-map ",rtr" 'find-file-in-spec-requests)
  (evil-define-key 'normal projectile-rails-mode-map ",rts" 'find-file-in-spec-services)

  (rails-find-file-in ("config/"
                       "config/initializers/"
                       "config/environments/"
                       "config/locales/"
                       "config/settings/"
                       "db/migrate/"
                       "db/ridgepole/"
                       "lib/"))

  (evil-define-key 'normal projectile-rails-mode-map ",rCC" 'find-file-in-config)
  (evil-define-key 'normal projectile-rails-mode-map ",rCi" 'find-file-in-config-initializers)
  (evil-define-key 'normal projectile-rails-mode-map ",rCe" 'find-file-in-config-environments)
  (evil-define-key 'normal projectile-rails-mode-map ",rCl" 'find-file-in-config-locales)
  (evil-define-key 'normal projectile-rails-mode-map ",rCs" 'find-file-in-config-settings)
  (evil-define-key 'normal projectile-rails-mode-map ",rdm" 'find-file-in-db-migrate)
  (evil-define-key 'normal projectile-rails-mode-map ",rdr" 'find-file-in-db-ridgepole)
  (evil-define-key 'normal projectile-rails-mode-map ",rfl" 'find-file-in-lib)

  (rails-find-file-in ("app/"
                       "app/controllers/"
                       "app/helpers/"
                       "app/jobs/"
                       "app/mailers/"
                       "app/models/"
                       "app/services/"
                       "app/validators/"
                       "app/views/"))

  (evil-define-key 'normal projectile-rails-mode-map ",rfa" 'find-file-in-app)
  (evil-define-key 'normal projectile-rails-mode-map ",rfc" 'find-file-in-app-controllers)
  (evil-define-key 'normal projectile-rails-mode-map ",rfh" 'find-file-in-app-helpers)
  (evil-define-key 'normal projectile-rails-mode-map ",rfj" 'find-file-in-app-jobs)
  (evil-define-key 'normal projectile-rails-mode-map ",rfm" 'find-file-in-app-models)
  (evil-define-key 'normal projectile-rails-mode-map ",rfs" 'find-file-in-app-services)
  (evil-define-key 'normal projectile-rails-mode-map ",rfv" 'find-file-in-app-views)
  (evil-define-key 'normal projectile-rails-mode-map ",rcm" 'find-file-current-model)
  (evil-define-key 'normal projectile-rails-mode-map ",rcc" 'find-file-current-controller)
  (evil-define-key 'normal projectile-rails-mode-map ",rcv" 'find-file-current-view)
  )

;; syntax check
(el-get-bundle flycheck)
(el-get-bundle flycheck-pos-tip)
(use-package flycheck
  :diminish flycheck-mode
  :commands (global-flycheck-mode)
  :init
  (add-hook 'after-init-hook 'global-flycheck-mode))

(use-package flycheck-pos-tip
  :commands (flycheck-pos-tip-error-messages)
  :init
  (setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; markdown
(el-get-bundle markdown-mode)
(el-get-bundle markdown-toc)
(use-package markdown-mode
  :mode (("\\.markdown\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("PULLREQ_MSG" . gfm-mode))
  :init
  (add-hook 'markdown-mode-hook '(lambda () (set (make-local-variable 'tab-width) 2))))

;; ruby
(setq ruby-insert-encoding-magic-comment nil)
(el-get-bundle ruby-end)
(el-get-bundle bundler)
(el-get-bundle rbenv)
(el-get-bundle robe)
(el-get-bundle inf-ruby)
(el-get-bundle enh-ruby-mode)
(el-get-bundle ruby-test-mode)

(use-package rbenv
  :commands (global-rbenv-mode rbenv-use-global rbenv-use-corresponding)
  :init
  (setq rbenv-show-active-ruby-in-modeline nil)
  (add-hook 'enh-ruby-mode-hook 'global-rbenv-mode)
  (add-hook 'enh-ruby-mode-hook (lambda () (rbenv-use-corresponding))))
(use-package inf-ruby
  :commands (inf-ruby inf-ruby-minor-mode inf-ruby-console-auto)
  :init
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
  :config
  (evil-define-key 'normal inf-ruby-mode-map (kbd ",ric") 'inf-ruby-console-auto))
(use-package ac-robe
  :commands (ac-robe-setup))
(use-package robe
  :diminish robe-mode
  :commands (robe-mode robe-start)
  :init
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  :config
  (defun enable-robe-server ()
    (interactive)
    (robe-start)
    (ac-robe-setup))
  (evil-define-key 'normal robe-mode-map (kbd ",rs") 'enable-robe-server)
  (evil-define-key 'normal robe-mode-map (kbd ",rh") 'robe-doc)
  (evil-define-key 'normal robe-mode-map (kbd ",ra") 'robe-ask)
  (evil-define-key 'normal robe-mode-map (kbd ",rj") 'robe-jump)
  (evil-define-key 'normal robe-mode-map (kbd ",rR") 'robe-rails-refresh))
(use-package enh-ruby-mode
  :mode (("\\(Rake\\|Thor\\|Guard\\|Gem\\|Cap\\|Vagrant\\|Berks\\|Pod\\|Puppet\\)file\\'" . enh-ruby-mode)
         ("\\.\\(rb\\|rabl\\|ru\\|builder\\|rake\\|thor\\|gemspec\\|jbuilder\\|schema\\|cap\\)\\'" . enh-ruby-mode)
         ("Schema" . enh-ruby-mode))
  :interpreter ("ruby" . enh-ruby-mode)
  :init
  (add-hook 'enh-ruby-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-abbrev)))
  (setq tab-width 2)
  (modify-syntax-entry ?_ "w")
  (setq enh-ruby-deep-indent-paren nil
        enh-ruby-hanging-paren-deep-indent-level 2)
  (setq enh-ruby-add-encoding-comment-on-save nil)
  ;; (add-hook 'enh-ruby-mode-hook '(lambda () (setq-local selective-display 4)))
  (add-hook 'enh-ruby-mode-hook 'auto-complete-mode)
  (add-hook 'enh-ruby-mode-hook '(lambda () (smartparens-mode)))
  ;; (add-hook 'enh-ruby-mode-hook 'electric-pair-mode)
  ;; (add-hook 'enh-ruby-mode-hook 'electric-indent-mode)
  ;; (add-hook 'enh-ruby-mode-hook 'electric-layout-mode)
  ;; (custom-set-faces
  ;;  '(enh-ruby-op-face ((t (:foreground "headerColor"))))
  ;;  '(enh-ruby-string-delimiter-face ((t (:foreground "#d33682")))))
  :config
  (use-package bundler
    :commands (bundle-open bundle-exec bundle-check bundle-gemfile
                           bundle-update bundle-console bundle-install))
  (evil-define-key 'normal enh-ruby-mode-map (kbd ",be") 'bundle-exec)
  (evil-define-key 'normal enh-ruby-mode-map (kbd ",bc") 'bundle-console)
  (evil-define-key 'normal enh-ruby-mode-map (kbd ",bg") 'bundle-gemfile)
  (evil-define-key 'normal enh-ruby-mode-map (kbd ",bu") 'bundle-update)
  (evil-define-key 'normal enh-ruby-mode-map (kbd ",bi") 'bundle-install)
  (evil-define-key 'normal enh-ruby-mode-map (kbd ",bo") 'bundle-open)
  ;; (evil-define-key 'insert electric-pair-mode-map (kbd "C-h")
  ;;   `(menu-item
  ;;     "" electric-pair-delete-pair
  ;;     :filter
  ;;     ,(lambda (cmd)
  ;;        (let* ((prev (char-before))
  ;;               (next (char-after))
  ;;               (syntax-info (and prev
  ;;                                 (electric-pair-syntax-info prev)))
  ;;               (syntax (car syntax-info))
  ;;               (pair (cadr syntax-info)))
  ;;          (and next pair
  ;;               (memq syntax '(?\( ?\" ?\$))
  ;;               (eq pair next)
  ;;               (if (functionp electric-pair-delete-adjacent-pairs)
  ;;                   (funcall electric-pair-delete-adjacent-pairs)
  ;;                 electric-pair-delete-adjacent-pairs)
  ;;               cmd)))))
  )
(use-package ruby-test-mode
  :diminish ruby-test-mode
  :commands (ruby-test-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'ruby-test-mode)
  :config
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tt") 'ruby-test-run-at-point)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tb") 'ruby-test-run)
  (defun ruby-test-toggle-vsplit ()
    (interactive)
    (let ((window (split-window-right)))
      (message "%s" window)
      (select-window window)
      (balance-windows)
      (ruby-test-toggle-implementation-and-specification)))
  (defun ruby-test-toggle-split ()
    (interactive)
    (let ((window (split-window (selected-window) nil 'above)))
      (select-window window)
      (balance-windows)
      (ruby-test-toggle-implementation-and-specification)))
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tv") 'ruby-test-toggle-vsplit)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",ts") 'ruby-test-toggle-split))
;; (use-package ruby-end
;;   :commands (ruby-end-mode)
;;   :init
;;   (add-hook 'enh-ruby-mode-hook 'ruby-end-mode))

;; html, erb
(el-get-bundle web-mode)
(use-package web-mode
  :mode (("\\.erb\\'" . web-mode)
         ("\\.html?\\'" . web-mode))
  :init
  (add-hook 'web-mode-hook '(lambda () (turn-off-smartparens-mode)))
  (setq web-mode-markup-indent-offset 2))

;; shell
(use-package eshell
  :commands (eshell)
  :config
  (use-package pcomplete)
  (add-to-list 'ac-modes 'eshell-mode)
  (ac-define-source pcomplete
    '((candidates . pcomplete-completions)))
  (defun my-eshell-mode-hook ()
    (setq ac-sources
          '(ac-source-pcomplete
            ac-source-filename
            ac-source-files-in-current-dir
            ac-source-words-in-buffer
            ac-source-dictionary))
    (evil-define-key 'insert eshell-mode-map (kbd "C-p") 'helm-eshell-history))
  (add-hook 'eshell-mode-hook 'my-eshell-mode-hook)
  (setq eshell-highlight-prompt t)
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-cmpl-cycle-completions nil)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-save-history-on-exit t)
  (setq eshell-command-aliases-list
        (append (list
                 (list "emacs" "find-file $1")
                 (list "ppr" "find-file PULLREQ_MSG")
                 (list "pr" "hub pull-request -b $1 -F PULLREQ_MSG && kill-buffer PULLREQ_MSG && rm PULLREQ_MSG")
                 (list "b" "bundle exec $*")
                 (list "rails" "bundle exec rails $*")
                 (list "rake" "bundle exec rake $*")
                 (list "rc" "bundle exec rails c")
                 (list "rct" "bundle exec rails c test")
                 (list "rgm" "bundle exec rails g migration $*")
                 (list "rgmc" "bundle exec rails g migration create_$1")
                 (list "ridgepole-test" "bundle exec rake db:ridgepole:apply[test]")
                 (list "ridgepole-dev" "bundle exec rake db:ridgepole:apply[development]"))
                ())))

(el-get-bundle eshell-prompt-extras)
(use-package eshell-prompt-extras
  :commands (epe-theme-dakrone epe-theme-lambda)
  :init
  (setq eshell-prompt-function 'epe-theme-dakrone)
  (add-hook 'eshell-mode-hook 'epe-theme-dakrone))
(el-get-bundle shell-pop)
(use-package shell-pop
  :commands (shell-pop)
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

;; (el-get-bundle avy)
;; (use-package avy
;;   :commands (avy-goto-char-2 avy-goto-word-1 avy-goto-line)
;;   :init
;;   (setq avy-all-windows nil)
;;   (setq avy-keys (number-sequence ?a ?z))
;;   (define-key evil-normal-state-map (kbd "f") 'avy-goto-char-2)
;;   (evil-leader/set-key "<SPC>" 'avy-goto-word-1)
;;   (evil-leader/set-key "l" 'avy-goto-line))

(el-get-bundle popwin)
(use-package popwin
  :commands (popwin-mode)
  :init
  (setq popwin:adjust-other-windows t)
  (setq popwin:popup-window-position 'bottom)
  (setq popwin:popup-window-height 0.3)
  (add-hook 'after-init-hook #'(lambda () (popwin-mode t)))
  :config
  (push '(inf-ruby-mode :height 0.3 :stick t :position bottom) popwin:special-display-config)
  (push '("*Process List*" :noselect t) popwin:special-display-config)
  (push '("*Warnings*" :height 0.3 :noselect t) popwin:special-display-config)
  (push '("*Flycheck errors*" :stick t :height 0.3 :noselect t) popwin:special-display-config)
  (push '("*compilation*" :stick t :height 0.2 :tail t :noselect t)
        popwin:special-display-config)
  (push '("*Codic Result*" :noselect t :stick t) popwin:special-display-config)
  (push "*slime-apropos*" popwin:special-display-config)
  (push '("*slime-macroexpansion*" :noselect t :height 0.3) popwin:special-display-config)
  (push "*slime-description*" popwin:special-display-config)
  (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
  (push "*slime-xref*" popwin:special-display-config)
  (push '("*inferior-lisp*" :noselect t :tail t :stick t) popwin:special-display-config)
  (push '(sldb-mode :stick t) popwin:special-display-config)
  (push '(slime-repl-mode :stick t :position bottom :height 0.3) popwin:special-display-config)
  (push 'slime-connection-list-mode popwin:special-display-config)
  (push '("*alchemist-eval-mode*" :noselect t :height 0.2) popwin:special-display-config)
  (push '("*Alchemist-IEx*" :noselect t :height 0.2) popwin:special-display-config)
  (push '("*alchemist help*" :noselect t :height 0.3) popwin:special-display-config)
  (push '("*elixirc*" :noselect t) popwin:special-display-config))

;; (el-get-bundle hydra)
;; (use-package hydra
;;   :config
;;   (defhydra helm-like-unite (:hint nil
;;                                    :color pink)
;;     "
;; ------------------------------------------------------------------------
;; | [K] ScrollUp   | [k] move up   | [m] mark   | [v] view   | [i] cancel |
;; | [J] ScrollDown | [j] move down | [t] toggle | [H] help   | [o] quit   |
;; | [h] left       |               | [d] delete |            |            |
;; | [l] right      | [u] unmark    | [y] yank   | [w] toggle |            |
;; |                |     all       | [f] follow |     window |            |
;; ------------------------------------------------------------------------
;; "
;;     ("h" helm-beginning-of-buffer)
;;     ("j" helm-next-line)
;;     ("k" helm-previous-line)
;;     ("l" helm-end-of-buffer)
;;     ("g" helm-beginning-of-buffer)
;;     ("G" helm-end-of-buffer)
;;     ("K" helm-scroll-other-window-down)
;;     ("J" helm-scroll-other-window)
;;     ("m" helm-toggle-visible-mark)
;;     ("t" helm-toggle-all-marks)
;;     ("u" helm-unmark-all)
;;     ("<escape>" keyboard-escape-quit "" :exit t)
;;     ("o" keyboard-escape-quit :exit t)
;;     ("i" nil)
;;     ("n" helm-next-source)
;;     ("p" helm-previous-source)
;;     ("H" helm-help)
;;     ("v" helm-execute-persistent-action)
;;     ("y" helm-yank-selection)
;;     ("w" helm-toggle-resplit-and-swap-windows)
;;     ("a" helm-select-action)
;;     ("d" helm-delete-marked-files)
;;     ("r" helm-ff-run-rename-file)
;;     ("f" helm-follow-mode))
;;   (define-key helm-map (kbd "<escape>") 'helm-like-unite/body)
;;   (define-key helm-map (kbd "C-k") 'helm-like-unite/body))

;; lisp
(el-get-bundle slime)
(el-get-bundle ac-slime)
(use-package slime
  :commands (slime-mode)
  :init
  (add-hook 'slime-repl-mode-hook '(lambda () (turn-off-smartparens-mode)))
  (add-hook 'lisp-mode-hook 'slime-mode)
  (let ((hyperspec-location "/usr/local/share/doc/hyperspec/HyperSpec/"))
    (setq common-lisp-hyperspec-root hyperspec-location)
    (setq common-lisp-hyperspec-symbol-table (concat hyperspec-location "Data/Map_Sym.txt"))
    (setq common-lisp-hyperspec-issuex-table (concat hyperspec-location "Data/Map_IssX.txt")))
  (defun eww-open-hyperspec (file &optional _new-window)
    (eww (concat "file://"
                 (and (memq system-type '(windows-nt ms-dos))
                      "/")
                 (expand-file-name file))))
  (add-hook 'slime-mode-hook '(lambda () (setq-local browse-url-browser-function 'eww-open-hyperspec)))
  (setq tab-width 2)
  (setq slime-complete-symbol*-fancy t)
  (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
  (defun set-inferior-lisp-program ()
    (interactive)
    (if (executable-find "ros")
        (progn
          (message (executable-find "ros"))
          (let ((slime-helper "~/.roswell/impls/ALL/ALL/quicklisp/slime-helper.el"))
            (if (file-exists-p slime-helper)
                (load (expand-file-name slime-helper))
              (shell-command "ros -Q -e '(ql:quickload :quicklisp-slime-helper)' -q")))
          (setq inferior-lisp-program "ros -L sbcl -Q -l ~/.sbclrc run"))
      (setq inferior-lisp-program (executable-find "sbcl"))))
  (add-hook 'lisp-mode-hook 'set-inferior-lisp-program)
  (setq slime-contribs '(slime-repl slime-fancy slime-banner slime-fuzzy))
  (add-hook 'slime-repl-mode-hook (lambda () (linum-mode -1)))
  :config
  (evil-define-key 'normal slime-mode-map (kbd ",me") 'slime-macroexpand-1)
  (evil-define-key 'normal slime-mode-map (kbd ",cc") 'slime-compile-file)
  (evil-define-key 'normal slime-mode-map (kbd ",cC") 'slime-compile-and-load-file)
  (evil-define-key 'normal slime-mode-map (kbd ",cf") 'slime-compile-defun)
  (evil-define-key 'visual slime-mode-map (kbd ",cr") 'slime-compile-region)
  (evil-define-key 'normal slime-mode-map (kbd ",eb") 'slime-eval-buffer)
  (evil-define-key 'normal slime-mode-map (kbd ",ef") 'slime-eval-defun)
  (evil-define-key 'normal slime-mode-map (kbd ",ee") 'slime-eval-last-sexp)
  (evil-define-key 'visual slime-mode-map (kbd ",er") 'slime-eval-region)
  (evil-define-key 'normal slime-mode-map (kbd ",gg") 'slime-inspect-definition)
  (evil-define-key 'normal slime-mode-map (kbd ",hA") 'slime-apropos)
  (evil-define-key 'normal slime-mode-map (kbd ",hh") 'slime-hyperspec-lookup)
  (evil-define-key 'normal slime-mode-map (kbd ",hF") 'slime-describe-function)
  (evil-define-key 'normal slime-mode-map (kbd ",hi") 'slime-inspect-definition)
  (evil-define-key 'normal slime-mode-map (kbd ",si") 'slime)
  (evil-define-key 'normal slime-mode-map (kbd ",sq") 'slime-quit-lisp)
  (evil-define-key 'normal slime-mode-map (kbd ",sr") 'slime-restart-inferior-lisp)
  (evil-define-key 'normal slime-mode-map (kbd ",r") 'slime-repl)
  (slime-setup '(slime-repl slime-fancy slime-banner slime-fuzzy slime-indentation))
  (use-package ac-slime
    :commands (set-up-slime-ac)
    :init
    (add-hook 'slime-mode-hook '(lambda () (set-up-slime-ac t)))
    (add-hook 'slime-repl-mode-hook '(lambda () (set-up-slime-ac t)))))

;; theme
;; (el-get-bundle bbatsov/solarized-emacs)
;; (setq solarized-distinct-fringe-background t)
;; (setq solarized-use-variable-pitch nil)
;; (setq solarized-high-contrast-mode-line t)
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/solarized-emacs")
;; (load-theme 'solarized-dark t)

;; (el-get-bundle color-theme-solarized)
;; (set-frame-parameter nil 'background-mode 'dark)
;; (set-terminal-parameter nil 'background-mode 'dark)
;; (load-theme 'solarized t)

(el-get-bundle material-theme)
(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/material-theme")
(load-theme 'material t)

;; (el-get-bundle aurora-theme)
;; (add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/aurora-theme")
;; (load-theme 'aurora t)

(el-get-bundle powerline)
(el-get-bundle TheBB/spaceline)
(use-package spaceline-config
  :commands (spaceline-define-segment spaceline-install spaceline-spacemacs-theme)
  :init
  (add-hook 'evil-mode-hook 'install-my-spaceline-theme)
  (setq powerline-height 25)
  (setq powerline-default-separator 'wave)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (defun install-my-spaceline-theme ()
    (spaceline-install
     '((evil-state
        :face highlight-face)
       ;; ((workspace-number window-number)
       ;;  :fallback evil-state
       ;;  :separator "|"
       ;;  :face highlight-face)
       (buffer-modified buffer-size buffer-id remote-host)
       ((flycheck-error flycheck-warning flycheck-info)
        :when active)
       major-mode
       (((minor-modes :separator spaceline-minor-modes-separator)
         process)
        )
       (erc-track :when active)
       (version-control :when active)
       (org-pomodoro :when active)
       (org-clock :when active)
       nyan-cat)

     `((battery :when active)
       selection-info
       ((buffer-encoding-abbrev
         point-position
         line-column)
        :separator " | ")
       buffer-position
       (global :when active)
       (rbenv :when active)
       hud)))
  :config
  (spaceline-define-segment rbenv
    "ruby version used in rbenv"
    (rbenv--update-mode-line)
    :when (bound-and-true-p global-rbenv-mode))
  )

;; (el-get-bundle powerline)
;; (el-get-bundle powerline-evil)
;; (use-package powerline-evil
;;   :commands (powerline-evil-vim-color-theme)
;;   :init
;;   (add-hook 'evil-mode-hook 'powerline-evil-vim-color-theme)
;;   (setq powerline-default-separator 'arrow)
;;   (setq powerline-evil-tag-style 'verbose)
;;   :config
;;   ;; (custom-set-faces
;;   ;;  '(mode-line ((t (:background "#002b36" :foreground "#fdf6e3" :inverse-video t :box nil))))
;;   ;;  '(mode-line-inactive ((t (:background "#eee8d5" :foreground "#586e75" :inverse-video t :box nil))))
;;   ;;  '(powerline-active1 ((t (:background "#002b36" :foreground "#eee8d5"))))
;;   ;;  '(powerline-active2 ((t (:background "#002b36" :foreground "#eee8d5"))))
;;   ;;  '(powerline-evil-base-face ((t (:background "#fdf6e3" :foreground "#002b36" :width extra-expanded))))
;;   ;;  '(powerline-evil-insert-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#657b83"))))
;;   ;;  '(powerline-evil-normal-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#268bd2"))))
;;   ;;  '(powerline-evil-operator-face ((t (:inherit powerline-evil-operator-face :background "#fdf6e3" :foreground "#b58900"))))
;;   ;;  '(powerline-evil-visual-face ((t (:inherit powerline-evil-base-face :background "#fdf6e3" :foreground "#d33682"))))
;;   ;;  '(powerline-inactive1 ((t (:inherit mode-line-inactive :background "#fdf6e3" :foreground "#586e75"))))
;;   ;;  '(powerline-inactive2 ((t (:inherit mode-line-inactive :foreground "#586e75")))))
;;   ;; (powerline-evil-vim-color-theme)
;;   )

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
                                     "slime-repl-mode"
                                     ))
  (setq golden-ratio-exclude-buffer-names '(
                                            "*compilation*"
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

(el-get-bundle yaml-mode)
(use-package yaml-mode
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode)))

;; (el-get-bundle elscreen)
;; (use-package elscreen
;;   :commands (elscreen-start)
;;   :init
;;   (add-hook 'after-init-hook 'elscreen-start)
;;   :config
;;   (defvar evil-jumper--screen-jump-list
;;     (make-hash-table))
;;   (defadvice evil-jumper--get-current
;;       (before evil-jumper--get-current-per-screen activate)
;;     (let* ((screen (elscreen-get-current-screen))
;;            (window-jump
;;             (gethash screen evil-jumper--screen-jump-list)))
;;       (unless window-jump
;;         (setq window-jump (make-hash-table))
;;         (puthash screen window-jump
;;                  evil-jumper--screen-jump-list))
;;       (setf evil-jumper--window-jumps window-jump)))
;;   (evil-leader/set-key "he" 'helm-elscreen)
;;   (define-key evil-normal-state-map (kbd "tt") 'elscreen-create)
;;   (define-key evil-normal-state-map (kbd "tn") 'elscreen-next)
;;   (define-key evil-normal-state-map (kbd "tp") 'elscreen-previous)
;;   (define-key evil-normal-state-map (kbd "td") 'elscreen-dired)
;;   (define-key evil-normal-state-map (kbd "tf") 'elscreen-find-file)
;;   (define-key evil-normal-state-map (kbd "tb") 'elscreen-find-and-goto-by-buffer)
;;   (define-key evil-normal-state-map (kbd "tC") 'elscreen-kill)
;;   (define-key evil-normal-state-map (kbd "tc") 'elscreen-kill-screen-and-buffers))

(el-get-bundle open-junk-file)
(use-package open-junk-file
  :commands (open-junk-file)
  :config
  (setq open-junk-file-format "~/Dropbox/junk/%Y-%m%d-%H%M%S."))

(el-get-bundle org)
(use-package org
  :mode (("\\.org\\'" . org-mode))
  :config
  (setq org-src-fontify-natively t)
  (setq org-directory "~/Dropbox/junk")
  (setq org-agenda-files (list org-directory)))

(el-get-bundle pdf-tools)
(use-package pdf-tools
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :init
  (global-linum-mode -1)
  (add-hook 'pdf-view-mode-hook 'pdf-view-dark-minor-mode)
  (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
  :config
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-define-key 'normal pdf-view-mode-map "g" 'pdf-view-goto-page)
  (evil-define-key 'normal pdf-view-mode-map "j" 'pdf-view-scroll-up-or-next-page)
  (evil-define-key 'normal pdf-view-mode-map "k" 'pdf-view-scroll-down-or-previous-page)
  (evil-define-key 'normal pdf-view-mode-map "h" 'left-char)
  (evil-define-key 'normal pdf-view-mode-map "l" 'right-char)
  (evil-define-key 'normal pdf-view-mode-map "d" 'pdf-view-next-page-command)
  (evil-define-key 'normal pdf-view-mode-map "u" 'pdf-view-previous-page-command)
  (evil-define-key 'normal pdf-view-mode-map "+" 'pdf-view-enlarge)
  (evil-define-key 'normal pdf-view-mode-map "-" 'pdf-view-shrink)
  (evil-define-key 'normal pdf-view-mode-map "=" 'pdf-view-fit-width-to-window)
  (evil-define-key 'normal pdf-view-mode-map "o" 'pdf-outline)
  (evil-define-key 'normal pdf-view-mode-map "b" 'pdf-view-position-to-register)
  (evil-define-key 'normal pdf-view-mode-map "B" 'pdf-view-jump-to-register)
  (defun mcc-pdf-view-save ()
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (when (eql major-mode 'pdf-view-mode)
                    (setq-local pdf-view-last-visited-page
                                (pdf-view-current-page))))))

  (defun mcc-pdf-view-restore ()
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (when (eql major-mode 'pdf-view-mode)
                    (pdf-view-goto-page pdf-view-last-visited-page)))))

  (add-hook 'popwin:before-popup-hook #'mcc-pdf-view-save)
  (add-hook 'popwin:after-popup-hook #'mcc-pdf-view-restore)
  ;; (use-package pdf-annot)
  (use-package pdf-links)
  (use-package pdf-info)
  (use-package pdf-misc)
  (use-package pdf-sync)
  (use-package pdf-outline))

;; for objective-c
(add-to-list 'auto-mode-alist '("\\.mm?$" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

(el-get-bundle google-c-style)
(use-package google-c-style
  :commands (google-set-c-style)
  :init
  (add-hook 'objc-mode-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-set-c-style))

;; (el-get-bundle yuya373/xcode-headers)
;; (el-get-bundle clang-complete-async)
;; (use-package auto-complete-clang-async
;;   :commands (ac-clang-launch-completion-process)
;;   :init
;;   ;; (use-package xcode-headers
;;   ;;   :init
;;   ;;   (setq xcode-headers-src-root (expand-file-name "~/dev/PalmX/proj.ios_mac/"))
;;   ;;   (setq xcode-headers-pbxproj-path "~/dev/PalmX/proj.ios_mac/MiriMemo.xcodeproj/project.pbxproj"))
;;   (add-hook 'c-mode-common-hook 'ac-clang-launch-completion-process)
;;   (add-hook 'objc-mode-hook 'auto-complete-mode)
;;   (add-hook 'objc-mode-hook 'ac-clang-launch-completion-process)
;;   :config
;;   (setq ac-clang-complete-executable (executable-find "clang-complete"))
;;   (setq ac-clang-cflags (xcode-headers-format-for-cflags))
;;   (add-to-list 'ac-sources 'ac-source-clang-async))

(el-get-bundle elixir)
(use-package elixir
  :mode (("\\.ex\\'" . elixir-mode)
         ("\\.exs\\'" . elixir-mode)
         ("\\.elixir\\'" . elixir-mode)))
(el-get-bundle company-mode)
(el-get-bundle alchemist)
(use-package alchemist
  :commands (alchemist-mode)
  :init
  (add-hook 'elixir-mode-hook 'alchemist-mode)
  :config
  (use-package alchemist-compile
    :commands (alchemist-compile-this-buffer alchemist-compile-file))
  (evil-define-key 'normal alchemist-mode-map (kbd ",x") 'alchemist-mix)
  (evil-define-key 'normal alchemist-mode-map (kbd ",mc") 'alchemist-mix-compile)
  (evil-define-key 'normal alchemist-mode-map (kbd ",mr") 'alchemist-mix-run)
  (evil-define-key 'normal alchemist-mode-map (kbd ",tt") 'alchemist-mix-test-at-point)
  (evil-define-key 'normal alchemist-mode-map (kbd ",tb") 'alchemist-mix-test-this-buffer)
  (evil-define-key 'normal alchemist-mode-map (kbd ",tr") 'alchemist-mix-test-rerun-last-test)
  (evil-define-key 'normal alchemist-mode-map (kbd ",rb") 'alchemist-execute-this-buffer)
  (evil-define-key 'normal alchemist-mode-map (kbd ",rf") 'alchemist-execute-file)
  (evil-define-key 'normal alchemist-mode-map (kbd ",ee") 'alchemist-eval-current-line)
  (evil-define-key 'normal alchemist-mode-map (kbd ",eE") 'alchemist-eval-print-current-line)
  (evil-define-key 'visual alchemist-mode-map (kbd ",ee") 'alchemist-eval-region)
  (evil-define-key 'visual alchemist-mode-map (kbd ",eE") 'alchemist-eval-print-region)
  (evil-define-key 'normal alchemist-mode-map (kbd ",eb") 'alchemist-eval-buffer)
  (evil-define-key 'normal alchemist-mode-map (kbd ",eB") 'alchemist-eval-print-buffer)
  (evil-define-key 'normal alchemist-mode-map (kbd ",ft") 'alchemist-project-find-test)
  (evil-define-key 'normal alchemist-mode-map (kbd ",fT") 'alchemist-project-toggle-file-and-tests-other-window)
  (evil-define-key 'normal alchemist-mode-map (kbd ",hh") 'alchemist-help)
  (evil-define-key 'normal alchemist-mode-map (kbd ",ht") 'alchemist-help-search-at-point)
  (evil-define-key 'normal alchemist-mode-map (kbd ",ii") 'alchemist-iex-run)
  (evil-define-key 'normal alchemist-mode-map (kbd ",ip") 'alchemist-iex-project-run)
  (evil-define-key 'normal alchemist-mode-map (kbd ",ic") 'alchemist-iex-compile-this-buffer)
  (evil-define-key 'normal alchemist-mode-map (kbd ",ie") 'alchemist-iex-send-current-line)
  (evil-define-key 'normal alchemist-mode-map (kbd ",iE") 'alchemist-iex-send-current-line-and-go)
  (evil-define-key 'visual alchemist-mode-map (kbd ",ir") 'alchemist-iex-send-region)
  (evil-define-key 'visual alchemist-mode-map (kbd ",iR") 'alchemist-iex-send-region-and-go)
  (evil-define-key 'normal alchemist-mode-map (kbd ",gd") 'alchemist-goto-definition-at-point)
  (evil-define-key 'normal alchemist-mode-map (kbd ",cc") 'alchemist-compile-this-buffer)
  (evil-define-key 'normal alchemist-mode-map (kbd ",cf") 'alchemist-compile-file)
  (use-package company-mode))

(el-get-bundle syohex/emacs-ac-alchemist)
(use-package ac-alchemist
  :commands (ac-alchemist-setup)
  :init
  (add-hook 'elixir-mode-hook 'ac-alchemist-setup))

(el-get-bundle haskell-mode)
(use-package haskell-mode
  :mode (("\\.hs\\'" . haskell-mode)
         ("\\.lhs\\'" . literate-haskell-mode))
  :init
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'font-lock-mode)
  (add-hook 'haskell-mode-hook 'inf-haskell-mode))
(use-package haskell-cabel-mode
  :mode (("\\.cabal\\'" . haskell-cabel-mode)))
(use-package haskell-indentation-mode
  :commands (haskell-indentation-mode)
  :init
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode))
(el-get-bundle ghc-mod)
(use-package ghc
  :commands (ghc-init)
  :init
  (add-hook 'haskell-mode-hook '(lambda () (ghc-init)))
  :config
  (add-to-list 'ac-sources 'ac-source-ghc-mod))

(el-get-bundle js2-mode)
(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode)))

(el-get-bundle coffee-mode)
(use-package coffee-mode
  :mode (("\\.coffee\\'" . coffee-mode))
  :init
  (add-hook 'coffee-mode-hook '(lambda () ((set (make-local-variable 'tab-width) 2)
                                           (set (make-local-variable 'coffee-tab-width)2)))))

(el-get-bundle scss-mode)
(use-package scss-mode
  :mode (("\\.scss\\'" . scss-mode)))

(el-get-bundle csv-mode)
(use-package csv-mode
  :mode (("\\.csv\\'" . csv-mode)))

(el-get-bundle restclient)
(use-package restclient
  :commands (restclient-mode)
  :config
  (evil-define-key 'normal restclient-mode-map
    ",y"  'restclient-copy-curl-command
    ",ss" 'restclient-http-send-current
    ",sr" 'restclient-http-send-current-raw
    ",sv" 'restclient-http-send-current-stay-in-window
    ",n"  'restclient-jump-next
    ",p"  'restclient-jump-prev
    ",m"  'restclient-mark-current))

(el-get-bundle volatile-highlights)
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :commands (volatile-highlights-mode)
  :init
  (add-hook 'prog-mode-hook 'volatile-highlights-mode))

(require 'server)
(unless (server-running-p)
  (server-start))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("97f9438943105a17eeca9f1a1c4c946765e364957749e83047d6ee337b5c0a73" "790e74b900c074ac8f64fa0b610ad05bcfece9be44e8f5340d2d94c1e47538de" "90d329edc17c6f4e43dbc67709067ccd6c0a3caa355f305de2041755986548f2" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(git-gutter:added-sign "++")
 '(git-gutter:deleted-sign "--")
 '(git-gutter:modified-sign "**"))
