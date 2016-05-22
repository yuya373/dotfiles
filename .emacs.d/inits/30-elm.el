;;; 30-elm.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2016  南優也

;; Author: 南優也 <yuyaminami@minamiyuuya-no-MacBook.local>
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

(el-get-bundle elm-mode)
(use-package elm-mode
  :mode (("\\.elm\\'" . elm-mode))
  :commands (run-elm-interactive)
  :init
  (defun my-elm-company-setup ()
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends '(company-elm :with company-dabbrev-code)))
  (add-hook 'elm-mode-hook #'my-elm-company-setup)
  (add-hook 'elm-interactive-mode-hook #'my-elm-company-setup)
  (add-hook 'elm-interactive-mode-hook 'smartparens-mode)
  :config
  (defun switch-to-elm-interactive ()
    (interactive)
    (let ((buf (get-buffer elm-interactive--buffer-name)))
      (if buf (display-buffer buf)
        (run-elm-interactive))))
  (evil-define-key 'visual elm-mode-map
    ",er" #'elm-repl-push)
  (evil-define-key 'normal elm-mode-map
    ",el" #'elm-repl-load
    ",ed" #'elm-repl-push-decl
    ",ca" #'elm-compile-add-annotations
    ",ci" #'elm-compile-clean-imports
    ",cb" #'elm-compile-buffer
    ",cm" #'elm-compile-main
    ",hd" #'elm-oracle-doc-at-point
    ",ht" #'elm-oracle-type-at-point
    ",vb" #'elm-preview-buffer
    ",vm" #'elm-preview-main
    ",i" nil
    ",im" #'elm-import
    ",ii" #'switch-to-elm-interactive))

(el-get-bundle flycheck-elm)
(use-package flycheck-elm
  :commands (flycheck-elm-setup)
  :init
  (add-hook 'elm-mode-hook 'flycheck-elm-setup))

(provide '30-elm)
;;; 30-elm.el ends here
