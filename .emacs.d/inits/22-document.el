;;; 22-document.el ---                                    -*- lexical-binding: t; -*-

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
  (require 'evil-leader))

(el-get-bundle adoc-mode)
(use-package adoc-mode
  :mode (("\\.asciidoc\\'" . adoc-mode))
  :init
  (add-hook 'adoc-mode-hook #'(lambda () (buffer-face-mode t))))

(el-get-bundle csv-mode)
(use-package csv-mode
  :mode (("\\.csv\\'" . csv-mode))
  :config
  (evil-define-key 'normal csv-mode-map
    ",a" 'csv-align-fields))

(el-get-bundle org-mode)
(el-get-bundle evil-org-mode)
(el-get-bundle org-bullets)

(use-package org-bullets
  :commands (org-bullets-mode)
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))

(use-package evil-org
  :commands (evil-org-mode)
  :init
  (add-hook 'org-mode-hook 'evil-org-mode)
  :config
  (evil-define-key 'visual evil-org-mode-map
    ",m" 'org-md-convert-region-to-md)
  (evil-define-key 'normal evil-org-mode-map
    ;; ",tc" 'org-toggle-checkbox
    "t" nil
    ",m" 'org-md-export-to-markdown
    ",iT" 'evil-org-insert-subtodo
    ",rc" 'evil-org-recompute-clocks
    )
  (evil-leader/set-key-for-mode 'org-mode
    "t"  nil
    "a"  nil
    "c"  nil
    "l"  nil
    "o"  nil
    )
  )

(use-package org
  :mode (("\\.org\\'" . org-mode))
  :init
  (setq org-log-done 'note)
  (setq org-todo-keywords '((list "TODO(t)" "DOING(d!)" "REVIEW(r@)" "BLOCKED(b@)" "|" "DONE(!@)")))
  (setq org-src-fontify-natively t)
  (setq org-directory "~/Dropbox/junk")
  (setq org-agenda-files (list org-directory))
  :config
  (defun my-org-insert-structure (key)
    (org-complete-expand-structure-template
     (point-at-bol)
     (assoc key org-structure-template-alist)))

  ;; Value: (("s" "#+BEGIN_SRC ?\n\n#+END_SRC")
  ;;  ("e" "#+BEGIN_EXAMPLE\n?\n#+END_EXAMPLE")
  ;;  ("q" "#+BEGIN_QUOTE\n?\n#+END_QUOTE")
  ;;  ("v" "#+BEGIN_VERSE\n?\n#+END_VERSE")
  ;;  ("V" "#+BEGIN_VERBATIM\n?\n#+END_VERBATIM")
  ;;  ("c" "#+BEGIN_CENTER\n?\n#+END_CENTER")
  ;;  ("l" "#+BEGIN_EXPORT latex\n?\n#+END_EXPORT")
  ;;  ("L" "#+LaTeX: ")
  ;;  ("h" "#+BEGIN_EXPORT html\n?\n#+END_EXPORT")
  ;;  ("H" "#+HTML: ")
  ;;  ("a" "#+BEGIN_EXPORT ascii\n?\n#+END_EXPORT")
  ;;  ("A" "#+ASCII: ")
  ;;  ("i" "#+INDEX: ?")
  ;;  ("I" "#+INCLUDE: %file ?"))

  (defun org-insert-template-src ()
    (interactive)
    (my-org-insert-structure "s"))

  (defun org-insert-template-html ()
    (interactive)
    (my-org-insert-structure "h"))

  (defun org-insert-template-quote ()
    (interactive)
    (my-org-insert-structure "q"))

  (evil-define-key 'normal org-mode-map
    ",t" 'org-todo
    ",p" 'org-set-property
    ",it" nil
    ;; ",it" '(lambda () (interactive) (org-insert-todo-heading nil))
    ",id" 'org-deadline
    ",il" 'org-insert-link
    ",ih" 'org-insert-heading
    ",ip" 'org-priority
    ",is" 'org-schedule
    ",its" 'org-insert-template-src
    ",ith" 'org-insert-template-html
    ",itq" 'org-insert-template-quote
    (kbd "RET") 'org-open-at-point))

(use-package org-agenda
  :commands (org-agenda)
  :init
  (setq org-agenda-window-setup 'current-window)
  (setq org-agenda-restore-windows-after-quit t)
  :config
  ;; https://gist.github.com/amirrajan/301e74dc844a4c9ffc3830dc4268f177
  (evil-set-initial-state 'org-agenda-mode 'normal)
  (evil-define-key 'normal org-agenda-mode-map
    (kbd "<RET>") 'org-agenda-switch-to
    (kbd "\t") 'org-agenda-goto

    "q" 'org-agenda-quit
    "r" 'org-agenda-redo
    "S" 'org-save-all-org-buffers
    "gj" 'org-agenda-goto-date
    "gJ" 'org-agenda-clock-goto
    "gm" 'org-agenda-bulk-mark
    "go" 'org-agenda-open-link
    "s" 'org-agenda-schedule
    "+" 'org-agenda-priority-up
    "," 'org-agenda-priority
    "-" 'org-agenda-priority-down
    "y" 'org-agenda-todo-yesterday
    "n" 'org-agenda-add-note
    "t" 'org-agenda-todo
    ":" 'org-agenda-set-tags
    ";" 'org-timer-set-timer
    "I" 'helm-org-task-file-headings
    "i" 'org-agenda-clock-in-avy
    "O" 'org-agenda-clock-out-avy
    "u" 'org-agenda-bulk-unmark
    "x" 'org-agenda-exit
    "j"  'org-agenda-next-line
    "k"  'org-agenda-previous-line
    "vt" 'org-agenda-toggle-time-grid
    "va" 'org-agenda-archives-mode
    "vw" 'org-agenda-week-view
    "vl" 'org-agenda-log-mode
    "vd" 'org-agenda-day-view
    "vc" 'org-agenda-show-clocking-issues
    "g/" 'org-agenda-filter-by-tag
    "o" 'delete-other-windows
    "gh" 'org-agenda-holiday
    "gv" 'org-agenda-view-mode-dispatch
    "f" 'org-agenda-later
    "b" 'org-agenda-earlier
    "c" 'helm-org-capture-templates
    "e" 'org-agenda-set-effort
    "n" nil  ; evil-search-next
    "{" 'org-agenda-manipulate-query-add-re
    "}" 'org-agenda-manipulate-query-subtract-re
    "A" 'org-agenda-toggle-archive-tag
    "." 'org-agenda-goto-today
    "0" 'evil-digit-argument-or-evil-beginning-of-line
    "<" 'org-agenda-filter-by-category
    ">" 'org-agenda-date-prompt
    "F" 'org-agenda-follow-mode
    "D" 'org-agenda-deadline
    "H" 'org-agenda-holidays
    "J" 'org-agenda-next-date-line
    "K" 'org-agenda-previous-date-line
    "L" 'org-agenda-recenter
    "P" 'org-agenda-show-priority
    "R" 'org-agenda-clockreport-mode
    "Z" 'org-agenda-sunrise-sunset
    "T" 'org-agenda-show-tags
    "X" 'org-agenda-clock-cancel
    "[" 'org-agenda-manipulate-query-add
    "g\\" 'org-agenda-filter-by-tag-refine
    "]" 'org-agenda-manipulate-query-subtract)
  )

(el-get-bundle open-junk-file)
(use-package open-junk-file
  :commands (open-junk-file open-junk-org-today)
  :config
  (setq open-junk-file-format "~/Dropbox/junk/%Y-%m-%d.")
  (defun open-junk-org-today ()
    (interactive)
    (let ((file (format "%sorg"
                        (format-time-string open-junk-file-format (current-time)))))
      (when open-junk-file-make-directory
        (make-directory (file-name-directory file) t))
      (funcall open-junk-file-find-file-function file))))

(use-package org-mobile
  :init
  (setq org-mobile-directory "~/Dropbox/アプリ/MobileOrg")
  (setq org-mobile-inbox-for-pull "~/Dropbox/org/from-mobile.org"))

(provide '22-document)
;;; 22-document.el ends here
