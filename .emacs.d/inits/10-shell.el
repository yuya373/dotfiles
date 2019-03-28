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
  (setq eshell-modules-list '(eshell-alias eshell-banner eshell-basic
                                           eshell-cmpl eshell-dirs
                                           eshell-glob eshell-hist
                                           eshell-ls eshell-pred
                                           eshell-prompt eshell-script
                                           eshell-term eshell-unix))
  (defun esh-evil-force-normal-state (_ _)
    (evil-normal-state))
  (add-hook 'eshell-expand-input-functions 'esh-evil-force-normal-state)
  (defun create-eshell ()
    (interactive)
    (let* ((eshell-buffer-name "*eshell*")
           (buffers (buffer-list))
           (file-name (buffer-file-name (current-buffer)))
           (git-root (and file-name (vc-git-root file-name)))
           (same-pwd (cl-assoc git-root
                               (mapcar #'(lambda (buf)
                                           (cons (with-current-buffer buf
                                                   default-directory)
                                                 buf))
                                       (cl-remove-if #'(lambda (buf)
                                                         (with-current-buffer buf
                                                           (not (eq major-mode
                                                                    'eshell-mode))))
                                                     (buffer-list)))
                               :test #'string=)))
      (if same-pwd
          (display-buffer (cdr same-pwd))
        (if git-root
            (let ((default-directory git-root))
              (eshell t))
          (eshell t)))))

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

  :config
  (require 'em-smart)
  (require 'esh-opt)
  (setq eshell-where-to-jump 'begin
        eshell-review-quick-commands nil
        eshell-smart-space-goes-to-end nil)
  (add-hook 'eshell-mode-hook 'eshell-smart-initialize)

  (require 'em-term)
  (mapc (lambda (x) (push x eshell-visual-commands))
        '("el" "elinks" "htop" "less" "ssh" "tmux" "top"))

  (require 'ansi-color)
  (defun eshell-handle-ansi-color ()
    (ansi-color-apply-on-region eshell-last-output-start
                                eshell-last-output-end))


  ;; (defvar my-ansi-escape-re
  ;;   (rx (or ?\233 (and ?\e ?\[))
  ;;       (zero-or-more (char (?0 . ?\?)))
  ;;       (zero-or-more (char ?\s ?- ?\/))
  ;;       (char (?@ . ?~))))

  ;; (defun my-nuke-ansi-escapes (beg end)
  ;;   (save-excursion
  ;;     (goto-char beg)
  ;;     (while (re-search-forward my-ansi-escape-re end t)
  ;;       (replace-match ""))))

  ;; (defun my-eshell-nuke-ansi-escapes ()
  ;;   (my-nuke-ansi-escapes eshell-last-output-start eshell-last-output-end))

  ;; (add-hook 'eshell-output-filter-functions 'my-eshell-nuke-ansi-escapes t)

  ;; (defun eshell-exit ()
  ;;   (interactive)
  ;;   (kill-buffer (current-buffer))
  ;;   (delete-window))

  (defun eshell-bind-keymap ()
    ;; (evil-define-key 'normal eshell-mode-map
    ;;   (kbd "C-c") 'eshell-exit)
    (evil-define-key 'insert eshell-mode-map
      (kbd "C-p") 'helm-eshell-history
      (kbd "C-n") 'eshell-next-matching-input-from-input))

  (add-hook 'eshell-mode-hook #'eshell-bind-keymap)
  (add-hook 'eshell-load-hook #'ansi-color-for-comint-mode-on)
  (when (boundp 'eshell-output-filter-functions)
    (add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)
    (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color t))
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
          ("ppr" "find-file-other-window PULLREQ_MSG")
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

;; (el-get-bundle kyagi/shell-pop-el :branch "master")
;; (use-package shell-pop
;;   :commands (shell-pop)
;;   :init
;;   (setq shell-pop-internal-mode "eshell")
;;   (setq shell-pop-internal-mode-shell "eshell")
;;   (setq shell-pop-internal-mode-func (lambda () (eshell t)))
;;   (setq shell-pop-internal-mode-buffer "*eshell*")
;;   )

(el-get-bundle term-run)
(use-package term-run
  :commands (term-run term-run-shell-command))



(provide '10-shell)
;;; 10-shell.el ends here
