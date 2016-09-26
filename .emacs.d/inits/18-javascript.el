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
  ;; (use-package flycheck-flow
  ;;   :config
  ;;   ;; (flycheck-add-next-checker 'javascript-eslint 'javascript-flow)
  ;;   )
  (use-package js2-imenu-extras)
  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode))

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
  (defun strip-multibyte (str)
    (replace-regexp-in-string "[[:multibyte:]]*" "" str))
  (defun buffer-string-without-multibyte ()
    (strip-multibyte (buffer-string)))
  ;; (add-to-list 'tern-command "--no-port-file" t)
  )
;; (use-package company-tern
;;   :commands (company-tern)
;;   :init
;;   (defun enable-company-tern ()
;;     (make-local-variable 'company-backends)
;;     (make-local-variable 'company-idle-delay)
;;     (add-to-list 'company-backends '(company-tern :with company-dabbrev-code))
;;     (setq company-idle-delay 0))
;;   (add-hook 'js2-mode-hook 'enable-company-tern)
;;   (add-hook 'js2-jsx-mode-hook 'enable-company-tern))

(provide '18-javascript)
;;; 18-javascript.el ends here
