;;; 19-scala.el ---                                  -*- lexical-binding: t; -*-

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

(el-get-bundle scala-mode2)
(el-get-bundle ensime)

(use-package scala-mode2
  :mode (("\\.scala\\'" . scala-mode)
         ("\\.sbt\\'" . scala-mode)))
(use-package ensime
  :commands (ensime-scala-mode-hook)
  :init
  (defun scala/enable-eldoc ()
    "Show error message or type name at point by Eldoc."
    (setq-local eldoc-documentation-function
                #'(lambda ()
                    (when (ensime-connected-p)
                      (let ((err (ensime-print-errors-at-point)))
                        (or (and err (not (string= err "")) err)
                            (ensime-print-type-at-point))))))
    (eldoc-mode +1))
  (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
  (add-hook 'ensime-mode-hook 'scala/enable-eldoc)
  (setq ensime-completion-style 'auto-complete)
  :config
  (evil-define-key 'insert ensime-mode-map "." nil))

(provide '19-scala)
;;; 19-scala.el ends here
