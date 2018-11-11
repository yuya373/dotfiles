;;; 13-flycheck.el ---                               -*- lexical-binding: t; -*-

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

(el-get-bundle flycheck)
(el-get-bundle alexmurray/evil-flycheck)
(el-get-bundle package-lint)
(el-get-bundle flycheck-package)
(el-get-bundle pkg-info)

(use-package flycheck
  :diminish flycheck-mode
  :commands (flycheck-mode)
  :init
  (setq-default flycheck-disabled-checkers '(chef-foodcritic
                                             javascript-jshint
                                             javascript-jscs))
  (setq flycheck-emacs-lisp-load-path 'inherit)
  (add-hook 'prog-mode-hook 'flycheck-mode)
  (defun my/use-eslint-from-node-modules ()
    (interactive)
    (let* ((root (or (locate-dominating-file
                      (or (buffer-file-name) default-directory)
                      ".eslintrc.js")
                     (locate-dominating-file
                      (or (buffer-file-name) default-directory)
                      ".eslintrc")))
           (eslint (and root
                        (expand-file-name "node_modules/eslint/bin/eslint.js"
                                          root))))

      ;; (when root
      ;;   (add-to-list 'flycheck-eslint-rules-directories (expand-file-name root)))
      (when (and eslint (file-executable-p eslint))
        (setq-local flycheck-javascript-eslint-executable eslint))))

  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (setq flycheck-scalastylerc "~/dotfiles/scalastyle_config.xml")
  :config
  (use-package pkg-info)
  (use-package evil-flycheck
    :config
    (setq flycheck-check-syntax-automatically
          '(evil-normal-state
            keyboard-quit
            evil-delete
            evil-delete-line
            evil-delete-marks
            evil-delete-char
            evil-paste-after
            evil-paste-before
            )))
  ;; (defconst flycheck-error-list-format
  ;;   [("Line" 5 flycheck-error-list-entry-< :right-align t)
  ;;    ("Col" 3 nil :right-align t)
  ;;    ("Level" 8 flycheck-error-list-entry-level-<)
  ;;    ("ID" 10 t)
  ;;    ("Message (Checker)" 0 t)]
  ;;   "Table format for the error list.")
  (evil-define-key 'normal flycheck-error-list-mode-map
    "RET" #'flycheck-error-list-goto-error
    ",n" #'flycheck-error-list-next-error
    ",p" #'flycheck-error-list-previous-error
    ",r" #'flycheck-error-list-check-source
    ",f" #'flycheck-error-list-set-filter
    ",F" #'flycheck-error-list-reset-filter)

  )

(use-package flycheck-package
  :commands (flycheck-package-setup)
  :init
  (add-hook 'flycheck-mode-hook 'flycheck-package-setup))

;; (use-package flycheck-tip
;;   :commands (flycheck-tip-display-current-line-error-message)
;;   :init
;;   (setq flycheck-tip-avoid-show-func nil)
;;   (setq flycheck-display-errors-function #'flycheck-tip-display-current-line-error-message))

(provide '13-flycheck)
;;; 13-flycheck.el ends here
