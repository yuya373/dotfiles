;;; 43-typescript.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2018

;; Author:  <yuya373@archlinux>
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
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(eval-when-compile
  (require 'use-package))



(use-package add-node-modules-path
  :ensure t
  :init
  :config
  (add-to-list 'add-node-modules-path-command "yarn bin")
  (with-eval-after-load 'typescript-ts-mode
    (add-hook 'typescript-ts-mode-hook 'add-node-modules-path)
    (add-hook 'tsx-ts-mode-hook 'add-node-modules-path))
  )

(use-package typescript-ts-mode
  :ensure t
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (defun eslint-fix ()
    (call-process "eslint" nil "*ESLint Errors*" nil "--fix" buffer-file-name)
    (revert-buffer t t t))
  (defun enable-eslint-auto-fix ()
    (add-hook 'after-save-hook 'eslint-fix nil t))
  (add-hook 'typescript-ts-mode-hook 'enable-eslint-auto-fix)
  (add-hook 'tsx-ts-mode-hook 'enable-eslint-auto-fix)
  )

(use-package treesit-auto
  :ensure t
  :init
  (setq treesit-auto-install 'prompt)
  (setq treesit-auto-langs '(typescript tsx))
  :config
  (global-treesit-auto-mode)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (setq treesit-auto-recipe-list
        (cl-remove-if (lambda (e)
                        (let ((lang (treesit-auto-recipe-lang e)))
                          (cl-member lang '(typescript tsx go))))
                      treesit-auto-recipe-list))
  (let ((revision "v0.20.0"))
    (add-to-list 'treesit-auto-recipe-list
                 (make-treesit-auto-recipe
                  :lang 'go
                  :ts-mode 'go-ts-mode
                  :remap 'go-mode
                  :requires 'gomod
                  :url "https://github.com/tree-sitter/tree-sitter-go"
                  :revision revision
                  :ext "\\.go\\'")))
  (let ((revision "v0.20.3"))
    (add-to-list 'treesit-auto-recipe-list
                 (make-treesit-auto-recipe
                  :lang 'tsx
                  :ts-mode 'tsx-ts-mode
                  :remap '(typescript-tsx-mode)
                  :requires 'typescript
                  :url "https://github.com/tree-sitter/tree-sitter-typescript"
                  :revision revision
                  :source-dir "tsx/src"
                  :ext "\\.tsx\\'"))
    (add-to-list 'treesit-auto-recipe-list
                 (make-treesit-auto-recipe
                  :lang 'typescript
                  :ts-mode 'typescript-ts-mode
                  :remap 'typescript-mode
                  :requires 'tsx
                  :url "https://github.com/tree-sitter/tree-sitter-typescript"
                  :revision revision
                  :source-dir "typescript/src"
                  :ext "\\.ts\\'"))
    )
  )
(use-package tree-sitter-langs :ensure t)
(use-package tree-sitter
  :ensure t
  :hook ((typescript-ts-mode . tree-sitter-hl-mode)
         (tsx-ts-mode . tree-sitter-hl-mode))
  :init
  (require 'tree-sitter)
  (global-tree-sitter-mode)
  :config
  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist '(tsx-ts-mode . tsx))
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-ts-mode . tsx))
  )

(provide '43-typescript)
;;; 43-typescript.el ends here
