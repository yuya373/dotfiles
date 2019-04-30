;;; 46-emacs-lisp.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2019

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
  (require 'use-package)
  (require 'evil))

(defun byte-compile-directory (directory)
  (interactive "DByte compile directory: ")
  (byte-recompile-directory directory 0 t))

(use-package elisp-mode
  :config
  (evil-define-key 'normal emacs-lisp-mode-map
    ",cf" 'byte-compile-file
    ",cd" 'byte-compile-directory
    ",es" 'eval-sexp
    ",eb" 'eval-buffer
    ",ef" 'eval-defun)
  (evil-define-key 'normal lisp-interaction-mode-map
    ",c" 'byte-compile-file
    ",es" 'eval-sexp
    ",eb" 'eval-buffer
    ",ef" 'eval-defun)
  (evil-define-key 'visual emacs-lisp-mode-map
    ",er" 'eval-region))



(provide '46-emacs-lisp)
;;; 46-emacs-lisp.el ends here
