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
(el-get-bundle helm-projectile)

(use-package helm-projectile
  :commands (helm-projectile-on)
  :init
  (add-hook 'projectile-mode-hook 'helm-projectile-on))

(use-package projectile
  :commands (projectile-mode)
  :diminish projectile-mode
  :init
  (setq projectile-enable-caching t
        projectile-completion-system 'helm)
  (add-hook 'after-init-hook 'projectile-mode))

(use-package projectile-rails
  :commands (projectile-rails-global-mode)
  :init
  (add-hook 'projectile-mode-hook #'projectile-rails-global-mode)
  :config
  (defun projectile-rails-find-controller ()
    (interactive)
    (helm-find-files-1 (format "%sapp/controllers/"
                               (projectile-rails-root))))
  (defun projectile-rails-find-model ()
    (interactive)
    (helm-find-files-1 (format "%sapp/models/"
                               (projectile-rails-root))))
  (defun projectile-rails-find-view ()
    (interactive)
    (helm-find-files-1 (format "%sapp/views/"
                               (projectile-rails-root))))
  (defun projectile-rails-find-migration ()
    (interactive)
    (helm-find-files-1 (format "%sdb/migrate/"
                               (projectile-rails-root))))
  (evil-define-key 'normal projectile-rails-mode-map
    ",rfm" 'projectile-rails-find-model
    ",rfc" 'projectile-rails-find-controller
    ",rfv" 'projectile-rails-find-view
    ",rfM" 'projectile-rails-find-migration
    ))

(provide '07-projectile)
;;; 07-projectile.el ends here
