;;; 17-haskell.el ---                                -*- lexical-binding: t; -*-

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

(el-get-bundle haskell-mode)
(use-package haskell-mode
  :mode (("\\.hs\\'" . haskell-mode)
         ("\\.lhs\\'" . literate-haskell-mode))
  :init
  ;; (add-hook 'haskell-mode-hook 'font-lock-mode)
  ;; (add-hook 'haskell-mode-hook 'inf-haskell-mode)
  (add-hook 'haskell-mode-hook 'haskell-auto-insert-module-template)
  (add-hook 'haskell-mode-hook 'haskell-decl-scan-mode)

  (setq haskell-stylish-on-save t
        haskell-tags-on-save t
        tags-revert-without-query t
        haskell-indentation-electric-flag t
        haskell-compile-cabal-build-command "stack build"
        haskell-process-suggest-remove-import-lines t
        haskell-interactive-mode-eval-mode 'haskell-mode
        )
  :config
  ;; (use-package inf-haskell
  ;;   :diminish inf-haskell-mode)
  (evil-define-key 'normal haskell-mode-map
    ",m" 'haskell-menu
    ",c" 'haskell-compile
    ",si" 'haskell-sort-imports
    ",gl" 'haskell-mode-goto-loc
    ",gi" 'haskell-navigate-imports
    ",fi" 'haskell-mode-format-imports
    ",ai" 'haskell-align-imports
    ;; ",ht" 'haskell-mode-show-type-at
    ;; ",is" 'haskell-interactive-switch
    ;; ",ir" 'haskell-process-restart
    ;; ",il" 'haskell-process-load-file
    ;; ",it" 'haskell-process-do-type
    ;; ",ii" 'haskell-process-do-info
    ;; ",ij" 'haskell-mode-jump-to-def-or-tag
    ;; ",iL" 'haskell-process-reload
    ;; "\C-]" 'haskell-mode-tag-find
    )
  ;; (evil-define-key 'insert haskell-interactive-mode-map
  ;;   "\C-p" 'haskell-interactive-mode-history-previous
  ;;   "\C-n" 'haskell-interactive-mode-history-next)
  )

;; (use-package haskell
;;   :commands (interactive-haskell-mode)
;;   :init
;;   (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;;   :config
;;   (require 'haskell-process))

(use-package haskell-doc
  :commands (haskell-doc-mode)
  :init
  (add-hook 'haskell-mode-hook 'haskell-doc-mode))


(use-package haskell-indentation-mode
  :commands (haskell-indentation-mode)
  :init
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode))

(el-get-bundle intero)
(use-package intero
  :commands (intero-mode)
  :init
  (add-hook 'haskell-mode-hook 'intero-mode)
  :config
  (evil-define-key 'normal intero-mode-map
    ",r" nil
    ",rr" 'intero-repl
    ",re" 'intero-repl-load
    ",ht" 'intero-type-at
    ",hi" 'intero-info
    ",gd" 'intero-goto-definition
    ",a" 'intero-apply-suggestions
    ",e" 'intero-expand-splice-at-point
    )
  (evil-define-key 'normal intero-repl-mode-map
    ",l" 'intero-repl-clear-buffer))

;; (el-get-bundle company-ghc)
;; (use-package ghc
;;   :commands (ghc-init ghc-debug)
;;   :init
;;   (add-hook 'haskell-mode-hook 'ghc-init))

;; (use-package company-ghc
;;   :commands (company-ghc)
;;   :init
;;   (defun my-company-ghc-init ()
;;     (make-local-variable 'company-backends)
;;     (add-to-list 'company-backends
;;                  '(company-ghc :with company-dabbrev)))
;;   (add-hook 'haskell-mode-hook 'my-company-ghc-init))

(provide '17-haskell)
;; 17-haskell.el ends here
