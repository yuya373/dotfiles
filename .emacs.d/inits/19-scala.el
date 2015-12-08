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

(el-get-bundle company)
(el-get-bundle scala-mode2)
(el-get-bundle ensime)

(use-package company
  :commands (company-mode)
  :init
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq company-auto-complete nil)
  :config
  (defun company--insert-candidate2 (candidate)
    (when (> (length candidate) 0)
      (setq candidate (substring-no-properties candidate))
      (if (eq (company-call-backend 'ignore-case) 'keep-prefix)
          (insert (company-strip-prefix candidate))
        (if (equal company-prefix candidate)
            (company-select-next)
          (delete-region (- (point) (length company-prefix)) (point))
          (insert candidate))
        )))

  (defun company-complete-common2 ()
    (interactive)
    (when (company-manual-begin)
      (if (and (not (cdr company-candidates))
               (equal company-common (car company-candidates)))
          (company-complete-selection)
        (company--insert-candidate2 company-common))))

  (define-key company-active-map [tab] 'company-complete-common2)
  (define-key company-active-map [backtab] 'company-select-previous) ; おまけ

  (define-key company-active-map (kbd "C-w") 'backward-kill-word)
  (define-key company-active-map (kbd "C-h") 'delete-backward-char)

  ;; C-n, C-pで補完候補を次/前の候補を選択
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)

  ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
  (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
  (set-face-attribute 'company-tooltip nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "white" :background "steelblue")
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "black" :background "steelblue")
  (set-face-attribute 'company-preview-common nil
                      :background nil :foreground "lightgrey" :underline t)
  (set-face-attribute 'company-scrollbar-fg nil
                      :background "orange")
  (set-face-attribute 'company-scrollbar-bg nil
                      :background "gray40"))

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
  ;; (setq ensime-completion-style 'auto-complete)
  (setq ensime-completion-style 'company)
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
  (add-hook 'ensime-inf-mode-hook 'auto-complete-mode)
  (add-hook 'ensime-mode-hook
            #'(lambda ()
                ;; (setq ac-auto-start nil
                ;;       ac-sources '(ac-source-ensime-completions
                ;;                    ac-source-words-in-same-mode-buffers
                ;;                    ac-source-words-in-buffer)
                ;;       ac-use-comphist t
                ;;       ac-dwim t)
                (auto-complete-mode -1)
                (company-mode)
                (kill-local-variable 'company-backends)
                (add-to-list 'company-backends 'ensime-company)))
  ;; (add-hook 'ensime-inf-mode-hook 'smartparens-mode)
  :config
  (defun ensime-inf-eval-region-with-paste (start end)
    (interactive "r")
    (ensime-inf-assert-running)
    (comint-send-string ensime-inf-buffer-name ":paste\n")
    (comint-send-region ensime-inf-buffer-name start end)
    (comint-send-string ensime-inf-buffer-name "\n")
    (with-current-buffer ensime-inf-buffer-name
      (comint-send-eof)))

  (defun ensime-inf-eval-buffer-with-paste ()
    (interactive)
    (ensime-inf-eval-region-with-paste (point-min) (point-max)))

  (evil-define-key 'normal ensime-mode-map
    ",e" 'ensime
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

    ",tc" 'ensime-typecheck-current-file
    ",tC" 'ensime-typecheck-all

    ",gt" 'ensime-goto-test
    ",gi" 'ensime-goto-impl)
  (evil-define-key 'visual ensime-mode-map
    ",ier" 'ensime-inf-eval-region-with-paste)
  (evil-define-key 'insert ensime-mode-map
    "." 'nil))

(provide '19-scala)
;;; 19-scala.el ends here
