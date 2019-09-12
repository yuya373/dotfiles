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

(defun file-tsx-p ()
  (string-suffix-p "tsx"
                   (or (buffer-file-name)
                       (buffer-name))))

(defun typescript-setup-projectile ()
  (interactive)
  (if (cl-find-if #'(lambda (file-name) (string= "yarn.lock" file-name))
                  (projectile-project-files (projectile-project-root)))
      (setq-local projectile-project-compilation-cmd "yarn run tsc --noEmit")
    (setq-local projectile-project-compilation-cmd "npm run tsc --noEmit")))

(use-package web-mode
  :mode (("\\.tsx\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-block-padding 2
        web-mode-comment-style 2
        web-mode-auto-quote-style 1

        web-mode-enable-css-colorization t
        web-mode-enable-auto-pairing t
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        )
  (setq web-mode-extra-auto-pairs nil)
  (defun setup-tsx ()
    (when (and (buffer-file-name)
               (string= "tsx" (file-name-extension
                               (buffer-file-name))))
      (eldoc-mode +1)
      (typescript-setup-projectile)))
  (add-hook 'web-mode-hook 'setup-tsx))

(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode))
  :init
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode-hook 'typescript-setup-projectile)
  :config
  (use-package sgml-mode))


(provide '43-typescript)
;;; 43-typescript.el ends here
