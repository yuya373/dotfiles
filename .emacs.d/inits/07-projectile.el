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

(eval-when-compile
  (el-get-bundle projectile)
  (el-get-bundle projectile-rails)
  (require 'evil)
  (require 'projectile)
  (require 'projectile-rails)
  (defun define-rails-find-file-in (dir)
    (let* ((normalized-dir (subst-char-in-string ?/ ?- (substring dir 0 -1)))
           (fname (intern (concat "find-file-in-" normalized-dir))))
      `(defun ,fname ()
         (interactive)
         (let* ((rails-root (projectile-rails-root))
                (target-dir (concat rails-root ,dir)))
           (message target-dir)
           (helm-find-files-1 target-dir)))))
  (defmacro rails-find-file-in (&rest dirs)
    `(progn
       ,@(mapcar #'define-rails-find-file-in dirs)))
  (defmacro rails-find-file-current (dir re fallback)
    `(let* ((singular (projectile-rails-current-resource-name))
            (plural (pluralize-string singular))
            (plural|singular (format "%s\\|%s" plural singular))
            (abs-current-file (buffer-file-name (current-buffer)))
            (current-file (if abs-current-file
                              (file-relative-name
                               abs-current-file
                               (projectile-project-root))))
            (choices (projectile-rails-choices
                      (list (list ,dir (s-lex-format ,re)))))
            (files (projectile-rails-hash-keys choices))
            (target-dir (concat (projectile-rails-root)
                                (f-dirname (gethash
                                            (-first-item files)
                                            choices)))))
       (if (eq files ())
           (funcall ,fallback)
         (helm-find-files-1 target-dir)))))

(el-get-bundle projectile)
(el-get-bundle projectile-rails)
(el-get-bundle helm-projectile)
(use-package helm-projectile
  :commands (helm-projectile-on))
(use-package projectile
  :commands (projectile-mode)
  :diminish projectile-mode
  :init
  (setq projectile-enable-caching t
        projectile-completion-system 'helm)
  (add-hook 'evil-mode-hook 'projectile-mode)
  (add-hook 'projectile-mode-hook 'helm-projectile-on)
  )

(use-package projectile-rails
  :commands (projectile-rails-global-mode)
  :init
  (add-hook 'projectile-mode-hook #'projectile-rails-global-mode)
  (defun set-projectile-rails-tags-command ()
    (interactive)
    (when (projectile-rails-root)
      (setq projectile-tags-command (concat "ctags -Re -f TAGS --languages=+Ruby --languages=-JavaScript " (projectile-rails-root)))))
  (add-hook 'projectile-rails-mode-hook 'set-projectile-rails-tags-command)

  (defun find-file-current-model ()
    (interactive)
    (rails-find-file-current "app/models/"
                             "/${singular}\\.rb$"
                             'projectile-rails-find-model))

  (defun find-file-current-controller ()
    (interactive)
    (rails-find-file-current "app/controllers/"
                             "app/controllers/\\(.*${plural}\\)_controller\\.rb$"
                             'projectile-rails-find-controller))

  (defun find-file-current-view ()
    (interactive)
    (rails-find-file-current "app/views/"
                             "/\\(${plural|singular}\\)/\\(.+\\)$"
                             'projectile-rails-find-view))
  :config
  (evil-define-key 'normal projectile-rails-mode-map ",ris" 'projectile-rails-server)
  (evil-define-key 'normal projectile-rails-mode-map ",rir" 'projectile-rails-rake)
  (evil-define-key 'normal projectile-rails-mode-map ",rig" 'projectile-rails-generate)
  (evil-define-key 'normal projectile-rails-mode-map ",rer" 'projectile-rails-extract-region)
  (evil-define-key 'normal projectile-rails-mode-map ",gf" 'projectile-rails-goto-file-at-point)
  (evil-define-key 'normal projectile-rails-mode-map ",gm" 'projectile-rails-goto-gemfile)
  (evil-define-key 'normal projectile-rails-mode-map ",gr" 'projectile-rails-goto-routes)

  (rails-find-file-in "spec/"
                      "spec/controllers/"
                      "spec/factories/"
                      "spec/features/"
                      "spec/jobs/"
                      "spec/lib/"
                      "spec/mailers/"
                      "spec/models/"
                      "spec/requests/"
                      "spec/routing/"
                      "spec/services/")

  (evil-define-key 'normal projectile-rails-mode-map ",rtt" 'find-file-in-spec)
  (evil-define-key 'normal projectile-rails-mode-map ",rtc" 'find-file-in-spec-controllers)
  (evil-define-key 'normal projectile-rails-mode-map ",rtf" 'find-file-in-spec-factories)
  (evil-define-key 'normal projectile-rails-mode-map ",rtj" 'find-file-in-spec-jobs)
  (evil-define-key 'normal projectile-rails-mode-map ",rtl" 'find-file-in-spec-lib)
  (evil-define-key 'normal projectile-rails-mode-map ",rtm" 'find-file-in-spec-models)
  (evil-define-key 'normal projectile-rails-mode-map ",rtr" 'find-file-in-spec-requests)
  (evil-define-key 'normal projectile-rails-mode-map ",rts" 'find-file-in-spec-services)

  (rails-find-file-in "config/"
                      "config/initializers/"
                      "config/environments/"
                      "config/locales/"
                      "config/settings/"
                      "db/migrate/"
                      "db/ridgepole/"
                      "lib/")

  (evil-define-key 'normal projectile-rails-mode-map ",rCC" 'find-file-in-config)
  (evil-define-key 'normal projectile-rails-mode-map ",rCi" 'find-file-in-config-initializers)
  (evil-define-key 'normal projectile-rails-mode-map ",rCe" 'find-file-in-config-environments)
  (evil-define-key 'normal projectile-rails-mode-map ",rCl" 'find-file-in-config-locales)
  (evil-define-key 'normal projectile-rails-mode-map ",rCs" 'find-file-in-config-settings)
  (evil-define-key 'normal projectile-rails-mode-map ",rdm" 'find-file-in-db-migrate)
  (evil-define-key 'normal projectile-rails-mode-map ",rdr" 'find-file-in-db-ridgepole)
  (evil-define-key 'normal projectile-rails-mode-map ",rfl" 'find-file-in-lib)

  (rails-find-file-in "app/"
                      "app/controllers/"
                      "app/helpers/"
                      "app/jobs/"
                      "app/mailers/"
                      "app/models/"
                      "app/services/"
                      "app/validators/"
                      "app/views/")

  (evil-define-key 'normal projectile-rails-mode-map ",rfa" 'find-file-in-app)
  (evil-define-key 'normal projectile-rails-mode-map ",rfc" 'find-file-in-app-controllers)
  (evil-define-key 'normal projectile-rails-mode-map ",rfh" 'find-file-in-app-helpers)
  (evil-define-key 'normal projectile-rails-mode-map ",rfj" 'find-file-in-app-jobs)
  (evil-define-key 'normal projectile-rails-mode-map ",rfm" 'find-file-in-app-models)
  (evil-define-key 'normal projectile-rails-mode-map ",rfs" 'find-file-in-app-services)
  (evil-define-key 'normal projectile-rails-mode-map ",rfv" 'find-file-in-app-views)
  ;; (evil-define-key 'normal projectile-rails-mode-map ",rcm" 'find-file-current-model)
  ;; (evil-define-key 'normal projectile-rails-mode-map ",rcc" 'find-file-current-controller)
  ;; (evil-define-key 'normal projectile-rails-mode-map ",rcv" 'find-file-current-view)
  )

(provide '07-projectile)
;;; 07-projectile.el ends here
