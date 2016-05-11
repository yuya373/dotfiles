;;; 10-shell.el ---                                  -*- lexical-binding: t; -*-

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
  (require 'vc-git))

(use-package vc-git
  :commands (vc-git-root))

;; shell
(use-package eshell
  :commands (eshell)
  :init
  (defun create-eshell ()
    (interactive)
    (let* ((eshell-buffer-name
            (read-from-minibuffer "Eshell Buffer Name: " "*eshell*"))
           (file-name (buffer-file-name (current-buffer)))
           (git-root (and file-name (vc-git-root file-name))))
      (if git-root
          (let ((default-directory git-root))
            (eshell t))
        (eshell t))))

  (defun eshell-auto-end ()
    "Move point to end of current prompt when switching to insert state."
    (when (and (eq major-mode 'eshell-mode)
               ;; Not on last line, we might want to edit within it.
               (not (eq (line-end-position) (point-max))))
      (end-of-buffer)))

  (add-hook 'eshell-mode-hook
            #'(lambda ()
                (add-hook 'evil-insert-state-entry-hook
                          'eshell-auto-end nil t)))


  (defun spacemacs//protect-eshell-prompt ()
    "Protect Eshell's prompt like Comint's prompts.
E.g. `evil-change-whole-line' won't wipe the prompt. This
is achieved by adding the relevant text properties."
    (let ((inhibit-field-text-motion t))
      (add-text-properties
       (point-at-bol)
       (point)
       '(rear-nonsticky t
                        inhibit-line-move-field-capture t
                        field output
                        read-only t
                        front-sticky (field inhibit-line-move-field-capture)))))
  (add-hook 'eshell-after-prompt-hook 'spacemacs//protect-eshell-prompt)

  (defun spacemacs//toggle-shell-auto-completion-based-on-path ()
    "Deactivates automatic completion on remote paths.
Retrieving completions for Eshell blocks Emacs. Over remote
connections the delay is often annoying, so it's better to let
the user activate the completion manually."
    (if (file-remote-p default-directory)
        (setq-local company-idle-delay nil)
      (setq-local company-idle-delay 0.2)))

  (add-hook 'eshell-directory-change-hook
            'spacemacs//toggle-shell-auto-completion-based-on-path)

  (defun spacemacs//eshell-switch-company-frontend ()
    "Sets the company frontend to `company-preview-frontend' in e-shell mode."
    (setq-local company-frontends '(company-preview-frontend)))
  (add-hook 'eshell-mode-hook
            'spacemacs//eshell-switch-company-frontend)
  :config
  (require 'esh-opt)
  (require 'em-smart)
  (setq eshell-where-to-jump 'begin
        eshell-review-quick-commands nil
        eshell-smart-space-goes-to-end t)
  (add-hook 'eshell-mode-hook 'eshell-smart-initialize)

  (when (boundp 'eshell-output-filter-functions)
    (push 'eshell-truncate-buffer eshell-output-filter-functions))

  (require 'em-term)
  (mapc (lambda (x) (push x eshell-visual-commands))
        '("el" "elinks" "htop" "less" "ssh" "tmux" "top"))

  (defvar my-ansi-escape-re
    (rx (or ?\233 (and ?\e ?\[))
        (zero-or-more (char (?0 . ?\?)))
        (zero-or-more (char ?\s ?- ?\/))
        (char (?@ . ?~))))

  (defun my-nuke-ansi-escapes (beg end)
    (save-excursion
      (goto-char beg)
      (while (re-search-forward my-ansi-escape-re end t)
        (replace-match ""))))

  (defun my-eshell-nuke-ansi-escapes ()
    (my-nuke-ansi-escapes eshell-last-output-start eshell-last-output-end))

  (add-hook 'eshell-output-filter-functions 'my-eshell-nuke-ansi-escapes t)

  (defun eshell-bind-keymap ()
    (evil-define-key 'insert eshell-mode-map
      (kbd "C-p") 'helm-eshell-history
      (kbd "C-n") 'eshell-next-matching-input-from-input))

  (add-hook 'eshell-mode-hook #'eshell-bind-keymap)
  (add-hook 'eshell-load-hook #'ansi-color-for-comint-mode-on)
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-cmpl-cycle-completions t)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-save-history-on-exit t)
  (setq eshell-command-aliases-list
        '(("e" "emacs $1")
          ("emacs" "find-file $1")
          ("d" "dired .")
          ("ll" "ls -l $*")
          ("la" "ls -al $*")
          ("ppr" "find-file PULLREQ_MSG")
          ("pr" "hub pull-request -b $1 -F PULLREQ_MSG && kill-buffer PULLREQ_MSG && rm PULLREQ_MSG")
          ("b" "bundle exec $*")
          ("annot" "bundle exec annotate -p before -i")
          ("rails" "bundle exec rails $*")
          ("rake" "bundle exec rake $*")
          ("rc" "bundle exec rails c")
          ("rct" "bundle exec rails c test")
          ("rgm" "bundle exec rails g migration $*")
          ("rgmc" "bundle exec rails g migration create_$1")
          ("ridgepole-test" "bundle exec rake db:ridgepole:apply[test]")
          ("ridgepole-dev" "bundle exec rake db:ridgepole:apply[development]"))))

(el-get-bundle eshell-prompt-extras)
(use-package eshell-prompt-extras
  :commands (epe-theme-dakrone epe-theme-lambda)
  :init
  (setq eshell-highlight-prompt nil)
  ;; (setq eshell-prompt-function #'epe-theme-lambda)
  )

(el-get-bundle kyagi/shell-pop-el :branch "master")
(use-package shell-pop
  :commands (shell-pop)
  :init
  (setq shell-pop-internal-mode "eshell")
  (setq shell-pop-internal-mode-shell "eshell")
  (setq shell-pop-internal-mode-func (lambda () (eshell t)))
  (setq shell-pop-internal-mode-buffer "*eshell*")
  (setq shell-pop-in-after-hook)
  )

(el-get-bundle term-run)
(use-package term-run
  :commands (term-run term-run-shell-command))



(provide '10-shell)
;;; 10-shell.el ends here
