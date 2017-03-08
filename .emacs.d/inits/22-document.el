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

(el-get-bundle org)
(use-package org
  :mode (("\\.org\\'" . org-mode))
  :config
  (setq org-src-fontify-natively t)
  (setq org-directory "~/Dropbox/junk")
  (setq org-agenda-files (list org-directory))
  (use-package evil-org
    :init
    (setq org-src-fontify-natively t)
    :config
    (use-package org-bullets
      :init
      (add-hook 'org-mode-hook 'org-bullets-mode))
    (evil-define-key 'visual evil-org-mode-map
      ",m" 'org-md-convert-region-to-md)
    (evil-define-key 'normal evil-org-mode-map
      ;; ",tc" 'org-toggle-checkbox
      "t" nil
      ",m" 'org-md-export-to-markdown
      ",t" 'org-todo)))

(provide '22-document)
;;; 22-document.el ends here
