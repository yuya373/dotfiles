;;; 03-util.el --- util                              -*- lexical-binding: t; -*-

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
  (require 'evil)
  (el-get-bundle syohex/emacs-browser-refresh))

(el-get-bundle which-key)
(use-package which-key
  :diminish which-key-mode
  :commands (which-key-mode)
  :init
  (setq which-key-use-C-h-for-paging nil)
  (setq which-key-idle-delay 0.3)
  (setq which-key-separator " - ")
  (setq which-key-show-prefix 'echo)
  (setq which-key-popup-type 'side-window)
  (setq which-key-side-window-location 'bottom)
  (setq which-key-side-window-max-height 0.50)
  (add-hook 'after-init-hook 'which-key-mode)
  :config
  ;; (which-key-add-key-based-replacements "SPC r" " Rest")
  (which-key-add-key-based-replacements "SPC a" " Ag")
  (which-key-add-key-based-replacements "SPC d" " Dash")
  (which-key-add-key-based-replacements "SPC f" " Find-File")
  (which-key-add-key-based-replacements "SPC h" " Helm")
  (which-key-add-key-based-replacements "SPC p" " Projectile")
  (which-key-add-key-based-replacements "SPC u" " Undo-Tree")
  (which-key-add-key-based-replacements "SPC b" " Buffers")
  (which-key-add-key-based-replacements "SPC e" " Errors")
  (which-key-add-key-based-replacements "SPC i" " Indent-Guides")
  (which-key-add-key-based-replacements "SPC t" " Tags, Transrate")
  (which-key-add-key-based-replacements "SPC w" " Windows")
  (which-key-add-key-based-replacements "SPC g" " Git")
  (which-key-add-key-based-replacements "SPC h g" " Helm-Github")
  (which-key-add-key-based-replacements ", h" " Help")
  (which-key-add-key-based-replacements "SPC m" " Memo, Message")
  (which-key-add-key-based-replacements "SPC m u" " slack-update")

  (which-key-add-major-mode-key-based-replacements 'emacs-lisp-mode
    ", e" " Eval")
  (which-key-add-major-mode-key-based-replacements 'enh-ruby-mode
    ", b" " Bundler"
    ", r" " Rails"
    ", g" " Goto"
    ", t" " Test, Tags"))

(el-get-bundle indent-guide)
(use-package indent-guide
  :diminish indent-guide-mode
  :commands (indent-guide-mode)
  :init
  (setq indent-guide-recursive t)
  (setq indent-guide-delay 1)
  (add-hook 'lisp-mode-hook 'indent-guide-mode))

(el-get-bundle restclient)
(use-package restclient
  :mode (("\\.restclient\\'" . restclient-mode))
  :init
  (setq restclient-dir "~/Dropbox/junk/")
  (defun restclient-client-buf-name ()
    (concat (format-time-string "%Y-%m-%d") ".restclient"))
  (defun create-restclient-buffer ()
    (interactive)
    (find-file-other-window
     (concat restclient-dir (restclient-client-buf-name))))
  :config
  (evil-define-key 'normal restclient-mode-map
    ",y"  'restclient-copy-curl-command
    ",ss" 'restclient-http-send-current
    ",sr" 'restclient-http-send-current-raw
    ",sv" 'restclient-http-send-current-stay-in-window
    ",n"  'restclient-jump-next
    ",p"  'restclient-jump-prev
    ",m"  'restclient-mark-current))

;; esup
(el-get-bundle esup)
(use-package esup
  :commands (esup))

;; auto-save
(el-get-bundle auto-save-buffers-enhanced)
(use-package auto-save-buffers-enhanced
  :init
  (setq make-backup-files nil)
  (setq auto-save-list-file-prefix nil)
  (setq create-lockfiles nil)
  (setq auto-save-buffers-enhanced-interval 0.5)
  (setq auto-save-buffers-enhanced-quiet-save-p t)
  (setq auto-save-buffers-enhanced-exclude-regexps
        '("^/scp:" "^/ssh:" "/sudo:" "/multi:"))
  :config
  (defun auto-save-buffers-enhanced-save-buffers-if-normal-state ()
    (if (eq evil-state 'normal)
        (auto-save-buffers-enhanced-save-buffers)))
  (defun auto-save-buffers-enhanced (flag)
    (when flag
      (run-with-idle-timer
       auto-save-buffers-enhanced-interval t
       'auto-save-buffers-enhanced-save-buffers-if-normal-state)))
  (auto-save-buffers-enhanced t))

(use-package server
  :commands (server-start server-running-p)
  :init
  (defun start-server ()
    (unless (server-running-p)
      (server-start)))
  (add-hook 'after-init-hook 'start-server))

(el-get-bundle emojify)
(use-package emojify
  :commands (emojify-mode global-emojify-mode)
  :init
  ;; (add-hook 'markdown-mode-hook 'emojify-mode)
  ;; (add-hook 'git-commit-mode-hook 'emojify-mode)
  ;; (add-hook 'magit-mode-hook 'emojify-mode)
  )

;; (el-get-bundle syl20bnr/emacs-emoji-cheat-sheet-plus
;;   :name emoji-cheat-sheet-plus)
;; (use-package emoji-cheat-sheet-plus
;;   :commands (emoji-cheat-sheet-plus-display-mode
;;              emoji-cheat-sheet-plus-insert)
;;   :init
;;   ;; (add-hook 'after-init-hook 'emoji-cheat-sheet-plus-display-mode)
;;   )

(el-get-bundle ag)
(el-get-bundle wgrep-ag)

(use-package wgrep-ag
  :commands (wgrep-ag-setup)
  :config
  (evil-define-key 'normal wgrep-mode-map
    ",k" 'wgrep-exit
    ",s" 'wgrep-finish-edit))

(use-package ag
  :commands (ag)
  :init
  (add-hook 'ag-mode-hook 'wgrep-ag-setup)
  (setq ag-highlight-search t
        ag-reuse-window nil
        ag-reuse-buffers nil)
  :config
  (evil-set-initial-state 'ag-mode 'normal)
  (evil-define-key 'normal ag-mode-map
    "k" 'evil-previous-visual-line
    ",e" 'wgrep-change-to-wgrep-mode))

(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "scp")
  ;; (add-to-list 'tramp-default-proxies-alist '(nil "\\`root\\'" "/ssh:%h:"))
  ;; (add-to-list 'tramp-default-proxies-alist '("localhost\\'" nil, nil))
  ;; (add-to-list 'tramp-default-proxies-alist
  ;;              '((regexp-quote (system-name)) nil nil))
  ;; (add-to-list 'tramp-default-proxies-alist '("redash" "\\`root\\'" "/ssh:redash:"))
  )

(use-package subword-mode
  :commands (subword-mode)
  :init
  (add-hook 'scala-mode-hook 'subword-mode))

(use-package dired
  :init
  (setq dired-use-ls-dired nil)
  (setq dired-dwim-target t)
  (setq dired-recursive-copies 'always)
  :config
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil)
  (with-eval-after-load "evil"
    (evil-define-key 'normal dired-mode-map
      "t" nil
      "m" 'dired-mark
      "M" 'dired-unmark
      ",m" 'dired-unmark-all-marks
      "g" nil
      ",g" 'revert-buffer
      "$" 'evil-end-of-line
      "0" 'evil-digit-argument-or-evil-beginning-of-line
      "w" nil
      ",w" 'dired-show-file-type
      ",y" 'dired-copy-filename-as-kill
      ",k" 'dired-k
      "v" nil
      ",v" 'dired-view-file
      (kbd "C-p") 'dired-up-directory
      (kbd "C-n") 'dired-find-file
      ",r" 'dired-do-rename
      ",R" 'wdired-change-to-wdired-mode
      "n" 'evil-ex-search-next
      "N" 'evil-ex-search-previous)))

(el-get-bundle dired-k)
(use-package dired-k
  :commands (dired-k dired-k-no-revert)
  :init
  (add-hook 'dired-after-readin-hook 'dired-k-no-revert)
  (setq dired-k-style 'git)
  (setq dired-k-human-readable t))

;; (el-get-bundle emacschrome)
;; (use-package edit-server
;;   :commands (edit-server-start)
;;   :init
;;   (add-hook 'evil-mode-hook 'edit-server-start)
;;   (setq edit-server-new-frame nil)
;;   :config
;;   (evil-define-key 'normal edit-server-text-mode-map
;;     ",k" 'edit-server-abort
;;     ",c" 'edit-server-done))

(el-get-bundle auto-mark)
(use-package auto-mark
  :commands (auto-mark-mode)
  :init
  (add-hook 'after-init-hook 'auto-mark-mode)

  ;; A list of (COMMAND . CLASS) for classfying command to CLASS.

  ;; COMMAND is a symbol you want to try to classify.
  ;; CLASS is a symbol for detecting a border where auro-mark should push mark.

  ;; There is pre-defined CLASS:
  ;; edit      edit command
  ;; move      point move command
  ;; ignore    make auto-mark ignore pushing mark
  (setq auto-mark-command-class-alist '((goto-line . jump)
                                        (avy-goto-char . jump)
                                        (avy-goto-char-2 . jump)
                                        (avy-goto-line . jump)
                                        (avy-goto-word-0 . jump)
                                        (avy-migemo-goto-char . jump)
                                        (avy-migemo-goto-word-1 . jump)
                                        (avy-migemo-goto-char-in-line . jump)
                                        (isearch-exit . jump)
                                        (evil-search-next . jump)
                                        (evil-search-previous . jump)
                                        (evil-scroll-down . move)
                                        (evil-scroll-up . move))))

;; (el-get-bundle prodigy)
;; (use-package prodigy
;;   :commands (prodigy)
;;   :config
;;   (evil-define-key 'normal prodigy-mode-map
;;     "s" 'prodigy-start
;;     "S" 'prodigy-stop
;;     "r" 'prodigy-restart
;;     "v" 'prodigy-display-process
;;     "o" 'prodigy-browse)
;;   (prodigy-define-tag
;;    :name 'rails
;;    :on-output (lambda (&rest args)
;;                 (let ((output (plist-get args :output))
;;                       (service (plist-get args :service)))
;;                   (when (or (s-matches? "Listening on 0\.0\.0\.0:[0-9]+, CTRL\\+C to stop" output)
;;                             (s-matches? "Ctrl-C to shutdown server" output))
;;                     (prodigy-set-status service 'ready)))))

;;   (prodigy-define-service
;;    :name "IB server"
;;    :command "bundle"
;;    :args '("exec" "rails" "server" "--port=3000")
;;    :cwd "/Users/yuyaminami/dev/instabase"
;;    :url "http://localhost:3000"
;;    :tags '(rails))
;;   (prodigy-define-service
;;    :name "IB migrateion"
;;    :command "bundle"
;;    :args '("exec" "rake" "db:migrate")
;;    :cwd "/Users/yuyaminami/dev/instabase"
;;    :tags '(rails))
;;   (prodigy-define-service
;;    :name "IB rollback"
;;    :command "bundle"
;;    :args '("exec" "rake" "db:rollback")
;;    :cwd "/Users/yuyaminami/dev/instabase"
;;    :tags '(rails))
;;   )

;; (el-get-bundle pomodoro)
;; (use-package pomodoro
;;   :commands (pomodoro:start)
;;   :init

;;   (setq pomodoro:set-mode-line-p t
;;         pomodoro:mode-line-work-sign "働 "
;;         pomodoro:mode-line-rest-sign "休 "
;;         pomodoro:mode-line-long-rest-sign "長休 "
;;         pomodoro:work-time 25
;;         pomodoro:rest-time 5
;;         pomodoro:long-rest-time 25
;;         pomodoro:iteration-for-long-rest 3
;;         pomodoro:mode-line-time-display t
;;         pomodoro:file nil
;;         pomodoro:myfile (lambda ()
;;                           (format-time-string "~/Dropbox/junk/%Y-%m-%d.org")))

;;   (defun pomodoro:find-rest-buffer ()
;;     (when (functionp pomodoro:myfile)
;;       (find-file (funcall pomodoro:myfile))))
;;   (add-hook 'pomodoro:finish-work-hook #'pomodoro:find-rest-buffer)
;;   (add-hook 'pomodoro:long-rest-hook #'pomodoro:find-rest-buffer)

;;   (defun my-pomodoro-notify (msg)
;;     (alert msg
;;            :title "Pomodoro"
;;            :category 'pomodoro))
;;   (add-hook 'pomodoro:finish-work-hook
;;             #'(lambda () (my-pomodoro-notify "Work is Finish")))
;;   (add-hook 'pomodoro:finish-rest-hook
;;             #'(lambda () (my-pomodoro-notify "Break time is Finish")))
;;   (add-hook 'pomodoro:long-rest-hook
;;             #'(lambda () (my-pomodoro-notify "Long Break time now"))))


;; (el-get-bundle google-this)
;; (use-package google-this
;;   :commands (google-this google-this-search google-this-region
;;                          google-maps google-this-translate-query-or-region))

(el-get-bundle syohex/emacs-browser-refresh)
(use-package browser-refresh
  :commands (browser-refresh)
  :init
  (setq browser-refresh-save-buffer nil)
  (setq browser-refresh-activate nil)
  (defun browser-refresh-and-activate ()
    (interactive)
    (let ((browser-refresh-activate t))
      (browser-refresh))))

(el-get-bundle alpha22jp/atomic-chrome)
(use-package atomic-chrome
  :commands (atomic-chrome-start-server)
  :init
  (add-hook 'after-init-hook 'atomic-chrome-start-server))

(el-get-bundle es-mode)
(use-package es-mode
  :mode (("\\.es\\'" . es-mode)))

(provide '03-util)
;;; 03-util.el ends here
