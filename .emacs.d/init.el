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

(prefer-coding-system 'utf-8)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;; (tooltip-mode -1)
;; (setq tooltip-use-echo-area t)
(unless (eq window-system 'mac)
  (menu-bar-mode -1))

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get-bundle diminish)
(el-get-bundle bind-key)
(el-get-bundle use-package
               :features (use-package diminish bind-key))
(el-get-bundle evil-leader
              (global-evil-leader-mode))
(el-get-bundle evil
                (evil-mode 1))
(el-get-bundle evil-jumper
                (evil-jumper-mode))
(el-get-bundle evil-lisp-state
               :depends (smartparens)
               :features (evil-lisp-state)
              (add-to-list 'evil-lisp-state-major-modes 'lisp-mode ))
(el-get-bundle evil-matchit
               (global-evil-matchit-mode 1))
(el-get-bundle evil-nerd-commenter
               (define-key evil-normal-state-map (kbd ",,") 'evilnc-comment-or-uncomment-lines))
(el-get-bundle evil-numbers
               (define-key evil-normal-state-map (kbd "+") 'evil-numbers/inc-at-pt)
               (define-key evil-normal-state-map (kbd "-") 'evil-numbers/dec-at-pt))

(el-get-bundle juanjux/evil-search-highlight-persist
               :depends (highlight)
               (global-evil-search-highlight-persist t))
(el-get-bundle evil-surround
               (global-evil-surround-mode 1))
(el-get-bundle evil-terminal-cursor-changer)
(el-get-bundle evil-visualstar
               (global-evil-visualstar-mode))
(el-get-bundle! guide-key
               (guide-key-mode 1)
               (setq guide-key/idle-delay 0.4)
               (setq guide-key/recursive-key-sequence-flag t)
               (setq guide-key/guide-key-sequence '("\\" ",")))

(el-get-bundle rainbow-delimiters)

(use-package rainbow-delimiters
             :init
             ; (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
             (add-hook 'lisp-mode 'rainbow-delimiters-mode)
             (add-hook 'emacs-lisp-mode 'rainbow-delimiters-mode))

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
