;;; 18-javascript.el ---                             -*- lexical-binding: t; -*-

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
  (require 'flycheck))

(el-get-bundle js2-mode)
;; (el-get-bundle flycheck-flow
;;   :type github
;;   :pkgname "lbolla/emacs-flycheck-flow")

(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode)
         ("\\.jsx\\'" . js2-jsx-mode)
         ("\\.jsx.js\\'" . js2-jsx-mode))
  :init
  (setq js2-highlight-level 3)
  (setq js2-include-browser-externs nil)
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil)
  (setq js2-highlight-external-variables nil)
  (setq js2-include-jslint-globals nil)
  (setq js2-basic-offset 2)
  :config
  (defun my-js2-modify-syntax ()
    (modify-syntax-entry ?_ "w" js2-mode-syntax-table))
  (defun my-js2-jsx-modify-syntax ()
    (modify-syntax-entry ?_ "w" js2-jsx-mode-syntax-table))
  (add-hook 'js2-mode-hook 'my-js2-modify-syntax)
  (add-hook 'js2-jsx-mode-hook 'my-js2-jsx-modify-syntax)
  ;; (use-package flycheck-flow
  ;;   :config
  ;;   ;; (flycheck-add-next-checker 'javascript-eslint 'javascript-flow)
  ;;   )
  (use-package js2-imenu-extras)
  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode))

(el-get-bundle felipeochoa/rjsx-mode)
(use-package rjsx-mode
  :mode (("\\.jsx\\'" . rjsx-mode)
         ("\\.jsx.js\\'" . rjsx-mode))
  :config
  (defun rjsx-delete-creates-full-tag-and-escape (n &optional killflag)
    (interactive "p")
    (rjsx-delete-creates-full-tag n killflag)
    (evil-normal-state))

  (eval-after-load "evil"
    (evil-define-key 'insert rjsx-mode-map
      (kbd "C-d") 'rjsx-delete-creates-full-tag-and-escape))

  (eval-after-load "flycheck"
    (flycheck-define-checker javascript-eslint
      "A Javascript syntax and style checker using eslint.

See URL `https://github.com/eslint/eslint'."
      :command ("eslint" "--format=checkstyle"
                (config-file "--config" flycheck-eslintrc)
                (option "--rulesdir" flycheck-eslint-rulesdir)
                "--stdin" "--stdin-filename" source-original)
      :standard-input t
      :error-parser flycheck-parse-checkstyle
      :error-filter (lambda (errors)
                      (seq-do (lambda (err)
                                ;; Parse error ID from the error message
                                (setf (flycheck-error-message err)
                                      (replace-regexp-in-string
                                       (rx " ("
                                           (group (one-or-more (not (any ")"))))
                                           ")" string-end)
                                       (lambda (s)
                                         (setf (flycheck-error-id err)
                                               (match-string 1 s))
                                         "")
                                       (flycheck-error-message err))))
                              (flycheck-sanitize-errors errors))
                      errors)
      :modes (js-mode js-jsx-mode js2-mode js2-jsx-mode js3-mode rjsx-mode)
      :next-checkers ((warning . javascript-jscs)))
    ))

(el-get-bundle coffee-mode)
(use-package coffee-mode
  :mode (("\\.coffee\\'" . coffee-mode))
  :init
  (setq coffee-tab-width 2)
  (setq coffee-indent-tabs-mode nil))

(el-get-bundle company-tern)
(use-package tern
  :commands (tern-mode)
  :init
  (add-hook 'js2-mode-hook 'tern-mode)
  (add-hook 'js2-jsx-mode-hook 'tern-mode)
  :config
  ;; (defun strip-multibyte (str)
  ;;   (replace-regexp-in-string "[[:multibyte:]]*" "" str))
  ;; (defun buffer-string-without-multibyte ()
  ;;   (strip-multibyte (buffer-string)))
  ;; (add-to-list 'tern-command "--no-port-file" t)
  )
(use-package company-tern
  :commands (company-tern)
  :init
  (defun enable-company-tern ()
    (interactive)
    ;; (make-local-variable 'company-backends)
    ;; (make-local-variable 'company-idle-delay)
    ;; (setq company-backends (remq 'company-capf company-backends))
    (add-to-list 'company-backends '(company-tern :with company-dabbrev-code))
    ;; (add-to-list 'company-backends 'company-tern)
    ;; (setq company-idle-delay 0)
    )
  (add-hook 'js2-mode-hook 'enable-company-tern)
  (add-hook 'js2-jsx-mode-hook 'enable-company-tern)
  )

(provide '18-javascript)
;;; 18-javascript.el ends here
