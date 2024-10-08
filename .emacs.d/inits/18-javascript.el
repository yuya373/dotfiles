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

(use-package js2-mode
  :ensure t
  :mode (;; ("\\.js\\'" . js2-mode)
         ;; ("\\.jsx\\'" . js2-jsx-mode)
         ;; ("\\.jsx.js\\'" . js2-jsx-mode)
         )
  :diminish js2-minor-mode
  :init
  ;; (setq js2-include-browser-externs nil)
  (setq js2-basic-offset 2)
  (setq js2-skip-preprocessor-directives t
        js-chain-indent t
        ;; let flycheck handle this
        js2-mode-show-parse-errors nil
        js2-mode-show-strict-warnings nil
        ;; Flycheck provides these features, so disable them: conflicting with
        ;; the eslint settings.
        js2-strict-trailing-comma-warning nil
        js2-strict-missing-semi-warning nil
        ;; maximum fontification
        js2-highlight-level 3
        js2-highlight-external-variables t)
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

(use-package rjsx-mode
  :ensure t
  :mode (("\\.jsx\\'" . rjsx-mode)
         ("\\.js\\'" . rjsx-mode))
  :commands (rjsx-minor-mode)
  :diminish rjsx-minor-mode
  )

(use-package coffee-mode
  :ensure t
  :mode (("\\.coffee\\'" . coffee-mode))
  :init
  (setq coffee-tab-width 2)
  (setq coffee-indent-tabs-mode nil))


(provide '18-javascript)
;;; 18-javascript.el ends here
