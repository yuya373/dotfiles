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
(el-get-bundle web-mode)
(el-get-bundle tide)

;; (use-package web-mode
;;   :mode (("\\.tsx\\'" . web-mode))
;;   :init
;;   (setq web-mode-markup-indent-offset 2
;;         web-mode-css-indent-offset 2
;;         web-mode-code-indent-offset 2
;;         )

;;   (defun setup-tsx ()
;;     (when (and (buffer-file-name)
;;                (string= "tsx" (file-name-extension
;;                                (buffer-file-name))))
;;       (add-hook 'before-save-hook 'tide-format-before-save nil t)
;;       (eldoc-mode +1)
;;       (tide-setup)))
;;   (add-hook 'web-mode-hook 'setup-tsx))

(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode))
  :init
  (setq typescript-indent-level 2)
  :config
  (use-package sgml-mode))

(use-package tide
  :init
  (defun setup-tide-format ()
    (add-hook 'before-save-hook 'tide-format-before-save nil t))
  (add-hook 'tide-mode-hook 'setup-tide-format)

  (add-hook 'typescript-mode-hook 'tide-setup)
  (setq tide-completion-detailed t
        tide-completion-enable-autoimport-suggestions t
        tide-allow-popup-select '(code-fix
                                  refactor
                                  jump-to-implementation)
        tide-always-show-documentation t
        )
  (setq tide-format-options '(:tabSize 2 :indentSize 2 :baseIndentSize 0))
  :config
  (flycheck-add-next-checker 'typescript-tide 'javascript-eslint t)
  (flycheck-add-mode 'tsx-tide 'rjsx-mode)
  (flycheck-add-next-checker 'tsx-tide 'javascript-eslint t)
  (evil-define-key 'visual tide-mode-map
    ",rr" 'tide-refactor)
  (evil-define-key 'normal tide-mode-map
    ",h" 'tide-documentation-at-point
    ",e" 'tide-project-errors
    ",rr" 'tide-refactor
    ",re" 'tide-references
    ",rf" 'tide-rename-file
    ",rs" 'tide-rename-symbol
    ",fo" 'tide-format
    ",fi" 'tide-fix
    ",o" 'tide-organize-imports
    ))



(provide '43-typescript)
;;; 43-typescript.el ends here
