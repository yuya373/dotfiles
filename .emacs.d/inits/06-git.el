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


(use-package git-messenger
  :ensure t
  :commands (git-messenger:popup-message))

(use-package smerge-mode
  :after (magit)
  :diminish smerge-mode)
(use-package magit
  :ensure t
  :commands (magit-status magit-blame)
  :init
  (add-hook 'magit-mode-hook '(lambda () (linum-mode -1)))
  (setq magit-push-always-verify t)
  (setq magit-branch-arguments nil)

  (setq magit-bury-buffer-function #'magit-restore-window-configuration)
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
  (define-key magit-file-section-map (kbd "C-c") 'evil-window-delete)
  (define-key magit-mode-map "t" nil)
  (require 'magit-patch)
  (require 'magit-subtree)
  (require 'magit-ediff)
  (require 'magit-gitignore)
  (require 'magit-sparse-checkout)
  (require 'magit-extras)
  (require 'git-rebase)
  (require 'magit-bookmark)
  (define-key git-rebase-mode-map (kbd "C-k") 'git-rebase-move-line-up)
  (define-key git-rebase-mode-map (kbd "C-j") 'git-rebase-move-line-down)
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

  (defun my-magit-section-initial-visibility (section)
    ;; (when (magit-file-section-p section)
    ;;   ;; (message "section: %S" (oref section hidden))
    ;;   ;; (if (oref section hidden) 'hide 'show)
    ;;   'hide)
    )

  (add-hook 'magit-section-set-visibility-hook #' my-magit-section-initial-visibility)
  )

(use-package gist
  :ensure t
  :commands (gist-list gist-region gist-region-private
                       gist-buffer gist-buffer-private))

(use-package git-gutter+
  :ensure t
  :commands (global-git-gutter+-mode)
  :diminish git-gutter+-mode
  :init
  (add-hook 'after-init-hook 'global-git-gutter+-mode)
  :config
  (defvar git-gutter+-refresh-timer nil)
  (defun git-gutter+-disable-refresh-timer ()
    (interactive)
    (when (timerp git-gutter+-refresh-timer)
      (cancel-timer git-gutter+-refresh-timer)
      (setq git-gutter+-refresh-timer nil)))
  (defun git-gutter+-refresh-if-enabled ()
    (when git-gutter+-mode
      (git-gutter+-refresh)))
  (defun git-gutter+-enable-refresh-timer ()
    (interactive)
    (git-gutter+-disable-refresh-timer)
    (setq git-gutter+-refresh-timer
          (run-with-idle-timer 1 t #'git-gutter+-refresh-if-enabled)))
  (git-gutter+-enable-refresh-timer)

  (defun git-gutter+-remote-default-directory (dir file)
    (let* ((vec (tramp-dissect-file-name file))
           (method (tramp-file-name-method vec))
           (user (tramp-file-name-user vec))
           (host (tramp-file-name-host vec)))
      (format "/%s:%s%s:%s" method (if user (concat user "@") "") host dir)))

  (defun git-gutter+-remote-file-path (dir file)
    (let ((file (tramp-file-name-localname (tramp-dissect-file-name file))))
      (replace-regexp-in-string (concat "\\`" dir) "" file)))
  )

(use-package git-gutter-fringe+
  :after (git-gutter+)
  :ensure t
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
  (set-face-foreground 'git-gutter-fr+-deleted  "#dc322f"))

(use-package git-link
  :ensure t
  :commands (git-link git-link-commit git-link-homepage)
  :init
  (setq git-link-default-branch nil)
  :config
  (defun git-link--current-branch ()
    (interactive)
    (let* ((branches nil))
      (dolist (line (with-temp-buffer
                      (when (zerop (apply #'process-file
                                          "git"
                                          nil
                                          (current-buffer)
                                          nil
                                          (list "branch" "--contains")))
                        (goto-char (point-min))
                        (cl-loop until (eobp)
                                 collect (buffer-substring-no-properties
                                          (line-beginning-position)
                                          (line-end-position))
                                 do (forward-line 1)))))
        (if (string-match-p "detached" line)
            (progn
              (push (replace-regexp-in-string
                     ")" ""
                     (string-trim (cadr (split-string line "/"))))
                    branches))
          (push (if (string-prefix-p "*" line)
                    (string-trim (substring line 1))
                  (string-trim line))
                branches)))
      (car branches)))
  )



(provide '06-git)
;;; 06-git.el ends here
