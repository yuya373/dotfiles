;;; 12-theme.el ---                                  -*- lexical-binding: t; -*-

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
  (el-get-bundle powerline)
  (el-get-bundle TheBB/spaceline)
  (require 'spaceline)
  (el-get-bundle pdf-tools)
  (require 'pdf-tools))

(el-get-bundle material-theme)
(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/material-theme")
(load-theme 'material t)

(el-get-bundle powerline)
(el-get-bundle TheBB/spaceline)
(use-package spaceline-config
  :commands (spaceline-define-segment spaceline-install spaceline-spacemacs-theme)
  :init
  (add-hook 'evil-mode-hook 'install-my-spaceline-theme)
  (setq powerline-height 25)
  (setq powerline-default-separator 'wave)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  (defun install-my-spaceline-theme ()
    (spaceline-install
     '((evil-state
        :face highlight-face)
       ;; ((workspace-number window-number)
       ;;  :fallback evil-state
       ;;  :separator "|"
       ;;  :face highlight-face)
       (buffer-modified buffer-size buffer-id remote-host)
       (pdf :when active)
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
       hud)))
  :config
  (spaceline-define-segment rbenv
    "ruby version used in rbenv"
    (rbenv--update-mode-line)
    :when (bound-and-true-p global-rbenv-mode))
  (spaceline-define-segment pdf
    "pdf tool infomation"
    (format "Page: %s" (pdf-view-current-page
                        (get-buffer-window)))
    :when (eql major-mode 'pdf-view-mode)))

(provide '12-theme)
;;; 12-theme.el ends here
