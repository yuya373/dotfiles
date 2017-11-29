;;; 42-csharp.el ---                                 -*- lexical-binding: t; -*-

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
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(el-get-bundle csharp-mode)

(use-package csharp-mode
  :init
  (defun my-csharp-mode-hook ()
    (setq indent-tabs-mode nil)
    (setq c-syntactic-indentation t)
    (c-set-style "ellemtel")
    (setq c-basic-offset 4)
    (setq truncate-lines t)
    (setq tab-width 4)
    (setq evil-shift-width 4)
    (setq-local helm-dash-docsets '("NET Framework" "Unity 3D"))
    (omnisharp-mode))
  (add-hook 'csharp-mode-hook
            'my-csharp-mode-hook))

(el-get-bundle omnisharp-mode)
(el-get-bundle shut-up)

(use-package omnisharp
  :commands (omnisharp-mode)
  :init
  (setq omnisharp-server-executable-path nil)
  (setq omnisharp-debug t)
  :config
  (add-to-list 'company-backends 'company-omnisharp))



(provide '42-csharp)
;;; 42-csharp.el ends here
