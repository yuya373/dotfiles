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

(use-package spaceline :ensure t
  :init
  (setq anzu-cons-mode-line-p nil)
  (setq powerline-height 25)
  (setq powerline-default-separator 'contour)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  :config
  (defvar slack-modeline "")
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
  )
(use-package spaceline-config
  :commands (spaceline-compile))

(defun setup-spaceline ()
  (spaceline-compile
    '((macrodef
       :priority 80
       :face other-face)
      (evil-state
       :priority 90
       :face highlight-face
       :when active)
      (perspeen-name :priority 80)
      ((buffer-modified buffer-id remote-host) :priority 100)
      (major-mode :priority 90)
      (process :when active :priority 90)
      ((flycheck-error flycheck-warning flycheck-info)
       :when active
       :priority 100)
      (minor-modes :when active :priority 70))
    ;; right side
    '((my-slack-modeline :priority 90)
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
       :when active)))
  (setq-default mode-line-format '("%e" (:eval (spaceline-ml-main))))
  (spaceline-info-mode))

(setup-spaceline)

(provide '35-powerline)
;;; 35-powerline.el ends here
