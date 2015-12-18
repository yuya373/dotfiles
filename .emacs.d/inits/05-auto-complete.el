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

(el-get-bundle company)
(el-get-bundle company-quickhelp)
(el-get-bundle company-emoji)

(use-package company-quickhelp
  :commands (company-quickhelp-mode)
  :init
  (add-hook 'company-mode-hook '(lambda () (company-quickhelp-mode t))))

(use-package company-emoji
  :commands (company-emoji)
  :init
  (defun add-company-emoji ()
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-emoji))
  ;; (add-hook 'gfm-mode-hook #'add-company-emoji)
  (add-hook 'slack-mode-hook #'add-company-emoji)
  (add-hook 'git-commit-mode-hook #'add-company-emoji)
  (add-hook 'markdown-mode-hook #'add-company-emoji))

(use-package company
  :commands (company-mode global-company-mode)
  :init
  (setq company-idle-delay 0) ; デフォルトは0.5
  (setq company-minimum-prefix-length 3) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq company-auto-complete nil)
  (setq company-tooltip-align-annotations t)
  (setq company-transformers '(company-sort-by-occurrence company-sort-by-backend-importance))
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-backends (delete 'company-bbdb company-backends))
  (setq company-backends (delete 'company-cmake company-backends))
  (setq company-backends (delete 'company-clang company-backends))
  (setq company-backends (delete 'company-eclim company-backends))
  (setq company-backends (delete 'company-oddmuse company-backends))
  (setq company-backends (delete 'company-xcode company-backends))
  (setq company-backends (delete 'company-capf company-backends))
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

  (with-eval-after-load "evil"
    (evil-define-key 'insert company-active-map
      (kbd "C-n") 'company-select-next
      (kbd "C-p") 'company-select-previous)
    (evil-define-key 'insert company-search-map
      (kbd "C-n") 'company-select-next
      (kbd "C-p") 'company-select-previous))

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

(el-get-bundle pos-tip
  :type github
  :pkgname "pitkali/pos-tip"
  :name pos-tip)

;; (use-package pos-tip
;;   :commands (pos-tip-show))

(provide '05-auto-complete)
;;; 05-auto-complete.el ends here
