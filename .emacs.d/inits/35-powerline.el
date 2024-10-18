;;; 35-powerline.el --- -*- lexical-binding: t -*-

;; Copyright (C) 2016  南優也

;; Author: 南優也 <yuyaminami@minamiyuuya-no-MacBook.local>
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
  )

(use-package spaceline :ensure t)
(use-package spaceline-config
  :commands (spaceline-spacemacs-theme)
  :init
  (setq anzu-cons-mode-line-p nil)
  (setq powerline-height 25)
  (setq powerline-default-separator 'contour)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (add-hook 'after-init-hook 'setup-spaceline)
  (add-hook 'perspeen-mode-hook 'setup-spaceline)
  (defvar slack-modeline "")
  (defun setup-spaceline ()
    (spaceline-spacemacs-theme)
    (spaceline-info-mode)
    (spaceline-define-segment my-slack-modeline
      "Slack"
      slack-modeline)
    (spaceline-define-segment perspeen-name
      "Current perspeen name."
      (when (and (bound-and-true-p perspeen-mode)
                 perspeen-current-ws)
        (perspeen-ws-struct-name perspeen-current-ws)))
    (spaceline-define-segment skk-name
      "skk name."
      (when (and active
                 (bound-and-true-p skk-mode)
                 (stringp skk-modeline-input-mode))
        (string-trim skk-modeline-input-mode)))
    (spaceline-compile
      '((skk-name :priority 100)
        (macrodef
         :priority 80
         :face other-face)
        (evil-state
         :priority 90
         :face highlight-face
         :when active)
        (perspeen-name :priority 80)
        ;; ((persp-name
        ;;   workspace-number
        ;;   window-number)
        ;;  :fallback evil-state
        ;;  :face highlight-face
        ;;  :priority 100)
        (anzu :priority 60)
        ;; auto-compile
        ((buffer-modified
          ;; buffer-size
          buffer-id
          remote-host)
         :priority 100)
        (major-mode
         :priority 90)
        (process :when active :priority 90)
        ((flycheck-error flycheck-warning flycheck-info)
         :when active
         :priority 100)
        (minor-modes :when active :priority 70)
        ;; (mu4e-alert-segment :when active)
        ;; (erc-track :when active)
        ;; (version-control :when active
        ;;                  :priority 78)
        ;; (org-pomodoro :when active)
        ;; (org-clock :when active)
        ;; nyan-cat
        )
      ;; right side
      '((my-slack-modeline :priority 90)
        ;; which-function
        ;; (python-pyvenv :fallback python-pyenv)
        ;; (purpose :priority 94)
        ;; (battery :when active)
        (selection-info :priority 100)
        input-method
        ((buffer-encoding-abbrev
          point-position
          line-column)
         :separator " | "
         :priority 50
         :when active)
        (global :when active)
        (buffer-position
         :priority 50
         :when active)
        (hud
         :priority 60
         :when active))))
  :config
  ;; (spaceline-define-segment pomodoro
  ;;   "pomodoro.el"
  ;;   (when (and (bound-and-true-p pomodoro:mode-line)
  ;;              (< 0 (length pomodoro:mode-line)))
  ;;     (pomodoro:propertize-mode-line)))
  ;; (spaceline-define-segment rbenv
  ;;   "ruby version used in rbenv"
  ;;   (when (bound-and-true-p global-rbenv-mode)
  ;;     (rbenv--update-mode-line)))
  ;; (spaceline-define-segment pdf
  ;;   "pdf tool infomation"
  ;;   (when (eql major-mode 'pdf-view-mode)
  ;;     (format "Page: %s" (eval '(pdf-view-current-page)))))
  )


(provide '35-powerline)
;;; 35-powerline.el ends here
