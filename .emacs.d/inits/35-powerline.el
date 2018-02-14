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
  (el-get-bundle powerline)
  (el-get-bundle TheBB/spaceline)
  (require 'spaceline)
)

(el-get-bundle powerline)
(el-get-bundle TheBB/spaceline)
(use-package spaceline-config
  :commands (spaceline-define-segment spaceline-install spaceline-spacemacs-theme)
  :init
  (add-hook 'evil-mode-hook 'install-my-spaceline-theme)
  (setq anzu-cons-mode-line-p nil)
  (setq powerline-height 25)
  (setq powerline-default-separator 'contour)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (defun install-my-spaceline-theme ()
    (spaceline-install
     '(
       ;; (pomodoro
       ;;  :when active)
       (evil-state
        :face highlight-face)
       anzu
       ;; ((workspace-number window-number)
       ;;  :fallback evil-state
       ;;  :separator "|"
       ;;  :face highlight-face)
       (buffer-modified buffer-id remote-host)
       ;; (pdf :when active)
       ((flycheck-error flycheck-warning flycheck-info)
        :when active)
       major-mode
       (((minor-modes :separator spaceline-minor-modes-separator)
         process)
        )
       (erc-track :when active)
       (version-control :when active)
       (org-pomodoro :when active)
       (org-clock :when active)
       nyan-cat)

     `((battery :when active)
       selection-info
       ((buffer-encoding-abbrev
         point-position
         line-column)
        :separator " | ")
       buffer-position
       (global :when active)
       (rbenv :when active)
       hud))
    (setq-default mode-line-format '("%e" (:eval (spaceline-ml-main)))))
  :config
  ;; (spaceline-define-segment pomodoro
  ;;   "pomodoro.el"
  ;;   (when (and (bound-and-true-p pomodoro:mode-line)
  ;;              (< 0 (length pomodoro:mode-line)))
  ;;     (pomodoro:propertize-mode-line)))
  (spaceline-define-segment rbenv
    "ruby version used in rbenv"
    (when (bound-and-true-p global-rbenv-mode)
      (rbenv--update-mode-line)))
  ;; (spaceline-define-segment pdf
  ;;   "pdf tool infomation"
  ;;   (when (eql major-mode 'pdf-view-mode)
  ;;     (format "Page: %s" (eval '(pdf-view-current-page)))))
  )


(provide '35-powerline)
;;; 35-powerline.el ends here
