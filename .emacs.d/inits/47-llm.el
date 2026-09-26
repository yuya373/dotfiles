;;; 47-llm.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2025  DESKTOP2

;; Author: DESKTOP2 <yuya373@DESKTOP2>
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:


(use-package vterm
  :ensure t
  :config
  (defun vterm-project-buffer-name ()
    (if (projectile-project-p)
        (format "*vterm-%s*" (projectile-project-root))))
  (defun vterm-current-project ()
    (interactive)
    (if-let* ((buf-name (vterm-project-buffer-name))
              (project-root (projectile-project-root))
              (default-directory project-root))
        (vterm buf-name)
      (vterm)))
  (defun vterm-toggle ()
    (interactive)
    (if-let* ((bufname (vterm-project-buffer-name))
              (buf (get-buffer bufname))
              (livep (buffer-live-p buf)))
        (if-let* ((win (get-buffer-window buf))
                  (livep (window-live-p win)))
            (delete-window win)
          (display-buffer buf))
      (vterm-current-project)))
  (with-eval-after-load 'evil
    (evil-leader/set-key
      "t" 'vterm-toggle
      ))
  (define-key vterm-mode-map (kbd "C-h") 'vterm-send-backspace)
  (with-eval-after-load 'evil-collection
    (evil-collection-define-key 'insert 'vterm-mode-map
      (kbd "C-n") 'vterm-send-down
      (kbd "C-p") 'vterm-send-up
      (kbd "C-h") 'vterm-send-backspace
      ))
  (defun vterm-disable-display-line-numbers ()
    (display-line-numbers-mode -1))
  (add-hook 'vterm-mode-hook 'vterm-disable-display-line-numbers)
  (defun evil-collection-vterm-escape-stay ()
    "Go back to normal state but don't move
cursor backwards. Moving cursor backwards is the default vim behavior but it is
not appropriate in some cases like terminals."
    (setq-local evil-move-cursor-back nil))

  (add-hook 'vterm-mode-hook #'evil-collection-vterm-escape-stay)
  )


(unless (require 'claude-code nil t)
  (add-to-list 'load-path (expand-file-name "~/dev/claude-code-emacs")))
(use-package websocket :ensure t)
(use-package claude-code
  :config
  (defun claude-code-vterm-env-around (org-fn &rest args)
    (let ((vterm-environment '("SHELL=/usr/sbin/bash" "NODENV_VERSION=23.5.0")))
      (apply org-fn args)))
  (advice-add 'claude-code-run :around 'claude-code-vterm-env-around)

  (claude-code-mcp-events-enable)

  ;; サイドウィンドウ（下）に表示
  (setq claude-code-mcp-vc-diff-display-action
        '((display-buffer-reuse-window display-buffer-pop-up-window)
          (inhibit-same-window . t)))
  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
      "c c" 'claude-code-transient))
  (with-eval-after-load 'markdown-mode
    (define-key markdown-mode-map (kbd "TAB") nil))
  (with-eval-after-load 'evil
    (evil-define-minor-mode-key 'normal 'claude-code-vterm-scroll-mode
      "u" 'claude-code-send-page-up
      "d" 'claude-code-send-page-down
      "k" 'claude-code-send-line-up
      "j" 'claude-code-send-line-down
      "q" 'claude-code-vterm-scroll-mode
      (kbd "<escape>") 'claude-code-vterm-scroll-mode
      "G" 'claude-code-send-ctrl-end)
    (evil-define-minor-mode-key 'normal 'claude-code-vterm-agent-mode
      "j" 'claude-code-send-down
      "k" 'claude-code-send-up
      "x" 'claude-code-agent-view-transient
      (kbd "RET") 'claude-code-vterm-agent-mode-open
      (kbd "<return>") 'claude-code-vterm-agent-mode-open
      )
    )

  (with-eval-after-load 'evil-collection
    (evil-collection-define-key 'normal 'claude-code-vterm-mode-map
      "i" nil
      "I" 'claude-code-vterm-agent-view
      "s" 'claude-code-vterm-scroll-mode
      "1" 'claude-code-send-1
      "2" 'claude-code-send-2
      "3" 'claude-code-send-3
      "q" 'claude-code-close
      "K" 'claude-code-clear
      "H" 'claude-code-send-tab
      "e" 'claude-code-send-escape
      "o" 'claude-code-send-ctrl-o
      "O" 'claude-code-send-ctrl-e
      "m" 'claude-code-send-return
      "a" 'claude-code-send-shift-tab)
    (evil-collection-define-key 'insert 'claude-code-prompt-mode-map
      "@" 'claude-code-self-insert-@
      )
    (evil-collection-define-key 'visual 'claude-code-prompt-mode-map
      ",m" 'claude-code-prompt-transient
      ",r" 'claude-code-send-prompt-region
      )
    (evil-collection-define-key 'normal 'claude-code-prompt-mode-map
      ",m" 'claude-code-prompt-transient
      ",c" 'claude-code-send-prompt-at-point
      )
    )
  )

(provide '47-llm)
;;; 47-llm.el ends here
