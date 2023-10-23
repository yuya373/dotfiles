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
(setq gc-cons-threshold (* (* 1 128) 1024 1024)) ;; 100mb
(setq gc-cons-percentage nil)
(setq garbage-collection-messages nil)
(setq read-process-output-max (* 1 (* 1024 1024))) ;; 1mb

(defvar before-gc-elapsed nil)
(defvar before-pure-bytes-used nil)
(defun notify-gc-finished ()
  (when (and before-gc-elapsed
             before-pure-bytes-used)
    (let ((current-gc-elapsed (- gc-elapsed before-gc-elapsed))
          (collected-pure-bytes (- before-pure-bytes-used pure-bytes-used)))
      (message "Garbage collection finished. ELAPSED: %s sec, COLLECTED: %s bytes"
               current-gc-elapsed
               collected-pure-bytes)))
  (setq before-gc-elapsed gc-elapsed)
  (setq before-pure-bytes-used pure-bytes-used)
  )
;; (add-hook 'post-gc-hook #'notify-gc-finished)

(setq native-comp-async-report-warnings-errors 'silent)


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

(el-get-bundle queue)
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

;; Font
;; [エディタで等幅日本語フォントを最適に表示させるには、フォントサイズを2か3か5の倍数にするといいよ！ - Qiita](https://qiita.com/suin/items/559d02ea32bd4a6ef08b)
;; [Emacs のフォント設定について - Qiita](https://qiita.com/melito/items/238bdf72237290bc6e42)
(let* ((size (if (file-exists-p "/mnt/c/Windows/System32/cmd.exe") ;; WSL
                 20
               14))
       (height (* 10 size))
       (spec (list :family "HackGen Console"
                   :height height)))

  (apply #'set-face-attribute 'default nil spec)
  (apply #'set-face-attribute 'variable-pitch nil spec))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(perspeen-tab--header-line-active ((t (:inherit mode-line :background "#eee8d5" :foreground "#657b83" :weight bold))))
 '(perspeen-tab--powerline-inactive1 ((t (:inherit mode-line)))))
(put 'list-timers 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(wgrep-ag vertico tree-sitter-langs term-run rufo queue ox-gfm orderless oauth2 nlinum marginalia lv logview log4j-mode git-commit font-lock-studio eshell-prompt-extras embark-consult electric-operator easy-hugo csv-mode coverlay consult-projectile consult-lsp consult-flycheck consult-dir company-terraform codic auto-save-buffers-enhanced all-the-icons-completion)))
