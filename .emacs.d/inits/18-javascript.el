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
         ;; ("\\.jsx\\'" . js2-jsx-mode)
         ;; ("\\.jsx.js\\'" . js2-jsx-mode)
         )
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
         ("\\.js\\'" . rjsx-mode)
         )
  :config
  (defun rjsx-delete-creates-full-tag-and-escape (n &optional killflag)
    (interactive "p")
    (rjsx-delete-creates-full-tag n killflag)
    (evil-normal-state))

  (eval-after-load "evil"
    (evil-define-key 'insert rjsx-mode-map
      (kbd "C-d") 'rjsx-delete-creates-full-tag-and-escape))
  )

(el-get-bundle coffee-mode)
(use-package coffee-mode
  :mode (("\\.coffee\\'" . coffee-mode))
  :init
  (setq coffee-tab-width 2)
  (setq coffee-indent-tabs-mode nil))

(el-get-bundle company-tern :post-init nil)
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
  (evil-define-key 'normal tern-mode-keymap
    ",gd" 'tern-find-definition
    ",gD" 'tern-find-definition-by-name
    ",ht" 'tern-get-type
    ",hh" 'tern-get-docs)
  )

(use-package company-tern
  :commands (company-tern)
  :init
  (defun enable-company-tern ()
    (interactive)
    ;; (make-local-variable 'company-backends)
    ;; (make-local-variable 'company-idle-delay)
    ;; (setq company-idle-delay 0)
    ;; (setq company-backends (remq 'company-capf company-backends))
    ;; (setq company-backends (remq 'company-tern company-backends))
    (add-to-list 'company-backends '(company-tern :with company-dabbrev)))
  (add-hook 'js2-mode-hook 'enable-company-tern)
  (add-hook 'js2-jsx-mode-hook 'enable-company-tern)
  )

(el-get-bundle flycheck-flow)
(use-package flycheck-flow
  :config
  (defun my/use-flow-from-node-modules ()
    (interactive)
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  ".flowconfig"))
           (flow (and root
                      (expand-file-name "node_modules/flow-bin/cli.js"
                                        root))))
      (when (and flow (file-executable-p flow))
        (setq-local flycheck-javascript-flow-executable flow))))
  (add-hook 'flycheck-mode-hook 'my/use-flow-from-node-modules)
  (flycheck-define-checker javascript-flow
    "A JavaScript syntax and style checker using Flow.

See URL `http://flowtype.org/'."
    :command (
              "flow"
              "check-contents"
              (eval flycheck-javascript-flow-args)
              "--json"
              "--from" "emacs"
              "--color=never"
              source-original)
    :standard-input t
    :predicate flycheck-flow--predicate
    :error-parser flycheck-flow--parse-json
    ;; js3-mode doesn't support jsx
    :modes (js-mode js-jsx-mode js2-mode js2-jsx-mode js3-mode rjsx-mode)))

(provide '18-javascript)
;;; 18-javascript.el ends here
