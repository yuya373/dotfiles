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
  (require 'evil))

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

;; (el-get-bundle popwin)
;; (use-package popwin
;;   :commands (popwin-mode)
;;   :init
;;   (setq popwin:adjust-other-windows t)
;;   (setq popwin:popup-window-position 'bottom)
;;   (setq popwin:popup-window-height 0.3)
;;   (add-hook 'after-init-hook #'(lambda () (popwin-mode t)))
;;   :config
;;   (push '(prodigy-mode :stick t) popwin:special-display-config)
;;   (push '(sql-interactive-mode :stick t :noselect t :tail t)
;;         popwin:special-display-config)
;;   (push '(ag-mode :stick t) popwin:special-display-config)
;;   (push '("*projectile-rails-compilation*" :noselect t :tail t :stick t) popwin:special-display-config)
;;   (push '("*projectile-rails-generate*" :noselect t :tail t :stick t) popwin:special-display-config)
;;   (push '("^\\*git-gutter:.*\\*$") popwin:special-display-config)
;;   (push '(twittering-mode :stick t) popwin:special-display-config)
;;   (push '(ess-help-mode) popwin:special-display-config)
;;   (push '("*R*" :tail t :noselect t :stick t) popwin:special-display-config)
;;   (push '(comint-mode :tail t :noselect t :stick t) popwin:special-display-config)
;;   (push '(ensime-inspector-mode) popwin:special-display-config)
;;   (push '("*ensime-inferior-scala*" :tail t :noselect t :stick t) popwin:special-display-config)
;;   (push '(sbt-mode :stick t :tail t :noselect t) popwin:special-display-config)
;;   (push '("*ensime-update*" :tail t) popwin:special-display-config)
;;   (push '("*HTTP Response*" :noselect t :stick t) popwin:special-display-config)
;;   (push '("*quickrun*" :tail t :stick t) popwin:special-display-config)
;;   (push '(inferior-python-mode :tail t :stick t) popwin:special-display-config)
;;   (push '(cider-inspector-mode) popwin:special-display-config)
;;   (push '(cider-popup-buffer-mode) popwin:special-display-config)
;;   (push '("*cider grimoire*") popwin:special-display-config)
;;   (push '("*cider-error*") popwin:special-display-config)
;;   (push '("*cider-result*") popwin:special-display-config)
;;   (push '(cider-repl-mode :tail t :stick t) popwin:special-display-config)
;;   (push '("*Backtrace*") popwin:special-display-config)
;;   (push '("*Messages*") popwin:special-display-config)
;;   (push '(slack-info-mode :tail t :stick t) popwin:special-display-config)
;;   (push '(slack-edit-message-mode :stick t) popwin:special-display-config)
;;   (push '(slack-mode :tail t :height 0.4 :noselect t :stick t )
;;         popwin:special-display-config)
;;   (push '("*Bundler*" :noselect t) popwin:special-display-config)
;;   (push '(inf-ruby-mode :stick t) popwin:special-display-config)
;;   (push '("*Process List*" :noselect t) popwin:special-display-config)
;;   (push '("*Warnings*" :noselect t) popwin:special-display-config)
;;   (push '("*Flycheck errors*" :stick t :noselect t) popwin:special-display-config)
;;   (push '("*compilation*" :stick t :tail t :noselect t)
;;         popwin:special-display-config)
;;   (push '("*Codic Result*" :noselect t :stick t) popwin:special-display-config)
;;   (push "*slime-apropos*" popwin:special-display-config)
;;   (push '("*slime-macroexpansion*" :noselect t) popwin:special-display-config)
;;   (push "*slime-description*" popwin:special-display-config)
;;   (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
;;   (push "*slime-xref*" popwin:special-display-config)
;;   (push '("*inferior-lisp*" :noselect t :tail t :stick t) popwin:special-display-config)
;;   (push '(sldb-mode :stick t) popwin:special-display-config)
;;   (push '(slime-repl-mode :stick t :position bottom) popwin:special-display-config)
;;   (push 'slime-connection-list-mode popwin:special-display-config)
;;   (push '("*alchemist-eval-mode*" :noselect t :height 0.2) popwin:special-display-config)
;;   (push '("*Alchemist-IEx*" :noselect t :height 0.2) popwin:special-display-config)
;;   (push '("*alchemist help*" :noselect t) popwin:special-display-config)
;;   (push '("*elixirc*" :noselect t) popwin:special-display-config))

(el-get-bundle indent-guide)
(use-package indent-guide
  :diminish indent-guide-mode
  :commands (indent-guide-mode)
  :init
  (setq indent-guide-recursive t)
  (add-hook 'lisp-mode-hook 'indent-guide-mode))

;; (el-get-bundle golden-ratio)
;; (use-package golden-ratio
;;   :commands (golden-ratio-mode)
;;   :diminish golden-ratio-mode
;;   :init
;;   (add-hook 'after-init-hook 'golden-ratio-mode)
;;   (setq golden-ratio-extra-commands '(windmove-up
;;                                       windmove-down
;;                                       windmove-left
;;                                       windmove-right
;;                                       evil-window-up
;;                                       evil-window-down
;;                                       evil-window-left
;;                                       evil-window-right))
;;   (setq golden-ratio-auto-scale t)
;;   (setq golden-ratio-recenter t)
;;   (setq golden-ratio-exclude-modes '(eww-mode
;;                                      pdf-view-mode
;;                                      ediff-mode
;;                                      comint-mode
;;                                      compilation-mode
;;                                      inf-ruby-mode
;;                                      slime-repl-mode))
;;   ;; (setq golden-ratio-exclude-buffer-names '("*compilation*"
;;   ;;                                           "*Flycheck errors*"
;;   ;;                                           "slime-apropos*"
;;   ;;                                           "*slime-description*"
;;   ;;                                           "*slime-compilation*"
;;   ;;                                           "*Proccess List*"
;;   ;;                                           "*LV*"
;;   ;;                                           "*Warnings*"))

;;   ;; (setq golden-ratio-auto-scale t)
;;   )

(el-get-bundle quickrun)
(use-package quickrun
  :commands (quickrun
             quickrun-region
             quickrun-with-arg
             quickrun-shell)
  :init
  (setq quickrun-focus-p nil))

(el-get-bundle restclient)
(use-package restclient
  :mode (("\\.restclient\\'" . restclient-mode))
  :init
  (add-hook 'restclient-mode-hook 'smartparens-mode)
  (setq restclient-dir "~/Dropbox/junk/")
  (defun restclient-client-buf-name ()
    (concat (format-time-string "%Y-%m-%d") ".restclient"))
  (defun create-restclient-buffer ()
    (interactive)
    (let ((buf (find-file-other-window
                (concat restclient-dir (restclient-client-buf-name)))))))
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

(el-get-bundle syl20bnr/emacs-emoji-cheat-sheet-plus
  :name emoji-cheat-sheet-plus)
(use-package emoji-cheat-sheet-plus
  :commands (emoji-cheat-sheet-plus-display-mode
             emoji-cheat-sheet-plus-insert)
  :init
  ;; (add-hook 'after-init-hook 'emoji-cheat-sheet-plus-display-mode)
  )

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
    ",r" 'wgrep-change-to-wgrep-mode))

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

(el-get-bundle ddskk)
(use-package skk-autoloads
  :commands (skk-mode skk-auto-fill-mode)
  :init

  (setq skk-echo t)
  (setq skk-tut-file (concat user-emacs-directory
                             "el-get/ddskk/etc/SKK.tut"))
  (setq define-input-method "japanese-skk")

  (setq skk-egg-like-newline t
        skk-auto-insert-paren t
        skk-show-annotation t
        skk-annotation-show-wikipedia-url t
        skk-use-look t
        skk-save-jisyo-instantly t)
  (setq skk-show-tooltip nil
        skk-show-inline nil
        skk-show-candidates-always-pop-to-buffer nil
        skk-show-mode-show nil)
  (setq skk-dcomp-activate t
        skk-dcomp-multiple-activate t
        skk-dcomp-multiple-rows 20
        skk-previous-completion-use-backtab t)
  (setq skk-comp-use-prefix t
        skk-comp-circulate t)
  (setq skk-sticky-key ";")
  (setq skk-previous-candidate-keys (list "x" "\C-p"))

  ;; skk-server AquaSKK
  (setq skk-server-portnum 1178
        skk-server-host "localhost"
        skk-server-report-response t)
  ;; (setq skk-large-jisyo (concat user-emacs-directory
  ;;                               "SKK-JISYO.L"))
  (setq skk-jisyo "~/.skk-jisyo")

  (setq skk-japanese-message-and-error t
        skk-show-japanese-menu t)
  (defun enable-skk-when-insert ()
    (unless (bound-and-true-p skk-mode)
      (skk-mode 1)
      (skk-latin-mode 1)))
  (add-hook 'evil-insert-state-entry-hook 'enable-skk-when-insert)
  ;; (add-hook 'skk-mode-hook #'(lambda ()
  ;;                              ;; (define-key skk-j-mode-map (kbd "C-h") 'skk-delete-backward-char)
  ;;                              (evil-make-intercept-map skk-j-mode-map 'insert )))
  :config
  (use-package skk-hint)
  ;; (use-package skk-study)
  ;; (define-key skk-j-mode-map (kbd "C-h") 'skk-delete-backward-char)
  ;; (evil-make-intercept-map skk-j-mode-map 'insert)
  ;; @@ server completion
  (add-to-list 'skk-search-prog-list
               '(skk-server-completion-search) t)
  (add-to-list 'skk-completion-prog-list
               '(skk-comp-by-server-completion) t)
  (defun my-skk-delete ()
    (interactive)
    (message "prefix: %s" (skk-get-prefix skk-current-rule-tree))
    (if (bound-and-true-p skk-j-mode)
        (cond
         ((eq skk-henkan-mode 'active) (call-interactively #'skk-delete-backward-char))
         ((and skk-henkan-mode
               (>= skk-henkan-start-point (point))
               (not (skk-get-prefix skk-current-rule-tree)))
          (call-interactively #'skk-delete-backward-char))
         ((and skk-henkan-mode overwrite-mode)
          (call-interactively #'skk-delete-backward-char))
         (t
          (progn
            (skk-delete-okuri-mark)
            (if (skk-get-prefix skk-current-rule-tree)
                (skk-erase-prefix 'clean)
              (skk-set-marker skk-kana-start-point nil)
              (call-interactively #'delete-backward-char)))))
      (call-interactively #'delete-backward-char)))
  (define-key evil-insert-state-map (kbd "C-h") #'my-skk-delete)

  (defun my-skk-control ()
    (if (bound-and-true-p skk-mode)
        (skk-latin-mode 1)))
  (add-hook 'evil-normal-state-entry-hook 'my-skk-control)
  (defadvice evil-ex-search-update-pattern
      (around evil-inhibit-ex-search-update-pattern-in-skk-henkan activate)
    ;; SKKの未確定状態(skk-henkan-mode)ではない場合だけ, 検索パターンをアップデート
    "Inhibit search pattern update during `skk-henkan-mode'.
This is reasonable since inserted text during `skk-henkan-mode'
is a kind of temporary one which is not confirmed yet."
    (unless (bound-and-true-p skk-henkan-mode)
      ad-do-it)))

(use-package subword-mode
  :commands (subword-mode)
  :init
  (add-hook 'scala-mode-hook 'subword-mode))

(use-package dired
  :init
  (setq dired-dwim-target t)
  (setq dired-recursive-copies 'always)
  :config
  (with-eval-after-load "evil"
    (evil-define-key 'normal dired-mode-map
      "$" 'evil-end-of-line
      "0" 'evil-digit-argument-or-evil-beginning-of-line
      "w" 'dired-show-file-type
      "y" 'dired-copy-filename-as-kill
      "K" 'dired-k
      (kbd "C-p") 'dired-up-directory
      (kbd "C-n") 'dired-find-file
      "r" 'dired-do-rename
      "R" 'wdired-change-to-wdired-mode
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
  (setq auto-mark-command-class-alist '((goto-line . jump))))

(el-get-bundle prodigy)
(use-package prodigy
  :commands (prodigy)
  :config
  (evil-define-key 'normal prodigy-mode-map
    "s" 'prodigy-start
    "S" 'prodigy-stop
    "r" 'prodigy-restart
    "v" 'prodigy-display-process
    "o" 'prodigy-browse)
  (prodigy-define-tag
   :name 'rails
   :on-output (lambda (&rest args)
                (let ((output (plist-get args :output))
                      (service (plist-get args :service)))
                  (when (or (s-matches? "Listening on 0\.0\.0\.0:[0-9]+, CTRL\\+C to stop" output)
                            (s-matches? "Ctrl-C to shutdown server" output))
                    (prodigy-set-status service 'ready)))))

  (prodigy-define-service
   :name "IB server"
   :command "bundle"
   :args '("exec" "rails" "server" "--port=3000")
   :cwd "/Users/yuyaminami/dev/instabase"
   :url "http://localhost:3000"
   :tags '(rails))
  (prodigy-define-service
   :name "IB migrateion"
   :command "bundle"
   :args '("exec" "rake" "db:migrate")
   :cwd "/Users/yuyaminami/dev/instabase"
   :tags '(rails))
  (prodigy-define-service
   :name "IB rollback"
   :command "bundle"
   :args '("exec" "rake" "db:rollback")
   :cwd "/Users/yuyaminami/dev/instabase"
   :tags '(rails))
  )

(el-get-bundle pomodoro)
(use-package pomodoro
  :commands (pomodoro:start)
  :init

  (setq pomodoro:set-mode-line-p t
        pomodoro:mode-line-work-sign "働 "
        pomodoro:mode-line-rest-sign "休 "
        pomodoro:mode-line-long-rest-sign "長休 "
        pomodoro:work-time 25
        pomodoro:rest-time 5
        pomodoro:long-rest-time 25
        pomodoro:iteration-for-long-rest 3
        pomodoro:mode-line-time-display t
        pomodoro:file nil
        pomodoro:myfile (lambda ()
                          (format-time-string "~/Dropbox/junk/%Y-%m-%d.org")))

  (defun pomodoro:find-rest-buffer ()
    (when (functionp pomodoro:myfile)
      (find-file (funcall pomodoro:myfile))))
  (add-hook 'pomodoro:finish-work-hook #'pomodoro:find-rest-buffer)
  (add-hook 'pomodoro:long-rest-hook #'pomodoro:find-rest-buffer)

  (defun my-pomodoro-notify (msg)
    (alert msg
           :title "Pomodoro"
           :category 'pomodoro))
  (add-hook 'pomodoro:finish-work-hook
            #'(lambda () (my-pomodoro-notify "Work is Finish")))
  (add-hook 'pomodoro:finish-rest-hook
            #'(lambda () (my-pomodoro-notify "Break time is Finish")))
  (add-hook 'pomodoro:long-rest-hook
            #'(lambda () (my-pomodoro-notify "Long Break time now"))))


(el-get-bundle google-this)
(use-package google-this
  :commands (google-this google-this-search google-this-region
                         google-maps google-this-translate-query-or-region))

(el-get-bundle shackle)
(use-package shackle
  :commands (shackle-mode)
  :init
  (defun shackle-full-screen (buffer alist plist)
    (display-buffer-full-screen buffer alist))
  (setq shackle-default-rule
        '(:select t :align t :popup t :size 0.3 :inhibit-window-quit t))
  (setq shackle-default-alignment 'below)
  (display-buffer (get-buffer "*Help*"))
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)
          ("COMMIT_EDITMSG" :regexp t :custom shackle-full-screen)
          ("\\`\\*magit-.*?:.*?[^\\*]\\'" :regexp t :align right :size 0.5)
          ("\\`\\*magit:.*?[^\\*]\\'" :regexp t :custom shackle-full-screen)
          ("\\`\\*magit.*?\\*\\'" :regexp t :align t :size 0.4)
          (inf-ruby-mode :popup t :align t :size 0.4)
          ("\\`\\*projectile-rails.*?\\*\\'"
           :regexp t :popup t :select nil :align t :size 0.4)
          (slack-mode :popup t :align t :size 0.4 :select t)
          (slack-edit-message-mode :same t :align right :size 0.5 :select t)
          (eww-bookmark-mode :inhibit-window-quit nil)
          (eww-history-mode :inhibit-window-quit nil)
          ))
  (add-hook 'after-init-hook 'shackle-mode))

(provide '03-util)
;;; 03-util.el ends here


