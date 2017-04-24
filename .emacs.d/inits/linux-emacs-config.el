;;; linux-emacs-config.el ---                        -*- lexical-binding: t; -*-

;; Copyright (C) 2017

;; Author:  <yuya373@yuya373>
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
(let ((font-size 15))
  (create-fontset-from-ascii-font
   (format "Ricty-%d:weight=normal:slant=normal" font-size) nil "ricty")
  (set-fontset-font "fontset-ricty" 'unicode
                    (font-spec :family "Ricty" :size font-size) nil 'append)
  (add-to-list 'default-frame-alist '(font . "fontset-ricty")))

(setq ring-bell-function 'ignore)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(el-get-bundle company-quickhelp)
(use-package company-quickhelp
  :commands (company-quickhelp-mode)
  :init
  (add-hook 'company-mode-hook '(lambda () (company-quickhelp-mode t))))

(use-package xclip
  :commands (xclip-mode)
  :init
  (add-hook 'after-init-hook 'xclip-mode))

(el-get-bundle migemo)
(use-package migemo
  :commands (migemo-init)
  :init
  (setq migemo-options '("--quiet" "--emacs"))
  (setq migemo-command "cmigemo")
  (setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")
  (setq migemo-user-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (add-hook 'after-init-hook 'migemo-init))

(provide 'linux-emacs-config)
;;; linux-emacs-config.el ends here