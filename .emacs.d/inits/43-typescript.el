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
  (require 'el-get)
  (require 'use-package))

(el-get-bundle typescript-mode)
(el-get-bundle tree-sitter-langs)
(el-get-bundle tree-sitter)
(el-get-bundle orzechowskid/tsi.el :name tsi)
(el-get-bundle coverlay)
(el-get-bundle gregsexton/origami.el :name origami)
(el-get-bundle orzechowskid/tsx-mode.el :name tsx-mode)
(el-get-bundle graphql-mode)


(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode))
  :init
  (setq typescript-indent-level 2))

(use-package tsx-mode
  :mode (("\\.tsx\\'" . tsx-mode))
  :init
  (setq tsx-mode-tsx-auto-tags t)
  :config
  (defun around-tsx-mode--css-update-regions (func &rest args)
    (ignore-errors
      (apply func args)))
  (advice-add 'tsx-mode--css-update-regions :around 'around-tsx-mode--css-update-regions))

(use-package tree-sitter
  :config
  (defun around-tree-sitter--do-parse (func &rest args)
    (ignore-errors
      (apply func args)))
  (advice-add 'tree-sitter--do-parse :around 'around-tree-sitter--do-parse))


(provide '43-typescript)
;;; 43-typescript.el ends here
