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
  (require 'evil))

(use-package solarized
  :ensure solarized-theme
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
  :config
  (use-package solarized-palettes)
  (use-package whitespace
    :diminish whitespace-mode
    :init
    (add-hook 'prog-mode-hook #'(lambda () (whitespace-mode 1)))
    :config
    (setq whitespace-style '(face
                             trailing
                             tabs
                             indentation
                             ;; indentation::space
                             spaces
                             ;; empty
                             newline
                             newline-mark
                             space-mark
                             tab-mark))
    (setq whitespace-display-mappings
          '((space-mark ?\u3000 [?\　])
            (newline-mark ?\n [?\¬ ?\n])
            (tab-mark ?\t [?\▸ ?\▸])))
    (setq whitespace-space-regexp "\\(\u3000+\\)")
    (add-hook 'whitespace-mode-hook 'modify-whitespace-faces)
    (defun modify-whitespace-faces ()
      (interactive)
      (set-face-bold 'whitespace-space t)
      (set-face-bold 'whitespace-trailing t)
      (set-face-underline  'whitespace-trailing t)
      (solarized-with-color-variables 'dark 'solarized-dark
        solarized-dark-color-palette-alist
        `((set-face-foreground 'whitespace-space red)
          (set-face-background 'whitespace-space 'nil)
          (set-face-foreground 'whitespace-trailing red)
          (set-face-background 'whitespace-trailing 'nil)
          (set-face-foreground 'whitespace-newline  base00)
          (set-face-background 'whitespace-newline 'nil)
          (set-face-background 'whitespace-tab magenta)
          (set-face-foreground 'whitespace-tab base03))))))


(provide '12-theme)
;;; 12-theme.el ends here
