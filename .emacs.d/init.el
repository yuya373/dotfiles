;;; init.el --- init.el
;;; Commentary:
;;; Code:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq default-directory "~/")
(setq command-line-default-directory "~/")
(setq gc-cons-threshold (* (* 4 256) 1024 1024)) ;; 1gb
(setq garbage-collection-messages t)
(setq read-process-output-max (* 3 (* 1024 1024))) ;; 3mb

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
(el-get-bundle org-mode)
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
      (mapc #'(lambda (p) (condition-case e
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
  (setq init-loader-show-log-after-init t)
  (setq init-loader-byte-compile nil))
(init-loader-load (expand-file-name "~/.emacs.d/platform-inits"))
(init-loader-load)
(add-hook 'window-setup-hook
          #'(lambda ()
              (set-frame-parameter nil
                                   'fullscreen 'maximized))
          t)

;; Font
;; [エディタで等幅日本語フォントを最適に表示させるには、フォントサイズを2か3か5の倍数にするといいよ！ - Qiita](https://qiita.com/suin/items/559d02ea32bd4a6ef08b)
;; [Emacs のフォント設定について - Qiita](https://qiita.com/melito/items/238bdf72237290bc6e42)
(let* ((size 15)
       (height (* 10 size))
       (spec (list :family "Ricty"
                   :height height))
       (fontspec (apply #'font-spec spec))
       (jp-fontspec (apply #'font-spec spec)))

  (apply #'set-face-attribute 'default nil spec)
  (apply #'set-face-attribute 'variable-pitch nil spec)

  (set-fontset-font nil 'japanese-jisx0208 jp-fontspec)
  (set-fontset-font nil 'japanese-jisx0208-1978 jp-fontspec)
  (set-fontset-font nil 'japanese-jisx0212 jp-fontspec)
  (set-fontset-font nil 'japanese-jisx0213-1 jp-fontspec)
  (set-fontset-font nil 'japanese-jisx0213-2 jp-fontspec)
  (set-fontset-font nil 'japanese-jisx0213.2004-1 jp-fontspec)
  (set-fontset-font nil 'jisx0201 jp-fontspec)

  (set-fontset-font nil 'japanese-jisx0213-a jp-fontspec)

  (set-fontset-font nil 'katakana-jisx0201 jp-fontspec)
  (set-fontset-font nil 'katakana-sjis jp-fontspec)

  (set-fontset-font nil 'latin-jisx0201 jp-fontspec))

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
(put 'list-timers 'disabled nil)
