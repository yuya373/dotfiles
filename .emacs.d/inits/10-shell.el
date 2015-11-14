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
  (el-get-bundle auto-complete)
  (require 'evil)
  (require 'auto-complete))

;; shell
(use-package eshell
  :commands (eshell)
  :config
  (use-package pcomplete)
  (ac-define-source pcomplete
    '((candidates . pcomplete-completions)))
  (defun my-eshell-mode-hook ()
    (setq ac-sources
          '(ac-source-pcomplete
            ac-source-filename
            ac-source-files-in-current-dir
            ac-source-words-in-buffer
            ac-source-dictionary))
    (evil-define-key 'insert eshell-mode-map (kbd "C-p") 'helm-eshell-history))
  (add-hook 'eshell-mode-hook 'my-eshell-mode-hook)
  (setq eshell-highlight-prompt t)
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-cmpl-cycle-completions nil)
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-save-history-on-exit t)
  (setq eshell-command-aliases-list
        (append (list
                 (list "emacs" "find-file $1")
                 (list "ppr" "find-file PULLREQ_MSG")
                 (list "pr" "hub pull-request -b $1 -F PULLREQ_MSG && kill-buffer PULLREQ_MSG && rm PULLREQ_MSG")
                 (list "b" "bundle exec $*")
                 (list "rails" "bundle exec rails $*")
                 (list "rake" "bundle exec rake $*")
                 (list "rc" "bundle exec rails c")
                 (list "rct" "bundle exec rails c test")
                 (list "rgm" "bundle exec rails g migration $*")
                 (list "rgmc" "bundle exec rails g migration create_$1")
                 (list "ridgepole-test" "bundle exec rake db:ridgepole:apply[test]")
                 (list "ridgepole-dev" "bundle exec rake db:ridgepole:apply[development]"))
                ())))

(el-get-bundle eshell-prompt-extras)
(use-package eshell-prompt-extras
  :commands (epe-theme-dakrone epe-theme-lambda)
  :init
  (setq eshell-prompt-function 'epe-theme-dakrone)
  (add-hook 'eshell-mode-hook 'epe-theme-dakrone))
(el-get-bundle shell-pop)
(use-package shell-pop
  :commands (shell-pop)
  :config
  (setq shell-pop-internal-mode "eshell")
  (setq shell-pop-internal-mode-shell "eshell")
  (setq shell-pop-internal-mode-func (lambda nil (eshell)))
  (setq shell-pop-internal-mode-buffer "*eshell*"))



(provide '10-shell)
;;; 10-shell.el ends here
