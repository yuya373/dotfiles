;;; 12-theme.el ---                                  -*- lexical-binding: t; -*-
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
  ;; (el-get-bundle powerline)
  ;; (el-get-bundle TheBB/spaceline)
  ;; (require 'spaceline)
  ;; (el-get-bundle pdf-tools)
  ;; (require 'pdf-tools)
  )

(el-get-bundle solarized-emacs)
(use-package solarized
  ;; :defer t
  :init
  (setq solarized-high-contrast-mode-line t)
  (setq solarized-distinct-fringe-background t)
  (setq solarized-distinct-doc-face t)

  ;; (setq solarized-use-more-italic t)
  (when window-system
    (defun load-default-theme ()
      (load-solarized-dark))
    (defun load-solarized-dark ()
      (setq solarized-use-less-bold t)
      (load-theme 'solarized-dark t)
      (setq current-theme 'solarized-dark))
    (defun load-solarized-light ()
      (setq solarized-use-less-bold nil)
      (load-theme 'solarized-light t)
      (setq current-theme 'solarized-light))
    (defvar current-theme)
    (defun toggle-theme ()
      (interactive)
      (cl-case current-theme
        (solarized-dark (load-solarized-light))
        (solarized-light (load-solarized-dark))
        (t (load-default-theme))))
    (add-hook 'after-init-hook #'load-default-theme))
  )


;; (el-get-bundle material-theme)
;; (use-package material-theme
;;   :init
;;   (unless window-system
;;     (add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/material-theme")
;;     (add-hook 'after-init-hook #'(lambda () (load-theme 'material t)))))

(provide '12-theme)
;;; 12-theme.el ends here
