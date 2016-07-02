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
         ("\\.sbt\\'" . scala-mode))
  :init
  (add-hook 'scala-mode-hook
            #'(lambda ()
                (setq-local helm-dash-docsets '("Scala")))))
(use-package ensime
  :commands (ensime-scala-mode-hook)
  :init
  (setq ensime-sbt-perform-on-save nil)
  (setq ensime-completion-style 'company)
  (setq ensime-sem-high-enabled-p t)
  (setq ensime-typecheck-when-idle nil)
  (setq ensime-use-helm t)
  (setq ensime-tooltip-type-hints t)
  (setq ensime-auto-generate-config t)
  ;; (defun ensime-typecheck-lazy ()
  ;;   (if (and (bound-and-true-p ensime-mode)
  ;;            (bound-and-true-p ensime-buffer-connection))
  ;;       (ensime-typecheck-current-buffer)))
  ;; ensime typecheck ensime-source-buffer-saved-hook, so disable this
  ;; (add-hook 'evil-insert-state-exit-hook 'ensime-typecheck-lazy)
  (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

  (defun ensime-print-errors-only-at-point ()
    (let ((msg (ensime-errors-at (point))))
      (when msg
        (message "%s" msg))))
  (defun ensime-eldoc-info ()
    (when (ensime-connected-p)
      (let ((e (ensime-print-errors-only-at-point)))
        (and e (not (string= e "")) e))))
  (defun scala/enable-eldoc ()
    "Show error message or type name at point by Eldoc."
    (setq-local eldoc-documentation-function
                #'ensime-eldoc-info)
    (eldoc-mode 1))
  (add-hook 'ensime-mode-hook 'scala/enable-eldoc)
  (defun ensime-inf-company ()
    (make-local-variable 'company-backends)
    (setq company-backends (remove 'ensime-company company-backends)))

  (add-hook 'ensime-inf-mode-hook #'(lambda ()
                                      (ensime-inf-company)
                                      (company-mode t)))
  (add-hook 'sbt-mode-hook #'(lambda ()
                               (ensime-inf-company)
                               (company-mode t)))
  (add-hook 'ensime-mode-hook
            #'(lambda ()
                (company-mode)
                (kill-local-variable 'company-backends)
                (make-local-variable 'company-backends)
                (add-to-list 'company-backends
                             '(ensime-company :with company-dabbrev-code))))
  :config
  (defun ensime-inf-eval-region-with-paste (start end)
    (interactive "r")
    (ensime-inf-assert-running)
    (comint-send-string ensime-inf-buffer-name ":paste\n")
    (comint-send-region ensime-inf-buffer-name start end)
    (comint-send-string ensime-inf-buffer-name "\n")
    (sleep-for 0.2)
    (with-current-buffer ensime-inf-buffer-name
      (comint-send-eof)))

  (defun ensime-inf-eval-buffer-with-paste ()
    (interactive)
    (ensime-inf-eval-region-with-paste (point-min) (point-max)))

  (evil-define-key 'normal ensime-mode-map
    ",e" 'ensime
    ",E" 'ensime-shutdown
    ",R" 'ensime-reload-open-files
    ",I" 'ensime-import-type-at-point
    ",f" 'ensime-format-source

    ",rr" 'ensime-refactor-rename
    ",ro" 'ensime-refactor-organize-imports
    ",rl" 'ensime-refactor-extract-local
    ",rm" 'ensime-refactor-extract-method
    ",ri" 'ensime-refactor-inline-local

    ",ht" 'ensime-inspect-type-at-point
    ",hp" 'ensime-inspect-package-at-point
    ",hu" 'ensime-show-uses-of-symbol-at-point
    ",hh" 'ensime-show-doc-for-symbol-at-point

    ",ss" 'ensime-sbt-switch
    ",sc" 'ensime-sbt-do-compile
    ",sC" 'ensime-sbt-do-clean
    ",st" 'ensime-sbt-do-test-dwim
    ",sp" 'ensime-sbt-do-package
    ",sr" 'ensime-sbt-do-run

    ",is" 'ensime-inf-switch
    ",il" 'ensime-inf-load-file
    ",ieb" 'ensime-inf-eval-buffer-with-paste
    ",ied" 'ensime-inf-eval-definition

    ",tc" 'ensime-typecheck-current-buffer
    ",tC" 'ensime-typecheck-all

    ",gd" 'ensime-edit-definition
    ",gt" 'ensime-goto-test
    ",gi" 'ensime-goto-impl)
  (evil-define-key 'visual ensime-mode-map
    ",ier" 'ensime-inf-eval-region-with-paste))

(provide '19-scala)
;;; 19-scala.el ends here
