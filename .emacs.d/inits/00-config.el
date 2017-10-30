;;; 00-config.el --- config                          -*- lexical-binding: t; -*-

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

(setq split-width-threshold nil)
(menu-bar-mode -1)

;; スクリプトを保存する時，自動的に chmod +x を行う
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
(define-key minibuffer-local-completion-map
  (kbd "C-w") 'backward-kill-word)
(global-set-key "\C-m" 'newline-and-indent)
(setq large-file-warning-threshold nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

;; encoding
(set-language-environment "Japanese")
(set-keyboard-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))
(prefer-coding-system 'utf-8)

(setq require-final-newline t)
(setq ad-redefinition-action 'accept)

(use-package recentf-mode
  :init
  (setq recentf-max-saved-items 1000)
  :config
  (defun my-save-recentf ()
    (recentf-save-list))
  (defun set-recentf-timer ()
    (interactive)
    (if recentf-auto-save-timer
        (cancel-timer recentf-auto-save-timer))
    (setq recentf-auto-save-timer
          (run-at-time t 30 #'my-save-recentf))))

;; tab
(setq tab-always-indent t)
(setq-default indent-tabs-mode nil)

;; symboliclink
(setq vc-follow-symlinks t)

;; woman
(setq woman-imenu-generic-expression
      '((nil "^\\(   \\)?\\([ぁ-んァ-ヴー一-龠ａ-ｚＡ-Ｚ０-９a-zA-Z0-9]+\\)" 2)))
(setq woman-use-own-frame nil)

;; line wrap
(use-package visual-line-mode
  :commands (visual-line-mode)
  :init
  (add-hook 'org-mode-hook 'visual-line-mode)
  (add-hook 'prog-mode-hook 'visual-line-mode)
  (add-hook 'visual-line-mode-hook #'(lambda () (diminish 'visual-line-mode))))

;; auto-insert
(use-package auto-insert-mode
  :commands (auto-insert-mode)
  :init
  (add-hook 'after-init-hook 'auto-insert-mode)
  (setq auto-insert-directory "~/dotfiles/vim/template")
  (define-auto-insert "PULLREQ_MSG" "PULLREQ_MSG"))

(use-package hideshow
  :commands (hs-minor-mode)
  :diminish hs-minor-mode
  :config
  (add-hook 'prog-mode-hook 'hs-minor-mode))

;; whitespace
(use-package whitespace
  :diminish whitespace-mode
  :init
  (add-hook 'prog-mode-hook #'(lambda () (whitespace-mode 1)))
  :config
  (setq whitespace-style '(face
                           trailing
                           tabs
                           ;; indentation::space
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
  (set-face-foreground 'whitespace-newline  "#d33682")
  (set-face-background 'whitespace-newline 'nil)
  (set-face-background 'whitespace-tab 'nil))

(use-package autorevert
  :commands (global-auto-revert-mode)
  :diminish auto-revert-mode
  :init
  (setq auto-revert-check-vc-info nil)
  (setq auto-revert-interval 5)
  (add-hook 'after-init-hook #'(lambda () (global-auto-revert-mode t))))

(use-package generic-x)


(provide '00-config)
;;; 00-config.el ends here
