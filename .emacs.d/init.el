;;; init.el --- init.el
;;; Commentary:
;;; Code:

;; self hosting el-get


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq gc-cons-threshold (* 256 1024 1024))
(setq garbage-collection-messages t)

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; use use-package for config description and lazy loading
(setq el-get-use-autoloads nil)
(setq el-get-is-lazy t)
(setq el-get-notify-type 'message)
(el-get-bundle pcre2el)

;; el-get-lock
(el-get-bundle el-get-lock
  :type github
  :pkgname "tarao/el-get-lock"
  :name el-get-lock)
(require 'el-get-lock)
(el-get-lock)

(el-get-bundle use-package)
(el-get-bundle diminish)
(require 'diminish)
(require 'use-package)
;; for debug
;; (setq el-get-verbose t)
;; (setq use-package-verbose t)

;; initchart
(el-get-bundle yuttie/initchart)
(use-package initchart
  :commands (initchart-record-execution-time-of))
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

(defun update-packages ()
  (interactive)
  (let ((packages (collect-packages)))
    (message "Updating Packages: %s" packages)
    (dolist (package packages)
      (ignore-errors (el-get-update package)))))

(defun collect-packages ()
  (interactive)
  (let ((packages))
    (with-current-buffer (current-buffer)
      (let ((regex "\(el-get-bundle \\(.*\\)\)"))
        (goto-char (point-min))
        (while (re-search-forward regex nil t)
          (let ((name (split-string (match-string 1) "/")))
            (if (< 1 (length name))
                (push (cadr name) packages)
              (push (car name) packages))))))
    (cl-remove-duplicates packages :test #'string=)))

(defun el-get-update-all (&optional no-prompt)
  "Performs update of all installed packages."
  (interactive)
  (when (or no-prompt
            (yes-or-no-p
             "Doo you really want to update all installed packages? "))
    (let ((el-get-elpa-do-refresh 'once)
          errors)
      (mapc '(lambda (p) (condition-case e
                             (el-get-update p)
                           (error (push e errors))))
            (el-get-list-package-names-with-status "installed"))
      (message "Package Updated.")
      (message "Errors: %s" errors))))

;; init-loader
(el-get-bundle init-loader)
(use-package init-loader
  :commands (init-loader-load)
  :init
  (setq init-loader-show-log-after-init 'error-only)
  (setq init-loader-byte-compile t))
(init-loader-load)
(add-hook 'window-setup-hook
          #'(lambda ()
              (set-frame-parameter nil
                                   'fullscreen 'maximized))
          t)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-lead-face ((t (:inherit isearch :foreground "gray100"))))
 '(avy-lead-face-0 ((t (:background "#6c71c4" :foreground "gray100"))))
 '(avy-lead-face-1 ((t (:background "#cb4b16" :foreground "gray100"))))
 '(avy-lead-face-2 ((t (:background "#2aa198" :foreground "gray100"))))
 '(perspeen-tab--header-line-active ((t (:inherit mode-line :background "#eee8d5" :foreground "#657b83" :weight bold))))
 '(perspeen-tab--powerline-inactive1 ((t (:inherit mode-line)))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (persp-mode nlinum wgrep-ag term-run org oauth2 log4j-mode inflections imenus git-link evil-magit eshell-prompt-extras electric-operator csv-mode avy-migemo auto-save-buffers-enhanced))))
