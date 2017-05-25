;;; 01-evil.el --- evil                              -*- lexical-binding: t; -*-

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

;; Guide, Reference for Evil
;; [noctuid/evil-guide: Draft of a guide for using emacs with evil](https://github.com/noctuid/evil-guide)

;;

;;; Code:
(el-get-bundle goto-chg)
(el-get-bundle evil)
(el-get-bundle evil-leader)
(el-get-bundle anzu)
(el-get-bundle evil-anzu)
(el-get-bundle evil-args)
;; (el-get-bundle evil-jumper)
(el-get-bundle evil-lisp-state)
(el-get-bundle evil-matchit)
(el-get-bundle evil-nerd-commenter)
(el-get-bundle evil-numbers)
(el-get-bundle highlight)
(el-get-bundle evil-surround)
;; (el-get-bundle evil-terminal-cursor-changer)
(el-get-bundle evil-visualstar)
(el-get-bundle expand-region)
(el-get-bundle evil-indent-textobject)
(el-get-bundle evil-exchange)
;; (el-get-bundle evil-org-mode)
;; (el-get-bundle org-bullets)
(el-get-bundle avy)
(el-get-bundle avy-migemo)
(el-get-bundle ace-link)
(el-get-bundle migemo)

(eval-when-compile
  (el-get-bundle evil)
  (require 'evil))

(use-package evil
  :commands (evil-mode)
  :diminish undo-tree-mode
  :init
  ;; DO NOT LOAD evil plugin before here
  (setq evil-fold-level 4
        evil-search-module 'isearch
        evil-esc-delay 0
        evil-want-C-i-jump t
        evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-shift-width 2
        evil-cross-lines t
        evil-want-fine-undo t
        evil-auto-balance-windows t)
  (defun evil-swap-key (map key1 key2)
    ;; MAP中のKEY1とKEY2を入れ替え
    "Swap KEY1 and KEY2 in MAP."
    (let ((def1 (lookup-key map key1))
          (def2 (lookup-key map key2)))
      (define-key map key1 def2)
      (define-key map key2 def1)))
  (defun window-resizer ()
    "Control window size and position."
    (interactive)
    (let ((window-obj (selected-window))
          (current-width (window-width))
          (current-height (window-height))
          (dx (if (= (nth 0 (window-edges)) 0) 1
                -1))
          (dy (if (= (nth 1 (window-edges)) 0) 1
                -1))
          action c)
      (catch 'end-flag
        (while t
          (setq action
                (read-key-sequence-vector (format "size[%dx%d]"
                                                  (window-width)
                                                  (window-height))))
          (setq c (aref action 0))
          (cond ((= c ?l)
                 (enlarge-window-horizontally dx))
                ((= c ?h)
                 (shrink-window-horizontally dx))
                ((= c ?j)
                 (enlarge-window dy))
                ((= c ?k)
                 (shrink-window dy))
                ;; otherwise
                (t
                 (let ((last-command-char (aref action 0))
                       (command (key-binding action)))
                   (when command
                     (call-interactively command)))
                 (message "Quit")
                 (throw 'end-flag t)))))))
  (setq evil-overriding-maps nil)
  :config
  (setq evil-normal-state-modes
        (append
         ;; evil-emacs-state-modes
         evil-insert-state-modes
         evil-normal-state-modes
         evil-motion-state-modes))
  ;; (setq evil-emacs-state-modes nil)
  (setq evil-insert-state-modes nil)
  (setq evil-motion-state-modes nil)
  (use-package goto-chg)
  (add-hook 'evil-normal-state-exit-hook 'evil-ex-nohighlight)
  (use-package evil-anzu)
  (use-package evil-indent-textobject)
  ;; (use-package evil-terminal-cursor-changer)
  (use-package evil-exchange :config (evil-exchange-install))
  (use-package evil-visualstar :config (global-evil-visualstar-mode))
  (use-package evil-surround :config (global-evil-surround-mode t))
  (defun evilmi-customize-keybinding ()
    (evil-define-key 'visual evil-matchit-mode-map
      "%" 'evilmi-jump-items)
    (evil-define-key 'normal evil-matchit-mode-map
      "%" 'evilmi-jump-items))
  (use-package evil-matchit
    :config
    (setq evilmi-ignore-comments nil)
    (global-evil-matchit-mode t))
  (use-package expand-region
    :commands (er/expand-region er/contract-region))
  (use-package evil-numbers
    :commands (evil-numbers/inc-at-pt evil-numbers/dec-at-pt)
    :init
    (define-key evil-normal-state-map
      (kbd "+") 'evil-numbers/inc-at-pt)
    (define-key evil-normal-state-map
      (kbd "-") 'evil-numbers/dec-at-pt))
  (use-package evil-nerd-commenter
    :commands (evilnc-comment-or-uncomment-lines)
    :init
    (define-key evil-normal-state-map
      (kbd ",,") 'evilnc-comment-or-uncomment-lines)
    (define-key evil-visual-state-map
      (kbd ",,") 'evilnc-comment-or-uncomment-lines))
  ;; (use-package evil-jumper
  ;;   :config
  ;;   (global-evil-jumper-mode))
  (use-package evil-args
    :commands (evil-inner-arg evil-outer-arg)
    :init
    (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
    (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))
  ;; cleanup whitespace
  (defun evil-cleanup-whitespace ()
    (interactive)
    (unless (evil-insert-state-p)
      (whitespace-cleanup-region (point-min) (point-max))))
  (add-hook 'before-save-hook 'evil-cleanup-whitespace)
  (defun open-below-esc ()
    (interactive)
    (evil-open-below 1)
    (evil-normal-state))
  (define-key evil-insert-state-map (kbd "C-n") nil)
  (define-key evil-insert-state-map (kbd "C-p") nil)
  (define-key evil-insert-state-map (kbd "C-k") 'helm-show-kill-ring)

  (defun set-mark-and-exit ()
    (interactive)
    (mark-sexp)
    (evil-visual-state -1)
    (evil-normal-state))
  (define-key evil-normal-state-map (kbd "RET") 'open-below-esc)
  (define-key evil-normal-state-map (kbd "m") 'set-mark-and-exit)
  (define-key minibuffer-local-map (kbd "C-w") 'backward-kill-word)
  ;; isearch map
  (define-key isearch-mode-map (kbd "C-h") 'isearch-delete-char)
  ;; C-h map
  (defun evil-skk-delete-backward-char ()
    (interactive)
    ;; (call-interactively #'delete-backward-char)
    (if (bound-and-true-p skk-j-mode)
        (progn
          (call-interactively #'skk-delete-backward-char))

      (call-interactively #'delete-backward-char)
      )
    )
  ;; C-g
  (defun evil-keyboard-quit ()
    "Keyboard quit and force normal state."
    (interactive)
    (message "evil-keyboard-quit: %s" evil-mode)
    (and evil-mode (evil-force-normal-state))
    (keyboard-quit))
  (define-key evil-read-key-map       (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-normal-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-motion-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-insert-state-map   (kbd "C-g") nil)
  (define-key evil-window-map         (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-operator-state-map (kbd "C-g") #'evil-keyboard-quit)
  ;; [emacs - Evil Mode best practice? - Stack Overflow](http://stackoverflow.com/questions/8483182/evil-mode-best-practice/10166400#10166400)
  ;;; esc quits
  (defun minibuffer-keyboard-quit ()
    "Abort recursive edit.
  In Delete Selection mode, if the mark is active, just deactivate it;
  then it takes a second \\[keyboard-quit] to abort the minibuffer."
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
        (setq deactivate-mark  t)
      (when (get-buffer "*Completions*")
        (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))

  ;;   (define-key evil-normal-state-map [escape] 'keyboard-quit)
  ;;   (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map (kbd "C-[") 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map (kbd "C-[") 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map (kbd "C-[") 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map (kbd "C-[") 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map (kbd "C-[") 'minibuffer-keyboard-quit)
  ;;   (global-set-key [escape] 'keyboard-quit)

  ;; C-h
  (define-key evil-normal-state-map (kbd "\C-?") 'evil-window-left)
  (keyboard-translate ?\C-h ?\C-?)
  ;; (define-key global-map (kbd "C-h") 'delete-backward-char)
  ;; (define-key evil-insert-state-map (kbd "C-h") nil)
  ;; (define-key evil-ex-search-keymap (kbd "C-h") 'delete-backward-char)
  ;; (define-key evil-ex-completion-map (kbd "C-h") 'delete-backward-char)
  ;; (define-key minibuffer-local-map (kbd "C-h") 'delete-backward-char)
  ;; window move
  (define-key evil-normal-state-map (kbd "C-w r") 'window-resizer)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-normal-state-map (kbd "C-c") 'evil-window-delete)

  (define-key evil-motion-state-map (kbd "C-k") 'windmove-up)
  (define-key evil-motion-state-map (kbd "C-j") 'windmove-down)
  (define-key evil-motion-state-map (kbd "C-h") 'windmove-left)
  (define-key evil-motion-state-map (kbd "C-l") 'windmove-right)
  (define-key evil-motion-state-map (kbd "C-c") 'evil-window-delete)
  (evil-set-initial-state 'comint-mode 'normal)
  (evil-define-key 'insert comint-mode-map
    (kbd "C-p") 'comint-previous-input
    (kbd "C-n") 'comint-next-input)
  (evil-define-key 'normal comint-mode-map
    (kbd ",c") 'comint-clear-buffer
    (kbd "C-c") 'evil-window-delete
    (kbd "C-d") 'evil-scroll-down)
  ;; elisp

  (defun byte-compile-directory (directory)
    (interactive "DByte compile directory: ")
    (byte-recompile-directory directory 0 t))

  (evil-define-key 'normal emacs-lisp-mode-map
    ",cf" 'byte-compile-file
    ",cd" 'byte-compile-directory
    ",es" 'eval-sexp
    ",eb" 'eval-buffer
    ",ef" 'eval-defun)
  (evil-define-key 'normal lisp-interaction-mode-map
    ",c" 'byte-compile-file
    ",es" 'eval-sexp
    ",eb" 'eval-buffer
    ",ef" 'eval-defun)
  (evil-define-key 'visual emacs-lisp-mode-map
    ",er" 'eval-region)
  ;; expand-region
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region)
  (define-key evil-visual-state-map (kbd "C-v") 'er/contract-region)
  ;; avy
  (use-package avy
    :init
    (setq avy-background t)
    (setq avy-highlight-first t)
    (setq avy-all-windows nil)
    ;; (setq avy-keys (number-sequence ?a ?z))
    (setq avy-keys (list ?a ?s ?d ?f ?g ?h ?j ?k ?l
                         ?q ?w ?e ?r ?t ?y ?u ?i ?o ?p
                         ?z ?x ?c ?v ?b
                         ?n ?m ?, ?. ??))
    :config
    (evil-define-motion evil-avy-goto-char-in-line (count)
      :type inclusive
      :jump t
      :repeat motion
      :keep-visual t
      (evil-without-repeat
        (let ((pnt (point))
              (buf (current-buffer)))
          (call-interactively 'avy-migemo-goto-char-in-line)
          ;; (when (and (equal buf (current-buffer))
          ;;            (< (point) pnt))
          ;;   (setq evil-this-type
          ;;         (cond
          ;;          ((eq evil-this-type 'exclusive)
          ;;           'inclusive)
          ;;          ((eq evil-this-type 'inclusive)
          ;;           'exclusive))))
          )))
    (evil-define-motion evil-avy-goto-word (count)
      :type inclusive
      :jump t
      :repeat motion
      :keep-visual t
      (evil-without-repeat
        (evil-enclose-avy-for-motion
          (call-interactively 'avy-migemo-goto-word-1))))
    (define-key evil-normal-state-map "s" 'avy-migemo-goto-char-2)
    (define-key evil-operator-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-normal-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-visual-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-operator-state-map
      (kbd "m") #'evil-avy-goto-word)
    (define-key evil-visual-state-map
      (kbd "m") #'evil-avy-goto-word)
    (use-package avy-migemo)
    (avy-migemo-mode t)
    (use-package ace-link
      :config
      (defun exec-ace-link ()
        (interactive)
        (let ((mm major-mode))
          (cond
           ((string= mm "eww-mode") (ace-link-eww))
           ((string= mm "org-mode") (ace-link-org))
           ((string= mm "help-mode") (ace-link-help))
           ((string= mm "woman-mode") (ace-link-woman))
           ((string= mm "info-mode") (ace-link-info))
           ((string= mm "compilation-mode") (ace-link-compilation))
           (t (message "No ace-link function in %s" mm)))))))
  ;; line move
  ;; (evil-swap-key evil-motion-state-map "j" "gj")
  ;; (evil-swap-key evil-motion-state-map "k" "gk")
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  ;; (define-key evil-motion-state-map (kbd "j") 'evil-next-visual-line)
  ;; (define-key evil-motion-state-map (kbd "k") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up)
  ;; (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  ;; (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (defvar my-saved-flag nil)
  (defun my-save-if-bufferfilename (&rest args)
    (interactive)
    (if (buffer-file-name)
        (progn
          (set-buffer-modified-p t)
          (save-buffer))))
  (add-hook 'evil-insert-state-exit-hook #'my-save-if-bufferfilename)
  ;; (advice-add 'evil-normal-state :after 'my-save-if-bufferfilename)
  (define-key evil-normal-state-map (kbd "C-s") nil)
  (define-key evil-normal-state-map (kbd "C-s") 'my-save-if-bufferfilename)
  )


(use-package evil-leader
  :commands (global-evil-leader-mode)
  :init
  (add-hook 'after-init-hook 'global-evil-leader-mode)
  (add-hook 'global-evil-leader-mode-hook '(lambda () (evil-mode t)))
  (defun toggle-window-maximized ()
    (interactive)
    (if window-system
        (let ((current-size (frame-parameter nil 'fullscreen)))
          (if (null current-size)
              (set-frame-parameter nil 'fullscreen 'maximized)
            (set-frame-parameter nil 'fullscreen nil)))))
  (defun toggle-frame-alpha ()
    (interactive)
    (if window-system
        (let ((current-alpha (frame-parameter nil 'alpha)))
          (if (or (null current-alpha) (= current-alpha 100))
              (set-frame-parameter nil 'alpha 78)
            (set-frame-parameter nil 'alpha 100)))))
  (defun toggle-folding ()
    (interactive)
    (set-selective-display
     (unless selective-display (1+ (current-column))))

    (recenter))

  (defun open-junk-dir ()
    (interactive)
    (let* ((junk-dir "~/Dropbox/junk/")
           (current-date (split-string (format-time-string "%Y-%m-%d") "-"))
           (year (read-from-minibuffer "Year: " (car current-date)))
           (month (and (< 1 (length year)) (read-from-minibuffer "Month: " (cadr current-date))))
           (day (and (< 1 (length month)) (read-from-minibuffer "Day: " (caddr current-date)))))
      (if (and (not (eq 0 (* (length year) (length month) (length day)))))
          (helm-find-files-1 (expand-file-name (format "%s/%s-%s-%s" junk-dir year month day)))
        (helm-find-files-1 (expand-file-name junk-dir)))))
  (defun timer (time msg &rest moremsg)
    (interactive
     (list (read-string "いつ? (sec, min, hour, HH:MM) ")
           (read-string "メッセージ: ")))
    (run-at-time
     time nil
     #'(lambda (arg)
         (message "＼時間です／")
         (ding)
         (sleep-for 1)
         (animate-sequence arg 0)
         (goto-char (point-min))
         (insert (format-time-string "%H:%M "))
         (insert-button "[閉じる]" 'action #'(lambda (_arg) (kill-buffer))))
     (cons msg moremsg))
    (message "タイマー開始しました"))
  (defun all-indent ()
    (interactive)
    (save-excursion
      (indent-region (point-min) (point-max))))
  (defun reopen-with-sudo ()
    "Reopen current buffer-file with sudo using tramp."
    (interactive)
    (let ((file-name (buffer-file-name)))
      (if file-name
          (find-alternate-file (concat "/sudo::" file-name))
        (error "Cannot get a file name"))))
  (defun dired-open-current ()
    (interactive)
    (let* ((file-name (buffer-file-name))
           (splitted (split-string file-name "/")))
      (dired
       (mapconcat #'identity
                  (reverse (cdr (reverse splitted)))
                  "/"))))
  (defun kill-buffers ()
    (interactive)
    (cl-labels
        ((kill (buf)
               (let ((buf-name (buffer-name buf)))
                 (when buf-name
                   (let* ((window-buffers (mapcar #'window-buffer (window-list)))
                          (window-buffer-names (mapcar #'buffer-name window-buffers))
                          (tab-buffers (mapcar #'(lambda (tab) (get tab 'current-buffer))
                                                    (perspeen-tab-get-tabs)))
                          (tab-buffer-names (mapcar #'buffer-name tab-buffers))
                          (first-char (substring-no-properties buf-name 0 1)))
                     (unless (or (string= " " first-char)
                                 (string= "*" first-char)
                                 (string= buf-name
                                          (buffer-name (current-buffer)))
                                 (cl-find-if #'(lambda (bn) (string= bn buf-name))
                                             tab-buffer-names)
                                 (cl-find-if #'(lambda (bn) (string= bn buf-name))
                                             window-buffer-names))
                       (kill-buffer buf)))))))
      (let ((debug-on-error t)
            (buf-list (if perspeen-mode
                          (perspeen-ws-struct-buffers perspeen-current-ws)
                        (buffer-list))))
        (mapc #'kill buf-list))))
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "=" 'all-indent
    ":" 'helm-M-x
    "<SPC>" 'avy-migemo-goto-word-1
    "aa" 'helm-do-ag
    "ab" 'helm-do-ag-buffers
    "ag" 'ag
    "ap" 'helm-projectile-ag
    "bb" 'helm-buffers-list
    "bb" 'helm-mini
    "bk" 'kill-buffers
    "br" nil
    "brr" 'browser-refresh
    "bra" 'browser-refresh-and-activate
    "bw" 'projectile-switch-to-buffer-other-window
    ;; "dd" 'osx-dictionary-search-pointer
    ;; "di" 'osx-dictionary-search-input
    "dc" 'dired-open-current
    "dd" 'helm-dash-at-point
    "da" 'helm-dash
    ;; "dd" 'dired-open-current
    "di" 'helm-dash-async-install-docset
    "eha" 'helm-apropos
    "ehb" 'describe-bindings
    "ehf" 'describe-function
    "ehm" 'describe-mode
    "ehp" 'describe-package
    "ehs" 'describe-syntax
    "ehv" 'describe-variable
    "el" 'flycheck-list-errors
    "en" 'flycheck-next-error
    "ep" 'flycheck-previous-error
    "eb" 'flycheck-buffer
    "fd" 'helm-projectile-find-dir
    "ff" 'helm-find-files
    "fp" 'helm-browse-project
    "fr" 'helm-recentf
    "fs" 'reopen-with-sudo
    "gb" 'magit-blame-popup
    "gf" 'magit-fetch-popup
    "gg" 'magit-status
    "gm" 'git-messenger:popup-message
    "ghn" 'git-gutter+-next-hunk
    "ghp" 'git-gutter+-previous-hunk
    "ghr" 'git-gutter+-revert-hunks
    "ghs" 'git-gutter+-stage-hunks
    "gp" nil
    "gpp" 'hub-pr-prepare-pr
    "gps" 'hub-pr-send-pr
    "gc" 'git-gutter+-commit
    "gC" 'git-gutter+-stage-and-commit
    "gt" 'git-timemachine
    "hgc" 'helm-open-github-from-commit
    "hgf" 'helm-open-github-from-file
    "hgi" 'helm-open-github-from-issues
    "hgp" 'helm-open-github-from-pull-requests
    "hl" 'helm-resume
    "hm" 'helm-all-mark-rings
    "hi" 'helm-imenu-anywhere
    "ho" 'helm-semantic-or-imenu
    "hp" 'helm-list-emacs-process
    "ig" 'indent-guide-mode
    "jw" 'avy-migemo-goto-word-1
    "jl" 'avy-goto-line
    "jc" 'avy-migemo-goto-char
    "ju" 'exec-ace-link
    "l" 'toggle-folding
    "ma" 'slack-select-rooms
    "mcA" 'slack-channel-unarchive
    "mca" 'slack-channel-archive
    "mcc" 'slack-create-channel
    "mci" 'slack-channel-invite
    "mcj" 'slack-channel-join
    "mcl" 'slack-channel-leave
    "mcr" 'slack-channel-rename
    "mcs" 'slack-channel-select
    "mcu" 'slack-channel-list-update
    "mfd" 'slack-file-delete
    "mfl" 'slack-file-list
    "mfu" 'slack-file-upload
    "mgA" 'slack-group-unarchive
    "mga" 'slack-group-archive
    "mgc" 'slack-create-group
    "mgi" 'slack-group-invite
    "mgl" 'slack-group-leave
    "mgr" 'slack-group-rename
    "mgs" 'slack-group-select
    "mgu" 'slack-group-list-update
    "mic" 'slack-im-close
    "mio" 'slack-im-open
    "mis" 'slack-im-select
    "miu" 'slack-im-list-update
    "mk" 'slack-ws-close
    "mus" 'slack-user-select
    "mua" 'slack-select-unread-rooms
    "ml" 'open-junk-dir
    "mm" 'slack-start
    "mn" 'open-junk-file
    "mo" 'tracking-next-buffer
    "msf" 'slack-search-from-files
    "msm" 'slack-search-from-messages
    "mss" 'slack-search-select
    "mtt" 'slack-change-current-team
    "mts" 'slack-thread-select
    ;; "mus" 'slack-user-stars-list
    "oa" 'org-agenda
    "oo" 'open-junk-org-today
    "oco" 'org-clock-out
    ;; "pd" 'prodigy
    "pk" 'projectile-invalidate-cache
    "ps" 'projectile-switch-project
    "qR" 'quickrun-region
    "qa" 'quickrun-with-arg
    "qr" 'quickrun
    "qs" 'quickrun-shell
    "r" 'create-restclient-buffer
    "s" 'create-eshell
    "tG" 'projectile-regenerate-tags
    "tc" 'helm-gtags-create-tags
    "tf" 'helm-gtags-select
    "tu" 'helm-gtags-update-tags
    "tU" 'helm-gtags-update-all-tags
    "td" 'helm-gtags-find-tag
    "tr" 'helm-gtags-find-rtag
    "tn" 'helm-gtags-next-history
    "tp" 'helm-gtags-previous-history
    "tQ" 'google-translate-query-translate-reverse
    "tl" 'google-translate-smooth-translate
    "tq" 'google-translate-query-translate
    "ts" 'timer
    "tw" 'twit-another-buffer
    "uv" 'undo-tree-visualize
    "wb" 'balance-windows
    "wc" 'whitespace-cleanup
    "wg" 'golden-ratio-mode
    "wk" 'kill-buffer-and-window
    "wm" 'toggle-window-maximized
    "wt" 'toggle-frame-alpha
    "ww" 'ace-window
    ;; "pN" 'persp-add-new
    ;; "pS" 'persp-switch
    ;; "pba" 'persp-add-buffer
    ;; "pbi" 'persp-import-buffers
    ;; "pbk" 'persp-kill-buffer
    ;; "pbr" 'persp-remove-buffer
    ;; "pk" 'persp-kill
    ;; "pl" 'persp-load-state-from-file
    ;; "pn" 'persp-next
    ;; "pp" 'persp-prev
    ;; "pr" 'persp-rename
    ;; "bn" 'switch-to-next-buffer
    ;; "bp" 'switch-to-prev-buffer
    )
  )


(provide '01-evil)
;;; 01-evil.el ends here
