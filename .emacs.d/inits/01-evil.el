;;; 01-evil.el --- evil                              -*- lexical-binding: t; -*-

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
(el-get-bundle avy)

(eval-when-compile
  (el-get-bundle evil)
  (require 'evil))

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
  (defun evil-swap-key (map key1 key2)
    ;; MAP中のKEY1とKEY2を入れ替え
    "Swap KEY1 and KEY2 in MAP."
    (let ((def1 (lookup-key map key1))
          (def2 (lookup-key map key2)))
      (define-key map key1 def2)
      (define-key map key2 def1)))
  :config
  (add-hook 'evil-normal-state-exit-hook 'evil-ex-nohighlight)
  (use-package evil-anzu)
  (use-package evil-indent-textobject)
  (use-package evil-terminal-cursor-changer)
  (use-package evil-exchange :config (evil-exchange-install))
  (use-package evil-visualstar :config (global-evil-visualstar-mode))
  (use-package evil-surround :config (global-evil-surround-mode t))
  (use-package evil-matchit
    :config
    (setq evilmi-ignore-comments nil)
    (evil-define-key 'normal evil-matchit-mode-map
      "t" 'evilmi-jump-items)
    (evil-define-key 'visual evil-matchit-mode-map
      "t" 'evilmi-jump-items)
    (global-evil-matchit-mode t))
  (use-package expand-region
    :commands (er/expand-region er/contract-region))
  (use-package evil-numbers
    :commands (evil-numbers/inc-at-pt evil-numbers/dec-at-pt)
    :init
    (define-key evil-normal-state-map
      (kbd "+") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map
      (kbd "-") 'evil-numbers/dec-at-pt))
  (use-package evil-nerd-commenter
    :commands (evilnc-comment-or-uncomment-lines)
    :init
    (define-key evil-normal-state-map
      (kbd ",,") 'evilnc-comment-or-uncomment-lines)
    (define-key evil-visual-state-map
      (kbd ",,") 'evilnc-comment-or-uncomment-lines))
  (use-package evil-jumper
    :init
    (setq evil-jumper-auto-center t)
    :config (global-evil-jumper-mode))
  (use-package evil-args
    :commands (evil-inner-arg evil-outer-arg)
    :init
    (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
    (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))
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
  (evil-set-initial-state 'comint-mode 'normal)
  (evil-define-key 'normal comint-mode-map
    (kbd "C-c") 'evil-window-delete
    (kbd "C-d") 'evil-scroll-down)
  ;; elisp
  (evil-define-key 'normal emacs-lisp-mode-map
    ",c" 'byte-compile-file
    ",es" 'eval-sexp
    ",eb" 'eval-buffer
    ",ef" 'eval-defun)
  (evil-define-key 'visual emacs-lisp-mode-map
    ",er" 'eval-region)
  ;; expand-region
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region)
  (define-key evil-visual-state-map (kbd "C-v") 'er/contract-region)
  ;; avy
  (use-package avy
    :init
    (setq avy-all-windows nil)
    (setq avy-keys (number-sequence ?a ?z))
    :config
    (evil-define-motion evil-avy-goto-char-in-line (count)
      :type inclusive
      (evil-without-repeat
        (let ((pnt (point))
              (buf (current-buffer)))
          (call-interactively 'avy-goto-char-in-line)
          (when (and (equal buf (current-buffer))
                     (< (point) pnt))
            (setq evil-this-type
                  (cond
                   ((eq evil-this-type 'exclusive)
                    'inclusive)
                   ((eq evil-this-type 'inclusive)
                    'exclusive)))))))
    (evil-define-motion evil-avy-goto-word (count)
      :type inclusive
      :jump t
      :repeat abort
      (evil-without-repeat
        (evil-enclose-avy-for-motion
          (call-interactively 'avy-goto-word-1))))
    (define-key evil-normal-state-map "s" 'avy-goto-char-2)
    (define-key evil-operator-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-normal-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-visual-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-operator-state-map
      (kbd "m") #'evil-avy-goto-word)
    (define-key evil-visual-state-map
      (kbd "m") #'evil-avy-goto-word))
  ;; line move
  (evil-swap-key evil-motion-state-map "j" "gj")
  (evil-swap-key evil-motion-state-map "k" "gk"))


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
  (defun open-junk-dir ()
    (interactive)
    (let ((junk-dir "~/Dropbox/junk/"))
      (helm-find-files-1 (expand-file-name junk-dir))))
  :config
  (evil-leader/set-leader "<SPC>")
  (use-package evil-org)
  ;; describe
  (evil-leader/set-key
    "eha" 'helm-apropos
    "ehf" 'describe-function
    "ehv" 'describe-variable
    "ehs" 'describe-syntax
    "ehp" 'describe-package
    "ehm" 'describe-mode
    "ehb" 'describe-bindings
    "di" 'helm-dash-install-docset
    "dd" 'helm-dash
    "da" 'helm-dash-at-point
    "gf" 'magit-fetch-popup
    "gb" 'magit-blame-popup
    "gg" 'magit-status
    "gu" 'git-gutter:update-all-windows
    "gv" 'git-gutter:popup-hunk
    "gn" 'git-gutter:next-hunk
    "gp" 'git-gutter:previous-hunk
    "gs" 'git-gutter:stage-hunk
    "gr" 'git-gutter:revert-hunk
    "gm" 'git-messenger:popup-message
    "gt" 'git-timemachine
    "ps" 'projectile-switch-project
    "pk" 'projectile-invalidate-cache
    "tG" 'projectile-regenerate-tags
    "tt" 'helm-etags-select
    "ta" 'google-translate-at-point
    "tq" 'google-translate-query-translate
    "tQ" 'google-translate-query-translate-reverse
    "fd" 'helm-projectile-find-dir
    "fp" 'helm-projectile-find-file
    "fc" 'helm-projectile-find-file-dwim
    "bk" 'projectile-kill-buffers
    "bw" 'projectile-switch-to-buffer-other-window
    "bl" 'popwin:popup-last-buffer
    "bp" 'popwin:pop-to-buffer
    ;; "bn" 'switch-to-next-buffer
    ;; "bp" 'switch-to-prev-buffer
    "el" 'flycheck-list-errors
    "en" 'flycheck-next-error
    "ep" 'flycheck-previous-error
    "s" 'shell-pop
    "bf" 'popwin:find-file
    "<SPC>" 'avy-goto-word-1
    "wb" 'balance-windows
    "wg" 'golden-ratio-mode
    "wm" 'toggle-window-maximized
    "wt" 'toggle-frame-alpha
    "ww" 'ace-window
    "wc" 'whitespace-cleanup
    "l" 'toggle-folding
    "uv" 'undo-tree-visualize
    "ap" 'helm-projectile-ag
    "aa" 'helm-do-ag
    "ab" 'helm-do-ag-buffers
    ":"  'helm-M-x
    "bb" 'helm-buffers-list
    "fc" 'helm-find-file-at
    "fr" 'helm-recentf
    "fp" 'helm-browse-project
    "ff" 'helm-find-files
    "hl" 'helm-resume
    "bb" 'helm-mini
    "ho" 'helm-semantic-or-imenu
    "hp" 'helm-show-kill-ring
    "ig" 'indent-guide-mode
    "hgf" 'helm-open-github-from-file
    "hgc" 'helm-open-github-from-commit
    "hgi" 'helm-open-github-from-issues
    "hgp" 'helm-open-github-from-pull-requests
    "r" 'create-restclient-buffer
    "ml" 'open-junk-dir
    "mn" 'open-junk-file
    "ms" 'slack-start
    "mk" 'slack-ws-close
    "mm" 'slack-message-send
    "mg" 'slack-group-select
    "mi" 'slack-im-select
    "mc" 'slack-channel-select
    "mug" 'slack-group-list-update
    "mui" 'slack-im-list-update
    "muc" 'slack-channel-list-update
    "qr" 'quickrun
    "qR" 'quickrun-region
    "qa" 'quickrun-with-arg
    "qs" 'quickrun-shell))

(provide '01-evil)
;;; 01-evil.el ends here
