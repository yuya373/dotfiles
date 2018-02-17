;;; 31-compilation.el ---                            -*- lexical-binding: t; -*-

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

(use-package compile
  :defer t
  :diminish compilation-in-progress
  :config
  (setq compilation-scroll-output t)
  (define-key compilation-mode-map (kbd "g") nil)
  (with-eval-after-load "evil"
    (evil-define-key 'normal compilation-mode-map
      "g" nil
      "\C-c" 'evil-window-delete
      "\C-d" 'evil-scroll-down
      "\C-c" 'evil-window-delete
      "\C-m" 'compile-goto-error
      ",v" 'compilation-display-error
      ",n" 'compilation-next-error
      ",p" 'compilation-previous-error
      ",fn" 'compilation-next-file
      ",fp" 'compilation-previous-file
      ",r" 'recompile
      ",c" 'kill-compilation)))

(provide '31-compilation)
;;; 31-compilation.el ends here
