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

(use-package tree-sitter-langs :ensure t)
(use-package tree-sitter
  :ensure t
  :config
  (global-tree-sitter-mode)
  (tree-sitter-require 'tsx)
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-mode . tsx))
  (defun around-tree-sitter--do-parse (func &rest args)
    (ignore-errors
      (apply func args)))
  (advice-add 'tree-sitter--do-parse :around 'around-tree-sitter--do-parse)
  (setq treesit-language-source-alist
        '((tsx        "https://github.com/tree-sitter/tree-sitter-typescript"
                      "v0.20.3"
                      "tsx/src")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript"
                      "v0.20.3"
                      "typescript/src")))

  )

(provide '43-typescript)
;;; 43-typescript.el ends here
