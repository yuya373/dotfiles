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
  (require 'evil))

;; shell
(use-package eshell
  :commands (eshell)
  :init
  (defun create-eshell ()
    (interactive)
    (let ((eshell-buffer-name
           (read-from-minibuffer "Eshell Buffer Name: " "*eshell*")))
      (eshell t)))
  :config
  (defun eshell-bind-keymap ()
    (evil-define-key 'insert eshell-mode-map
      (kbd "C-p") 'helm-eshell-history
      (kbd "C-n") 'eshell-next-matching-input-from-input))
  (add-hook 'eshell-mode-hook #'eshell-bind-keymap)
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-cmpl-cycle-completions t)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-save-history-on-exit t)
  (setq eshell-command-aliases-list
        '(("emacs" "find-file $1")
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
  (setq eshell-prompt-function #'epe-theme-lambda))

(el-get-bundle kyagi/shell-pop-el :branch "master")
(use-package shell-pop
  :commands (shell-pop)
  :config
  (setq shell-pop-internal-mode "eshell")
  (setq shell-pop-internal-mode-shell "eshell")
  (setq shell-pop-internal-mode-func (lambda () (eshell t)))
  (setq shell-pop-internal-mode-buffer "*eshell*"))

(el-get-bundle term-run)
(use-package term-run
  :commands (term-run term-run-shell-command))



(provide '10-shell)
;;; 10-shell.el ends here
