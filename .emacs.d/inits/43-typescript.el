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



(use-package typescript-ts-mode
  :ensure t
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode)))
(use-package treesit-auto
  :ensure t
  :init
  (setq treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (setq treesit-auto-recipe-list
        (cl-remove-if (lambda (e)
                        (or (eq 'typescript (treesit-auto-recipe-lang e))
                            (eq 'tsx (treesit-auto-recipe-lang e))))
                      treesit-auto-recipe-list))
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
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-mode . tsx)))

(provide '43-typescript)
;;; 43-typescript.el ends here
