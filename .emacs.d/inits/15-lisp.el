;;; 15-lisp.el ---                                   -*- lexical-binding: t; -*-

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

;; (eval-when-compile
;;   (el-get-bundle slime)
;;   (require 'evil)
;;   (require 'slime))

;; (el-get-bundle slime)
;; (use-package slime
;;   :commands (slime-mode)
;;   :init
;;   (add-hook 'lisp-mode-hook 'slime-mode)
;;   (let ((hyperspec-location "/usr/local/share/doc/hyperspec/HyperSpec/"))
;;     (setq common-lisp-hyperspec-root hyperspec-location)
;;     (setq common-lisp-hyperspec-symbol-table (concat hyperspec-location "Data/Map_Sym.txt"))
;;     (setq common-lisp-hyperspec-issuex-table (concat hyperspec-location "Data/Map_IssX.txt")))
;;   (defun eww-open-hyperspec (file &optional _new-window)
;;     (eww (concat "file://"
;;                  (and (memq system-type '(windows-nt ms-dos))
;;                       "/")
;;                  (expand-file-name file))))
;;   (add-hook 'slime-mode-hook '(lambda () (setq-local browse-url-browser-function 'eww-open-hyperspec)))
;;   (setq tab-width 2)
;;   (setq slime-complete-symbol*-fancy t)
;;   (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)
;;   (defun set-inferior-lisp-program ()
;;     (interactive)
;;     (if (executable-find "ros")
;;         (progn
;;           (message (executable-find "ros"))
;;           (let ((slime-helper "~/.roswell/impls/ALL/ALL/quicklisp/slime-helper.el"))
;;             (if (file-exists-p slime-helper)
;;                 (load (expand-file-name slime-helper))
;;               (shell-command "ros -Q -e '(ql:quickload :quicklisp-slime-helper)' -q")))
;;           (setq inferior-lisp-program "ros -L sbcl -Q -l ~/.sbclrc run"))
;;       (setq inferior-lisp-program (executable-find "sbcl"))))
;;   (add-hook 'lisp-mode-hook 'set-inferior-lisp-program)
;;   (setq slime-contribs '(slime-repl slime-fancy slime-banner slime-fuzzy))
;;   (add-hook 'slime-repl-mode-hook (lambda () (linum-mode -1)))
;;   :config
;;   (evil-define-key 'normal slime-mode-map (kbd ",me") 'slime-macroexpand-1)
;;   (evil-define-key 'normal slime-mode-map (kbd ",cc") 'slime-compile-file)
;;   (evil-define-key 'normal slime-mode-map (kbd ",cC") 'slime-compile-and-load-file)
;;   (evil-define-key 'normal slime-mode-map (kbd ",cf") 'slime-compile-defun)
;;   (evil-define-key 'visual slime-mode-map (kbd ",cr") 'slime-compile-region)
;;   (evil-define-key 'normal slime-mode-map (kbd ",eb") 'slime-eval-buffer)
;;   (evil-define-key 'normal slime-mode-map (kbd ",ef") 'slime-eval-defun)
;;   (evil-define-key 'normal slime-mode-map (kbd ",ee") 'slime-eval-last-sexp)
;;   (evil-define-key 'visual slime-mode-map (kbd ",er") 'slime-eval-region)
;;   (evil-define-key 'normal slime-mode-map (kbd ",gg") 'slime-inspect-definition)
;;   (evil-define-key 'normal slime-mode-map (kbd ",hA") 'slime-apropos)
;;   (evil-define-key 'normal slime-mode-map (kbd ",hh") 'slime-hyperspec-lookup)
;;   (evil-define-key 'normal slime-mode-map (kbd ",hF") 'slime-describe-function)
;;   (evil-define-key 'normal slime-mode-map (kbd ",hi") 'slime-inspect-definition)
;;   (evil-define-key 'normal slime-mode-map (kbd ",si") 'slime)
;;   (evil-define-key 'normal slime-mode-map (kbd ",sq") 'slime-quit-lisp)
;;   (evil-define-key 'normal slime-mode-map (kbd ",sr") 'slime-restart-inferior-lisp)
;;   (evil-define-key 'normal slime-mode-map (kbd ",r") 'slime-repl)
;;   (slime-setup '(slime-repl slime-fancy slime-banner slime-fuzzy slime-indentation)))

(provide '15-lisp)
;;; 15-lisp.el ends here
