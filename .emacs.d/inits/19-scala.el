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


(use-package scala-mode
  :ensure t
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
  :ensure t
  :mode (("\\.sbt\\'" . sbt-mode))
  :config
  (evil-define-key 'normal sbt-mode-map
    ",ss" 'sbt-start
    ",sc" 'sbt-command))

(use-package yasnippet
  :ensure t
  :commands (yas-minor-mode))

(provide '19-scala)
;;; 19-scala.el ends here
