;;; 24-toy.el ---                                    -*- lexical-binding: t; -*-

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

(el-get-bundle easy-hugo)
(use-package easy-hugo
  :commands (easy-hugo easy-hugo-newpost easy-hugo-github-deploy)
  :init
  (setq easy-hugo-postdir "content/posts")
  (setq easy-hugo-basedir "~/dev/blog/")
  (defun easy-hugo-list-posts ()
    (interactive)
    (helm-find-files-1 (expand-file-name
                        (format "%s%s/"
                                easy-hugo-basedir
                                easy-hugo-postdir))))
  (defun easy-hugo-newpost-today  ()
    (interactive)
    (let ((format "%Y_%m_%d-%H_%M"))
      (easy-hugo-newpost
       (format "%s.md"
               (format-time-string format)))))
  (evil-define-key 'normal easy-hugo-mode-map
    (kbd "C-p") 'easy-hugo-previous-line
    (kbd "C-n") 'easy-hugo-next-line
    (kbd "RET") 'easy-hugo-open
    "a" 'easy-hugo-ag
    "e" 'easy-hugo-open
    "q" 'easy-hugo-quit
    "p" 'easy-hugo-preview
    "d" 'easy-hugo-github-deploy
    "f" 'easy-hugo-list-posts
    ))


(provide '24-toy)
;;; 24-toy.el ends here
