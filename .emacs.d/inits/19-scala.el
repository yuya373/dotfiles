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
(el-get-bundle ensime
  :type github
  :branch "2.0"
  :pkgname "ensime/ensime-emacs"
  :compile nil
  )
(el-get-bundle yasnippet)


(use-package scala-mode
  :commands (scala-mode)
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
  :mode (("\\.sbt\\'" . sbt-mode))
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
        ensime-search-interface 'helm
        ensime-tooltip-type-hints t
        ensime-auto-generate-config t
        ensime-company-case-sensitive t
        ensime-eldoc-hints 'all
        )

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

  (remove-hook 'ensime-source-buffer-saved-hook 'ensime-typecheck-current-buffer)
  (remove-hook 'ensime-source-buffer-saved-hook 'ensime-sem-high-refresh-hook)
  (add-hook 'evil-normal-state-entry-hook 'evil-ensime-typeckeck t)
  (add-hook 'evil-normal-state-entry-hook 'evil-ensime-sem-high-refresh t)

  (add-hook 'ensime-mode-hook 'eldoc-mode)
  (setq ensime-inf-cmd-template '(:java :java-flags
                                        "-Djline.terminal=jline.UnsupportedTerminal"
                                        "-Dscala.usejavacp=true"
                                        "scala.tools.nsc.MainGenericRunner"
                                        "-encoding" "UTF-8"
                                        "-deprecation"
                                        "-unchecked"
                                        "-feature"
                                        "-language:higherKinds"
                                        ;; "-Xlint"
                                        ;; "-Xfatal-warnings"
                                        "-Ypartial-unification"
                                        ))
  :config
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
    ",f" 'ensime-format-source

    ",rt" 'ensime-refactor-add-type-annotation
    ",ro" 'ensime-refactor-diff-organize-imports
    ",rit" 'ensime-import-type-at-point
    ",rr" 'ensime-refactor-diff-rename
    ",rel" 'ensime-refactor-diff-extract-local
    ",rem" 'ensime-refactor-diff-extract-method
    ",ril" 'ensime-refactor-diff-inline-local
    ",rec" 'ensime-refactor-expand-match-cases

    ",ns" 'ensime-searc
    ",nu" 'ensime-show-uses-of-symbol-at-point
    ",nh" 'ensime-show-hierarchy-of-type-at-point
    ",nl" 'ensime-edit-definition
    ",np" 'ensime-pop-find-definition-stack
    ",ne" 'ensime-expand-selection-command

    ",ht" 'ensime-type-at-point
    ",hT" 'ensime-type-at-point-full-name
    ",hh" 'ensime-show-doc-for-symbol-at-point
    ",hp" 'ensime-project-docs

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
    ",tr" 'ensime-reload-open-files

    ",gd" 'ensime-edit-definition
    ",gt" 'ensime-goto-test
    ",gi" 'ensime-goto-impl)
  (evil-define-key 'visual ensime-mode-map
    ",ier" 'ensime-inf-eval-region-with-paste))

(provide '19-scala)
;;; 19-scala.el ends here
