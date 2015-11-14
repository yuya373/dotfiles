;;; init.el --- init.el
;;; Commentary:
;;; Code:

;; self hosting el-get
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

;; init-loader
(el-get-bundle init-loader)
(use-package init-loader
  :commands (init-loader-load)
  :init
  (setq init-loader-byte-compile t))
(init-loader-load)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("97f9438943105a17eeca9f1a1c4c946765e364957749e83047d6ee337b5c0a73" "790e74b900c074ac8f64fa0b610ad05bcfece9be44e8f5340d2d94c1e47538de" "90d329edc17c6f4e43dbc67709067ccd6c0a3caa355f305de2041755986548f2" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" default)))
 '(git-gutter:added-sign "++")
 '(git-gutter:deleted-sign "--")
 '(git-gutter:modified-sign "**"))
