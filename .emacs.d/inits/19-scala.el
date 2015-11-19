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
  (setq ensime-completion-style 'auto-complete)
  (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

  (defun scala/enable-eldoc ()
    "Show error message or type name at point by Eldoc."
    (setq-local eldoc-documentation-function
                #'(lambda ()
                    (when (ensime-connected-p)
                      (let ((err (ensime-print-errors-at-point)))
                        (or (and err (not (string= err "")) err)
                            (ensime-print-type-at-point))))))
    (eldoc-mode 1))
  (add-hook 'ensime-mode-hook 'scala/enable-eldoc)

  (defun my-ensime-ac-set-up ()
    (setq ac-auto-start 5
          ac-sources '(ac-source-ensime-completions
                       ac-source-words-in-same-mode-buffers
                       ac-source-words-in-buffer)
          ac-use-comphist t
          ac-dwim t))
  (add-hook 'ensime-inf-mode-hook 'auto-complete-mode)
  (add-hook 'ensime-mode-hook 'my-ensime-ac-set-up)

  ;; (add-hook 'ensime-inf-mode-hook 'smartparens-mode)
  :config
  (evil-define-key 'normal ensime-mode-map
    ",e" 'ensime
    ",R" 'ensime-reload-open-files
    ",I" 'ensime-import-type-at-point

    ",rr" 'ensime-refactor-rename
    ",ro" 'ensime-refactor-organize-imports
    ",rl" 'ensime-refactor-extract-local
    ",rm" 'ensime-refactor-extract-method
    ",ri" 'ensime-refactor-inline-local

    ",cg" 'ensime-config-gen
    ",ht" 'ensime-inspect-type-at-point
    ",hp" 'ensime-inspect-package-at-point
    ",hh" 'ensime-show-uses-of-symbol-at-point

    ",ss" 'ensime-sbt-switch
    ",sc" 'ensime-sbt-do-compile
    ",sC" 'ensime-sbt-do-clean
    ",sg" 'ensime-sbt-do-gen-ensime
    ",st" 'ensime-sbt-do-test-dwim
    ",sp" 'ensime-sbt-do-package
    ",sr" 'ensime-sbt-do-run

    ",is" 'ensime-inf-switch
    ",il" 'ensime-inf-load-file
    ",ieb" 'ensime-inf-eval-buffer
    ",ied" 'ensime-inf-eval-definition

    ",gt" 'ensime-goto-test
    ",gi" 'ensime-goto-impl)
  (evil-define-key 'visual ensime-mode-map
    ",ier" 'ensime-inf-eval-region)
  (evil-define-key 'insert ensime-mode-map
    "." 'nil))

(provide '19-scala)
;;; 19-scala.el ends here
