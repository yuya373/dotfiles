;;; 13-flycheck.el ---                               -*- lexical-binding: t; -*-

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
  (require 'el-get)
  (require 'use-package))

(el-get-bundle flycheck)
(el-get-bundle flycheck/flycheck-inline)
(el-get-bundle alexmurray/evil-flycheck)
(el-get-bundle package-lint)
(el-get-bundle flycheck-package)
(el-get-bundle pkg-info)

(use-package pkg-info
  :after (flycheck))

;; (use-package evil-flycheck
;;   :after (flycheck))


;; Better to use https://github.com/tomoya/auto-fix.el
(defun flycheck-eslint-fix ()
  (interactive)
  (when (and flycheck-javascript-eslint-executable
             (file-executable-p flycheck-javascript-eslint-executable))
    (let* (
           ;; (async-shell-command-display-buffer nil)
           (buf (current-buffer))
           (file-name (buffer-file-name buf))
           (eslint flycheck-javascript-eslint-executable)
           (out-buf (get-buffer-create "*flycheck-eslint-fix-out*"))
           (err-buf (get-buffer-create "*flycheck-eslint-fix-error*"))
           (process (start-file-process "flycheck-eslint-fix"
                                        "*flycheck-eslint-process*"
                                        eslint
                                        "--fix"
                                        file-name)))
      (with-current-buffer out-buf
        (setq buffer-read-only nil)
        (delete-region (point-min) (point-max)))
      (set-process-sentinel process
                            #'(lambda (process event)
                                (when (string= "finished\n" event)
                                  (with-current-buffer buf
                                    (revert-buffer nil t t))))))))

;; Better to use https://github.com/codesuki/add-node-modules-path
(defun my/use-eslint-from-node-modules ()
  (interactive)
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (files (and root
                     (list (expand-file-name "node_modules/.bin/eslint"
                                             root)
                           (expand-file-name "node_modules/.bin/eslint"
                                             (mapconcat #'identity
                                                        (butlast (split-string root "/") 2)
                                                        "/")))))

         (eslint (cl-find-if #'(lambda (file) (file-executable-p file))
                             files)))
    ;; (when root
    ;;   (make-local-variable 'flycheck-eslint-rules-directories)
    ;;   (add-to-list 'flycheck-eslint-rules-directories (expand-file-name root)))
    (when eslint
      (setq-local flycheck-javascript-eslint-executable eslint))))

(use-package flycheck
  :diminish flycheck-mode
  :commands (flycheck-mode)
  :init
  (setq-default flycheck-disabled-checkers '(chef-foodcritic
                                             javascript-jshint
                                             javascript-jscs))
  (setq flycheck-emacs-lisp-load-path 'inherit)
  (add-hook 'prog-mode-hook 'flycheck-mode)
  (add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
  (setq flycheck-scalastylerc "~/dotfiles/scalastyle_config.xml")
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled))
  (defun evil-flycheck-may-check-automatically (org-func &rest args)
    ;; (message "%s or %s: %s"
    ;;          (not evil-mode)
    ;;          (eq 'normal evil-state)
    ;;          (or (not evil-mode)
    ;;              (eq 'normal evil-state)))
    (and (or (not evil-mode)
             (eq 'normal evil-state))
         (apply org-func args)))
  (advice-add 'flycheck-may-check-automatically :around 'evil-flycheck-may-check-automatically)
  :config
  (defun flycheck-eslint-config-exists-p ()
    "Whether there is a valid eslint config for the current buffer."
    (let* ((executable (flycheck-find-checker-executable 'javascript-eslint))
           (exitcode (and executable (call-process executable nil nil nil
                                                   "--print-config" (buffer-file-name)))))
      (eq exitcode 0)))
  (flycheck-add-mode 'javascript-eslint 'typescript-mode))

(use-package flycheck-inline
  :commands (flycheck-inline-mode)
  :init
  (add-hook 'flycheck-mode-hook #'flycheck-inline-mode)
  :config
  (defun evil-flycheck-inline-display-phantom (msg &optional pos)
    (when (or (not (boundp 'evil-state))
              (not (eq evil-state 'insert)))
      (flycheck-inline-display-phantom msg pos)))
  (setq flycheck-inline-display-function
        #'evil-flycheck-inline-display-phantom)

  (defun flycheck-inline-clear-all-phantoms ()
    (let* ((all (overlay-lists))
           (before-overlays (car all))
           (after-overlays (cdr all)))
      (cl-loop for overlays in (list before-overlays
                                     after-overlays)
               do (cl-loop for ov in overlays
                           do (when (overlay-get ov 'phantom)
                                (delete-overlay ov)))))

    (setq flycheck-inline--phantoms nil))

  (setq flycheck-inline-clear-function
        #'flycheck-inline-clear-all-phantoms)
  )


(use-package flycheck-package
  :commands (flycheck-package-setup)
  :init
  (add-hook 'flycheck-mode-hook 'flycheck-package-setup))

;; (use-package flycheck-tip
;;   :commands (flycheck-tip-display-current-line-error-message)
;;   :init
;;   (setq flycheck-tip-avoid-show-func nil)
;;   (setq flycheck-display-errors-function #'flycheck-tip-display-current-line-error-message))

(provide '13-flycheck)
;;; 13-flycheck.el ends here
