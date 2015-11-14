;;; 11-memo.el ---                                   -*- lexical-binding: t; -*-

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

;; markdown
(el-get-bundle markdown-mode)
(el-get-bundle markdown-toc)
(use-package markdown-mode
  :mode (("\\.markdown\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("PULLREQ_MSG" . gfm-mode))
  :init
  (add-hook 'markdown-mode-hook '(lambda () (set (make-local-variable 'tab-width) 2))))

(el-get-bundle open-junk-file)
(use-package open-junk-file
  :commands (open-junk-file)
  :config
  (setq open-junk-file-format "~/Dropbox/junk/%Y-%m-%d."))

(el-get-bundle org)
(use-package org
  :mode (("\\.org\\'" . org-mode))
  :config
  (setq org-src-fontify-natively t)
  (setq org-directory "~/Dropbox/junk")
  (setq org-agenda-files (list org-directory)))

(provide '11-memo)
;;; 11-memo.el ends here
