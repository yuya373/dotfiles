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

(el-get-bundle scala-mode)
(el-get-bundle ensime)
(el-get-bundle yasnippet)

(use-package scala-mode
  :mode (("\\.scala\\'" . scala-mode))
  :init
  (defun my-scala-mode-hook ()
    (setq-local helm-dash-docsets '("Scala"))
    ;; (setq imenu-generic-expression
    ;;       '(("var" "\\(var +\\)\\([^(): ]+\\)" 2)
    ;;         ("val" "\\(val +\\)\\([^(): ]+\\)" 2)
    ;;         ("override def" "^[ \\t]*\\(override\\) +\\(def +\\)\\([^(): ]+\\)" 3)
    ;;         ("implicit def" "^[ \\t]*\\(implicit\\) +\\(def +\\)\\([^(): ]+\\)" 3)
    ;;         ("def" "^[ \\t]*\\(def +\\)\\([^(): ]+\\)" 2)
    ;;         ("trait" "\\(trait +\\)\\([^(): ]+\\)" 2)
    ;;         ("class" "^[ \\t]*\\(class +\\)\\([^(): ]+\\)" 2)
    ;;         ("abstract class" "^[ \\t]*\\(abstract class +\\)\\([^(): ]+\\)" 2)
    ;;         ("case class" "^[ \\t]*\\(case class +\\)\\([^(): ]+\\)" 2)
    ;;         ("object" "\\(object +\\)\\([^(): ]+\\)" 2)))
    )
  (add-hook 'scala-mode-hook #'my-scala-mode-hook))

(use-package sbt-mode
  :mode (("\\.sbt\\'" . scala-mode))
  :config
  (evil-define-key 'normal sbt-mode-map
    ",ss" 'sbt-start
    ",sc" 'sbt-command))

(use-package yasnippet
  :commands (yas-minor-mode))

(use-package ensime
  :commands (ensime-mode ensime)
  :init
  (add-hook 'scala-mode-hook 'ensime-mode)
  (setq ensime-startup-notification nil
        ensime-startup-snapshot-notification nil
        ensime-sbt-perform-on-save nil
        ensime-completion-style 'company
        ensime-sem-high-enabled-p t
        ensime-typecheck-when-idle t
        ensime-use-helm t
        ensime-tooltip-type-hints t
        ensime-auto-generate-config nil
        ensime-company-case-sensitive t
        )
  (defun ensime-typecheck-lazy ()
    (if (and (bound-and-true-p ensime-mode)
             (bound-and-true-p ensime-buffer-connection))
        (ensime-typecheck-current-buffer)))

  (defun evil-ensime-typeckeck ()
    (if (and (bound-and-true-p ensime-mode)
             (bound-and-true-p ensime-buffer-connection)
             (ensime-connected-p))
        (ensime-typecheck-current-buffer)))
  (defun evil-ensime-sem-high-refresh ()
    (if (and (bound-and-true-p ensime-mode)
             (bound-and-true-p ensime-buffer-connection)
             (ensime-connected-p))
        (ensime-sem-high-refresh-buffer)))

  (defun my-ensime-configure ()
    (remove-hook 'ensime-source-buffer-saved-hook 'ensime-typecheck-current-buffer)
    (remove-hook 'ensime-source-buffer-saved-hook 'ensime-sem-high-refresh-hook)

    (add-hook 'evil-normal-state-entry-hook 'evil-ensime-typeckeck t)
    (add-hook 'evil-normal-state-entry-hook 'evil-ensime-sem-high-refresh t)
    )
  (add-hook 'ensime-mode-hook 'my-ensime-configure)


  (defun ensime-print-errors-only-at-point ()
    (interactive)
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
  (defun ensime-company-enable ()
    (interactive)
    (make-local-variable 'company-backends)
    (company-mode t)
    (add-to-list 'company-backends
                 '(ensime-company :with company-dabbrev))

    (set (make-local-variable 'company-idle-delay) 0)
    (set (make-local-variable 'company-minimum-prefix-length) 2)

    ;; https://github.com/joaotavora/yasnippet/issues/708#issuecomment-222517433
    (yas-minor-mode t)
    (make-local-variable 'yas-minor-mode-map)
    (define-key yas-minor-mode-map [(tab)] nil)
    (define-key yas-minor-mode-map (kbd "TAB") nil)

    (if (window-system)
        (local-set-key [tab] #'ensime-company-complete-or-indent)
      (local-set-key (kbd "TAB") #'ensime-company-complete-or-indent)))

  :config
  ;; (require 'ensime-expand-region)
  (defun ensime-eldoc-info ()
    "ELDoc backend for ensime."
    ;; The response from `ensime-rpc-symbol-at-point' has the type info but,
    ;; its sligthly different from the one obtained with `ensime-type-at-point'
    ;; Using the underlying `ensime-rpc-get-type-at-point' to maintain consistency
    (when (ensime-connected-p)
      (let ((msg (pcase ensime-eldoc-hints
                   (`error
                    (mapconcat 'identity (ensime-errors-at (point)) "\n"))
                   (`implicit
                    (mapconcat 'identity (ensime-implicit-notes-at (point)) "\n"))
                   (`type
                    (or (ensime-eldoc-type-info) ""))
                   (`all
                    (format "%s\n%s\n%s"
                            (or (ensime-eldoc-type-info) "")
                            (mapconcat 'identity (ensime-implicit-notes-at (point)) "\n")
                            (mapconcat 'identity (ensime-errors-at (point)) "\n"))))))
        (when msg
          (eldoc-message (s-trim msg))))))
  (defun advice-ensime-imenu-index-function (org-func)
    (if (ensime-connected-p)
        (funcall org-func)
      (funcall 'scala-imenu:create-imenu-index)))
  (advice-add 'ensime-imenu-index-function
              :around
              'advice-ensime-imenu-index-function)

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
    (let ((first-line (cl-first (split-string
                                 (buffer-substring-no-properties (point-min) (point-max))
                                 "\n"))))
      (ensime-inf-eval-region-with-paste (if (string-match "package" first-line)
                                             (+ (length first-line) (point-min))
                                           (point-min))
                                         (point-max))))

  (evil-define-key 'normal ensime-mode-map
    ",e" 'ensime
    ",E" 'ensime-shutdown
    ",R" 'ensime-reload-open-files
    ",I" 'ensime-import-type-at-point
    ",f" 'ensime-format-source

    ",rr" 'ensime-refactor-diff-rename
    ",ro" 'ensime-refactor-diff-organize-imports
    ",rl" 'ensime-refactor-diff-extract-local
    ",rm" 'ensime-refactor-diff-extract-method
    ",ri" 'ensime-refactor-diff-inline-local

    ",ht" 'ensime-type-at-point
    ",hT" 'ensime-type-at-point-full-name
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
