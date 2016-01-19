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

(setq split-width-threshold 110)
(menu-bar-mode -1)

;; スクリプトを保存する時，自動的に chmod +x を行う
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
(define-key minibuffer-local-completion-map
  (kbd "C-w") 'backward-kill-word)
(global-set-key "\C-m" 'newline-and-indent)
(setq large-file-warning-threshold nil)
(fset 'yes-or-no-p 'y-or-n-p)
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(setq require-final-newline t)
(setq ad-redefinition-action 'accept)
(setq recentf-max-saved-items 1000)

;; tab
(setq tab-always-indent t)
(setq-default indent-tabs-mode nil)

;; symboliclink
(setq vc-follow-symlinks t)

;; linum
(use-package linum-mode
  :commands (linum-mode)
  :init
  (setq linum-format "%4d ")
  (add-hook 'prog-mode-hook 'linum-mode))

;; line wrap
(use-package visual-line-mode
  :commands (visual-line-mode)
  :init
  (add-hook 'prog-mode-hook 'visual-line-mode)
  (add-hook 'visual-line-mode-hook #'(lambda () (diminish 'visual-line-mode))))

;; auto-insert
(use-package auto-insert-mode
  :commands (auto-insert-mode)
  :init
  (add-hook 'after-init-hook 'auto-insert-mode)
  (setq auto-insert-directory "~/dotfiles/vim/template")
  (define-auto-insert "PULLREQ_MSG" "PULLREQ_MSG"))

(el-get-bundle exec-path-from-shell)
(use-package exec-path-from-shell
  :commands (exec-path-from-shell-initialize)
  :init
  (add-hook 'after-init-hook 'exec-path-from-shell-initialize)
  :config
  (exec-path-from-shell-copy-env "LANG"))

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
  :init
  (setq auto-revert-interval 0.1)
  (add-hook 'after-init-hook #'(lambda () (global-auto-revert-mode 1))))

(provide '00-config)
;;; 00-config.el ends here
