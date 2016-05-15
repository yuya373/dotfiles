;;; 06-git.el ---                                    -*- lexical-binding: t; -*-

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

(eval-when-compile
  (require 'evil))

;; git
(el-get-bundle evil-magit)
(el-get-bundle magit)
(el-get-bundle magit-gh-pulls)
(el-get-bundle gist)
(el-get-bundle git-gutter)
(el-get-bundle git-messenger)
(el-get-bundle git-timemachine)

(use-package git-timemachine
  :commands (git-timemachine)
  :config
  (evil-define-key 'normal git-timemachine-mode-map
    ",p" 'git-timemachine-show-previous-revision
    ",n" 'git-timemachine-show-next-revision
    ",g" 'git-timemachine-show-nth-revision
    ",q" 'git-timemachine-quit
    ",w" 'git-timemachine-kill-abbreviated-revision
    ",W" 'git-timemachine-kill-revision))

(use-package git-messenger
  :commands (git-messenger:popup-message))

(use-package magit
  :commands (magit-status magit-blame-popup
                          magit-fetch-popup magit-branch-popup)
  :init
  (add-hook 'magit-mode-hook '(lambda () (linum-mode -1)))
  (setq magit-push-always-verify t)
  (setq magit-branch-arguments nil)
  (setq magit-restore-window-configuration t)
  (defun display-buffer-full-screen (buffer alist)
    (delete-other-windows)
    ;; make sure the window isn't dedicated, otherwise
    ;; `set-window-buffer' throws an error
    (set-window-dedicated-p nil nil)
    (set-window-buffer nil buffer)
    ;; return buffer's window
    (get-buffer-window buffer))

  ;; (setq magit-display-buffer-function #'magit-display-buffer-traditional)
  (setq magit-display-buffer-function
        (lambda (buffer)
          (if magit-display-buffer-noselect
              ;; the code that called `magit-display-buffer-function'
              ;; expects the original window to stay alive, we can't go
              ;; fullscreen
              (magit-display-buffer-traditional buffer)
            (display-buffer buffer '(display-buffer-full-screen)))))
  (defun my-git-commit-mode ()
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-ispell))
  (add-hook 'git-commit-mode-hook 'my-git-commit-mode)
  :config
  (use-package ert)
  (use-package magit-extras)
  (use-package git-rebase)
  (use-package evil-magit
    :config
    (evil-magit-define-key evil-magit-state 'git-rebase-mode-map
                           (kbd "C-k") 'git-rebase-move-line-up)
    (evil-magit-define-key evil-magit-state 'git-rebase-mode-map
                           (kbd "C-j") 'git-rebase-move-line-down)
    (evil-magit-define-key evil-magit-state 'git-rebase-mode-map
                           (kbd ",c") 'with-editor-finish)
    (evil-magit-define-key evil-magit-state 'git-rebase-mode-map
                           (kbd ",k") 'with-editor-cancel))
  ;; (use-package magit-gh-pulls
  ;;   :commands (turn-on-magit-gh-pulls)
  ;;   :init
  ;;   (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))
  ;; (evil-set-initial-state 'magit-mode 'normal)
  ;; (evil-set-initial-state 'magit-status-mode 'insert)
  ;; (evil-set-initial-state 'magit-diff-mode 'insert)
  ;; (evil-set-initial-state 'magit-log-mode 'insert)
  ;; (evil-set-initial-state 'magit-reflog-mode 'normal)
  ;; (evil-set-initial-state 'magit-process-mode 'normal)
  ;; (evil-set-initial-state 'magit-blame-mode 'motion)
  ;; (evil-set-initial-state 'magit-revision-mode 'normal)

  ;; (defun magit-blame-quit-and-escape ()
  ;;   (interactive)
  ;;   (magit-blame-quit)
  ;;   (evil-normal-state 1))
  ;; (define-key magit-blame-mode-map "q" 'magit-blame-quit-and-escape)
  ;; (define-key magit-blame-mode-map "b" 'magit-blame-popup)
  ;; (define-key magit-blame-mode-map "r" 'magit-show-commit)
  ;; (define-key magit-blame-mode-map "s" 'magit-diff-show-or-scroll-up)
  ;; (define-key magit-blame-mode-map "d" 'magit-diff-show-or-scroll-down)
  ;; (define-key magit-blame-mode-map "n" 'magit-blame-next-chunk)
  ;; (define-key magit-blame-mode-map "N" 'magit-blame-next-chunk-same-commit)
  ;; (define-key magit-blame-mode-map "p" 'magit-blame-previous-chunk)
  ;; (define-key magit-blame-mode-map "P" 'magit-blame-previous-chunk-same-commit)
  ;; (define-key magit-blame-mode-map "t" 'magit-blame-toggle-headings)
  ;; (define-key magit-blame-mode-map "y" 'magit-blame-copy-hash)

  ;; (define-key magit-mode-map "\s" nil) ;space I use space as my evil-leader key
  ;; (define-key magit-diff-mode-map "\s" nil) ;space
  ;; (define-key magit-diff-mode-map "j" 'next-line)

  ;; (define-key magit-status-mode-map "j" 'next-line) ;may be should evil-next-line
  ;; (define-key magit-mode-map "j" 'next-line)
  ;; (define-key magit-mode-map "k" 'previous-line)
  ;; (define-key magit-file-section-map "K" 'magit-discard)
  ;; (define-key magit-file-section-map "k" nil)
  ;; (define-key magit-hunk-section-map "K" 'magit-discard)
  ;; (define-key magit-hunk-section-map "k" nil)
  ;; (define-key magit-unstaged-section-map "k" nil)
  ;; (define-key magit-unstaged-section-map "K" 'magit-discard)
  ;; (define-key magit-staged-section-map "K" 'magit-discard)
  ;; (define-key magit-staged-section-map "k" nil)
  ;; (define-key magit-stash-section-map "K" 'magit-stash-drop)
  ;; (define-key magit-stash-section-map "k" nil)
  ;; (define-key magit-stashes-section-map "K" 'magit-stash-clear)
  ;; (define-key magit-stashes-section-map "k" nil)

  ;; (define-key magit-untracked-section-map "K" 'magit-discard)
  ;; (define-key magit-untracked-section-map "k" nil)

  ;; (define-key magit-branch-section-map "K" 'magit-branch-delete)
  ;; (define-key magit-branch-section-map "k" nil)

  ;; (define-key magit-remote-section-map "K" 'magit-remote-remove)
  ;; (define-key magit-remote-section-map "k" nil)

  ;; (define-key magit-tag-section-map "k" nil)
  ;; (define-key magit-tag-section-map "K" 'magit-tag-delete)

  ;; (use-package git-rebase
  ;;   :config
  ;;   (define-key git-rebase-mode-map "RET" 'git-rebase-show-commit)
  ;;   (define-key git-rebase-mode-map "x" 'git-rebase-exec)
  ;;   (define-key git-rebase-mode-map "u" 'git-rebase-undo)
  ;;   (define-key git-rebase-mode-map "p" 'git-rebase-pick)
  ;;   (define-key git-rebase-mode-map "e" 'git-rebase-edit)
  ;;   (define-key git-rebase-mode-map "f" 'git-rebase-fixup)
  ;;   (define-key git-rebase-mode-map "s" 'git-rebase-squash)
  ;;   (define-key git-rebase-mode-map "K" 'git-rebase-kill-line)
  ;;   (define-key git-rebase-mode-map "k" 'git-rebase-move-line-up)
  ;;   (define-key git-rebase-mode-map "j" 'git-rebase-move-line-down))
  )

(use-package gist
  :commands (gist-list gist-region gist-region-private
                       gist-buffer gist-buffer-private))

(use-package git-gutter
  :diminish git-gutter-mode
  :commands (global-git-gutter-mode)
  :init
  (add-hook 'after-init-hook 'global-git-gutter-mode)
  :config
  (setq git-gutter:update-interval 2)
  (add-to-list 'git-gutter:update-commands 'evil-normal-state)
  (setq git-gutter:modified-sign "**"
        git-gutter:added-sign    "++"
        git-gutter:deleted-sign  "--")
  (set-face-foreground 'git-gutter:modified "#eee8d5")
  (set-face-foreground 'git-gutter:added "#859900")
  (set-face-foreground 'git-gutter:deleted "#dc322f")
  (git-gutter:linum-setup))

(provide '06-git)
;;; 06-git.el ends here
