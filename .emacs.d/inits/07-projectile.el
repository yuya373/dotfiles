;;; 07-projectile.el ---                             -*- lexical-binding: t; -*-

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

(el-get-bundle projectile)
(el-get-bundle projectile-rails)


(use-package projectile
  :commands (projectile-mode)
  :diminish projectile-mode
  :init
  (setq projectile-enable-caching t)
  (add-hook 'after-init-hook 'projectile-mode))

(use-package projectile-rails
  :commands (projectile-rails-global-mode)
  :diminish projectile-rails-mode
  :init
  (add-hook 'projectile-mode-hook #'projectile-rails-global-mode)
  :config
  (defun projectile-rails-expand-snippet-maybe ()
    "Expand snippet corresponding to the current file.

This only works when yas package is installed."
    (when (and projectile-rails-expand-snippet
               (fboundp 'yas-expand-snippet)
               (s-blank? (buffer-string))
               (projectile-rails-expand-corresponding-snippet)
               (let ((inhibit-message t))
                 (indent-region (point-min) (point-max))))))
  (defun projectile-rails-classify (name)
    "Accepts a filepath, splits it by '/' character and classifieses each of the element"
    (let ((name (mapcar #'(lambda (it)
                            (mapconcat #'upcase-initials (split-string it "_") ""))
                        (split-string name "/"))))
      name))

  (defun find-file-at-project-dir (dir)
    (let* ((prompt "Find file: ")
           (directory (format "%s%s" (projectile-project-root) dir))
           (filename (read-file-name prompt directory nil)))
      (find-file filename)))

  (defun projectile-rails-find-controller ()
    (interactive)
    (find-file-at-project-dir "app/controllers/"))
  (defun projectile-rails-find-model ()
    (interactive)
    (find-file-at-project-dir "app/models/"))
  (defun projectile-rails-find-view ()
    (interactive)
    (find-file-at-project-dir "app/views/"))
  (defun projectile-rails-find-migration ()
    (interactive)
    (find-file-at-project-dir "app/migrate/"))
  (defun projectile-rails-find-helper ()
    (interactive)
    (find-file-at-project-dir "app/helpers/"))
  (evil-define-key 'normal projectile-rails-mode-map
    ",rfm" 'projectile-rails-find-model
    ",rfc" 'projectile-rails-find-controller
    ",rfv" 'projectile-rails-find-view
    ",rfM" 'projectile-rails-find-migration
    ",rfh" 'projectile-rails-find-helper
    ))

(provide '07-projectile)
;;; 07-projectile.el ends here
