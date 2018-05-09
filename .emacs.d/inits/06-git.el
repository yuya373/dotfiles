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
  (require 'evil)
  (el-get-bundle fringe-helper)
  (require 'fringe-helper))

;; git
(el-get-bundle evil-magit)
(el-get-bundle magit)
;; (el-get-bundle magit-gh-pulls)
(el-get-bundle gist)
;; (el-get-bundle git-gutter)
(el-get-bundle git-gutter-fringe+)
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
    ",W" 'git-timemachine-kill-revision
    ",b" 'git-timemachine-blame)
  )

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


  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  ;; (setq magit-display-buffer-function #'magit-display-buffer-traditional)
  ;; (setq magit-display-buffer-function
  ;;       (lambda (buffer)
  ;;         (if magit-display-buffer-noselect
  ;;             ;; the code that called `magit-display-buffer-function'
  ;;             ;; expects the original window to stay alive, we can't go
  ;;             ;; fullscreen
  ;;             (magit-display-buffer-traditional buffer)
  ;;           (display-buffer buffer '(display-buffer-full-screen)))))
  ;; (defun my-git-commit-mode ()
  ;;   (make-local-variable 'company-backends)
  ;;   (add-to-list 'company-backends '(company-ispell :with company-dabbrev)))
  ;; (add-hook 'git-commit-mode-hook 'my-git-commit-mode)
  :config
  ;; (use-package ert)
  (use-package magit-extras)
  (use-package git-rebase)
  (use-package magit-submodule)
  (use-package magit-subtree)
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
  (magit-auto-revert-mode)

  (define-key magit-process-mode-map [override-state] nil)
  (define-key magit-process-mode-map [intercept-state] nil)
  (defun magit-blame-open-github ()
    (interactive)
    (let ((hash (magit-blame-chunk-get :hash)))
      (when hash
        (let* ((default-branch
                 (shell-command-to-string
                  (concat "git symbolic-ref refs/remotes/origin/HEAD "
                          "| sed 's@^refs/remotes/origin/@@'")))
               (rev-range (format "%s...%s"
                                  hash
                                  (substring default-branch 0 -1)))
               (path-cmd (concat "git log "
                                 "--merges --oneline "
                                 "--reverse --ancestry-path "
                                 (format "%s " rev-range)
                                 "| grep 'Merge pull request #' "
                                 "| head -n 1 "
                                 "| cut -f5 -d' ' "
                                 "| sed -e 's%#%pull/%'"))
               (path (shell-command-to-string path-cmd))
               (cmd (format "hub browse -- %s" path)))
          (shell-command cmd)))))
  (evil-define-key 'normal magit-blame-mode-map
    ",y" 'magit-blame-copy-hash
    ",q" 'magit-blame-quit
    ",s" 'magit-show-commit
    ",t" 'magit-blame-toggle-headings
    ",o" 'magit-blame-open-github
    )
  ;; (use-package magit-gh-pulls
  ;;   :commands (turn-on-magit-gh-pulls)
  ;;   :init
  ;;   (add-hook 'magit-mode-hook 'turn-on-magit-gh-pulls))
  )

(use-package gist
  :commands (gist-list gist-region gist-region-private
                       gist-buffer gist-buffer-private))

(use-package git-gutter+
  :commands (global-git-gutter+-mode)
  :diminish git-gutter+-mode
  :init
  (add-hook 'after-init-hook 'global-git-gutter+-mode)
  :config
  (defun git-gutter+-remote-default-directory (dir file)
    (let* ((vec (tramp-dissect-file-name file))
           (method (tramp-file-name-method vec))
           (user (tramp-file-name-user vec))
           (host (tramp-file-name-host vec)))
      (format "/%s:%s%s:%s" method (if user (concat user "@") "") host dir)))

  (defun git-gutter+-remote-file-path (dir file)
    (let ((file (tramp-file-name-localname (tramp-dissect-file-name file))))
      (replace-regexp-in-string (concat "\\`" dir) "" file)))

  (use-package git-gutter-fringe+
    :config
    (use-package fringe-helper
      :config
      (fringe-helper-define 'git-gutter-fr+-added nil
        "........"
        "...XX..."
        "...XX..."
        ".XXXXXX."
        ".XXXXXX."
        "...XX..."
        "...XX..."
        "........")

      (fringe-helper-define 'git-gutter-fr+-deleted nil
        "........"
        "........"
        "........"
        ".XXXXXX."
        ".XXXXXX."
        "........"
        "........"
        "........")

      (fringe-helper-define 'git-gutter-fr+-modified nil
        "........"
        "........"
        "..XXXX.."
        "..XXXX.."
        "..XXXX.."
        "..XXXX.."
        "..XXXX.."
        "........"))
    (setq-default left-fringe-width 15)
    (setq git-gutter-fr+-side 'left-fringe)
    (set-face-foreground 'git-gutter-fr+-modified "#eee8d5")
    (set-face-foreground 'git-gutter-fr+-added    "#859900")
    (set-face-foreground 'git-gutter-fr+-deleted  "#dc322f")))

(el-get-bundle git-link)
(use-package git-link
  :commands (git-link git-link-commit git-link-homepage)
  :init
  (setq git-link-default-branch "develop"))


(provide '06-git)
;;; 06-git.el ends here
