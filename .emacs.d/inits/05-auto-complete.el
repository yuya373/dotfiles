;;; 05-auto-complete.el ---                          -*- lexical-binding: t; -*-

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

;; (el-get-bundle yasnippet)
;; (el-get-bundle yasnippet-snippets)
(el-get-bundle company-mode)
(el-get-bundle company-emoji)
(el-get-bundle company-statistics)

;; (use-package yasnippet
;;   :commands (yas-global-mode)
;;   :init
;;   (add-hook 'after-init-hook 'yas-global-mode)
;;   :config
;;   (use-package yasnippet-snippets
;;     :config
;;     (add-to-list 'yas-snippet-dirs
;;                  (expand-file-name
;;                   (concat user-emacs-directory
;;                           "el-get/yasnippet-snippets")))))

(use-package company-statistics
  :commands (company-statistics-mode)
  :init
  (setq company-statistics-auto-save t)
  (setq company-statistics-auto-restore t)
  (add-hook 'company-mode-hook 'company-statistics-mode)
  :config
  (setq company-transformers '(company-sort-by-statistics
                               company-sort-by-backend-importance
                               company-sort-by-occurrence)))

(use-package company-emoji
  :commands (company-emoji)
  :init
  (setq company-emoji-insert-unicode nil)
  ;; (defun add-company-emoji ()
  ;;   (make-local-variable 'company-backends)
  ;;   (add-to-list 'company-backends 'company-emoji))
  ;; ;; (add-hook 'gfm-mode-hook #'add-company-emoji)
  ;; ;; (add-hook 'slack-edit-message-mode-hook #'add-company-emoji)
  ;; ;; (add-hook 'slack-mode-hook #'add-company-emoji)
  ;; (add-hook 'git-commit-mode-hook #'add-company-emoji)
  ;; (add-hook 'markdown-mode-hook #'add-company-emoji)
  )

(use-package company
  :commands (company-mode global-company-mode)
  ;; :diminish company-mode
  :init
  (setq company-idle-delay 0.5) ; デフォルトは0.5
  (setq company-minimum-prefix-length 2) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq company-auto-complete nil)
  (setq company-tooltip-align-annotations t)
  (setq company-transformers '(company-sort-by-occurrence company-sort-by-backend-importance))
  (setq company-dabbrev-other-buffers t)
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-downcase nil)

  ;; (add-to-list 'completion-styles 'initials)
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-backends
        '((company-capf
           :with
           company-files
           company-keywords)
          (company-dabbrev-code
           company-dabbrev
           company-files          ; files & directory
           company-keywords       ; keywords
           company-gtags
           company-etags
           ;; company-yasnippet
           )))
  ;; (use-package company-yasnippet
  ;;   :config
  ;;   (add-to-list 'company-backends 'company-yasnippet))
  (use-package company-ispell
    :init
    (defun toggle-company-ispell ()
      (interactive)
      (if (memq 'company-ispell company-backends)
          (progn
            (setq company-backends (delete 'company-ispell company-backends))
            (message "Turn OFF `company-ispell'"))
        (add-to-list 'company-backends 'company-ispell)
        (message "Turn ON `company-ispell'")))
    (defun add-company-ispell ()
      (make-local-variable 'company-backends)
      (add-to-list 'company-backends
                   '(company-ispell
                     company-files
                     company-dabbrev
                     )))
    (add-hook 'text-mode-hook #'add-company-ispell)
    ;; (add-hook 'gfm-mode-hook #'add-company-ispell)
    ;; (add-hook 'markdown-mode-hook #'add-company-ispell)
    ;; (add-hook 'org-mode-hook #'add-company-ispell)
    )

  (defun company--insert-candidate2 (candidate)
    (when (> (length candidate) 0)
      (setq candidate (substring-no-properties candidate))
      (if (eq (company-call-backend 'ignore-case) 'keep-prefix)
          (insert (company-strip-prefix candidate))
        (if (equal company-prefix candidate)
            (company-select-next)
          (delete-region (- (point) (length company-prefix)) (point))
          (insert candidate)))))

  (defun company-complete-common2 ()
    (interactive)
    (when (company-manual-begin)
      (if (and (not (cdr company-candidates))
               (equal company-common (car company-candidates)))
          (company-complete-selection)
        (company--insert-candidate2 company-common))))

  (define-key company-active-map (kbd "C-w") 'backward-kill-word)
  (define-key company-active-map (kbd "C-h") 'delete-backward-char)
  (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  ;; (define-key company-active-map [tab] 'company-select-next)
  (define-key company-active-map [backtab] 'company-select-previous)
  (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-w") 'backward-kill-word)
  (define-key company-search-map (kbd "C-h") 'delete-backward-char)
  ;; (define-key company-active-map [tab] 'company-complete-common2)
  ;; (define-key company-search-map [tab] 'company-select-next)
  (define-key company-search-map [backtab] 'company-select-previous)
  (define-key company-search-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)

  ;; (set-face-attribute 'company-tooltip nil
  ;;                     :foreground "black" :background "lightgrey")
  ;; (set-face-attribute 'company-tooltip-common nil
  ;;                     :foreground "black" :background "lightgrey")
  ;; (set-face-attribute 'company-tooltip-common-selection nil
  ;;                     :foreground "white" :background "steelblue")
  ;; (set-face-attribute 'company-tooltip-selection nil
  ;;                     :foreground "black" :background "steelblue")
  ;; (set-face-attribute 'company-preview-common nil
  ;;                     :background nil :foreground "lightgrey" :underline t)
  ;; (set-face-attribute 'company-scrollbar-fg nil
  ;;                     :background "orange")
  ;; (set-face-attribute 'company-scrollbar-bg nil
  ;;                     :background "gray40")
  ;; (set-face-attribute 'company-tooltip-annotation nil
  ;;                     :foreground "black" :background "lightgrey")
  ;; (set-face-attribute 'company-tooltip-annotation-selection nil
  ;;                     :foreground "white" :background "steelblue")
  (diminish 'abbrev-mode))

(el-get-bundle know-your-http-well)
(use-package know-your-http-well
  :defer t
  :init
  (add-to-list 'load-path
               (expand-file-name
                (concat user-emacs-directory
                        "el-get/know-your-http-well/emacs"))))
(el-get-bundle company-restclient)
(use-package company-restclient
  :commands (company-restclient)
  :init
  (defun my-comp-restclient ()
    ;; (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-restclient))
  (add-hook 'restclient-mode-hook 'my-comp-restclient))


(el-get-bundle pos-tip
  :type github
  :pkgname "pitkali/pos-tip"
  :name pos-tip)

;; (el-get-bundle ycmd)
;; (use-package ycmd
;;   :commands (global-ycmd-mode)
;;   :init
;;   (add-hook 'company-mode-hook 'global-ycmd-mode)
;;   (setq ycmd-server-command '("python" "/Users/yuyaminami/dev/ycmd/ycmd"))
;;   )

;; ;; (global-ycmd-mode -1)

;; (el-get-bundle company-ycmd)
;; (use-package company-ycmd
;;   :commands (company-ycmd-setup)
;;   :init
;;   (add-hook 'global-ycmd-mode-hook 'company-ycmd-setup))


(provide '05-auto-complete)
;;; 05-auto-complete.el ends here
