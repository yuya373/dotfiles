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

;;

;;; Code:

(el-get-bundle evil)
(el-get-bundle evil-leader)
(el-get-bundle anzu)
(el-get-bundle evil-anzu)
(el-get-bundle evil-args)
(el-get-bundle evil-jumper)
(el-get-bundle evil-lisp-state)
(el-get-bundle evil-matchit)
(el-get-bundle evil-nerd-commenter)
(el-get-bundle evil-numbers)
(el-get-bundle highlight)
(el-get-bundle evil-surround)
(el-get-bundle evil-terminal-cursor-changer)
(el-get-bundle evil-visualstar)
(el-get-bundle expand-region)
(el-get-bundle evil-indent-textobject)
(el-get-bundle evil-exchange)
(el-get-bundle evil-org-mode)
(el-get-bundle avy)
(el-get-bundle elscreen)

(eval-when-compile
  (el-get-bundle evil)
  (require 'evil))

(use-package evil
  :commands (evil-mode)
  :diminish undo-tree-mode
  :init
  ;; DO NOT LOAD evil plugin before here
  (setq evil-fold-level 4
        evil-search-module 'evil-search
        evil-esc-delay 0
        evil-want-C-i-jump t
        evil-want-C-u-scroll t
        evil-shift-width 2
        evil-cross-lines t)
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
  :config
  (add-hook 'evil-normal-state-exit-hook 'evil-ex-nohighlight)
  (use-package evil-anzu)
  (use-package evil-indent-textobject)
  (use-package evil-terminal-cursor-changer)
  (use-package evil-exchange :config (evil-exchange-install))
  (use-package evil-visualstar :config (global-evil-visualstar-mode))
  (use-package evil-surround :config (global-evil-surround-mode t))
  (defun evilmi-customize-keybinding ()
    (evil-define-key 'visual evil-matchit-mode-map
      "t" 'evilmi-jump-items)
    (evil-define-key 'normal evil-matchit-mode-map
      "t" 'evilmi-jump-items))
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
  (use-package evil-jumper
    :init
    :config (global-evil-jumper-mode)
    ;; (use-package elscreen
    ;;   :commands (elscreen-start)
    ;;   :init
    ;;   ;; (add-hook ' 'elscreen-start)
    ;;   (setq elscreen-default-buffer-name "*Messages*")

    ;;   (defvar evil-elscreen-jumps (make-hash-table))
    ;;   (defun evil-elscreen-set-current ()
    ;;     (let* ((screen (elscreen-get-current-screen))
    ;;            (screen-jumps (gethash screen evil-elscreen-jumps)))
    ;;       (message "evil-elscreen-set-current !!!!")
    ;;       (message "evil-elscreen-jumps: %s" evil-elscreen-jumps)
    ;;       (message "eegj:screen: %s" screen)
    ;;       (message "eegj:screen-jumps: %s" screen-jumps)
    ;;       (message "evil-jumper--window-jumps: %s" evil-jumper--window-jumps)
    ;;       (unless screen-jumps
    ;;         (setq screen-jumps (make-hash-table)))
    ;;       (setq evil-jumper--window-jumps screen-jumps)
    ;;       (puthash screen screen-jumps evil-elscreen-jumps)
    ;;       ))
    ;;   (defun evil-elscreen-set-jump ()
    ;;     (let ((screen (elscreen-get-current-screen))
    ;;           (jumps evil-jumper--window-jumps))
    ;;       (message "evil-elscreen-set-jump !!!!")
    ;;       (message "eesj:screen: %s" screen)
    ;;       (message "eesj:jumps: %s" jumps)
    ;;       (puthash screen jumps evil-elscreen-jumps)))

    ;;   ;; (add-hook 'elscreen-create-hook 'evil-elscreen-set-jump)
    ;;   (add-hook 'elscreen-goto-hook 'evil-elscreen-set-current))
    )
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
  (define-key evil-normal-state-map (kbd "RET") 'open-below-esc)
  (define-key evil-normal-state-map (kbd "m") 'set-mark-command)
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
  (define-key evil-insert-state-map (kbd "C-h") 'delete-backward-char)
  (define-key evil-ex-search-keymap (kbd "C-h") 'evil-skk-delete-backward-char)
  (define-key evil-ex-completion-map (kbd "C-h") 'evil-skk-delete-backward-char)
  (define-key minibuffer-local-map (kbd "C-h") 'evil-skk-delete-backward-char)
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
  (evil-define-key 'normal compilation-mode-map
    (kbd "C-c") 'evil-window-delete
    (kbd "C-d") 'evil-scroll-down)
  (evil-define-key 'normal comint-mode-map
    (kbd "C-c") 'evil-window-delete
    (kbd "C-d") 'evil-scroll-down)
  ;; elisp
  (evil-define-key 'normal emacs-lisp-mode-map
    ",c" 'byte-compile-file
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
    (setq avy-keys (number-sequence ?a ?z))
    :config
    (evil-define-motion evil-avy-goto-char-in-line (count)
      :type inclusive
      (evil-without-repeat
        (let ((pnt (point))
              (buf (current-buffer)))
          (call-interactively 'avy-goto-char-in-line)
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
      :repeat abort
      (evil-without-repeat
        (evil-enclose-avy-for-motion
          (call-interactively 'avy-goto-word-1))))
    (define-key evil-normal-state-map "s" 'avy-goto-char-2)
    (define-key evil-operator-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-normal-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-visual-state-map
      (kbd "f") #'evil-avy-goto-char-in-line)
    (define-key evil-operator-state-map
      (kbd "m") #'evil-avy-goto-word)
    (define-key evil-visual-state-map
      (kbd "m") #'evil-avy-goto-word))
  ;; line move
  (evil-swap-key evil-motion-state-map "j" "gj")
  (evil-swap-key evil-motion-state-map "k" "gk")
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up))


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
    (let ((junk-dir "~/Dropbox/junk/"))
      (helm-find-files-1 (expand-file-name junk-dir))))
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
        ((you-kill (buf)
                   (let* ((buf-name (buffer-name buf))
                          (window-buffers (mapcar #'window-buffer (window-list)))
                          (window-buffer-names (mapcar #'buffer-name window-buffers))
                          (first-char (substring-no-properties buf-name
                                                               0 1)))
                     (unless (or (string= " " first-char)
                                 (string= "*" first-char)
                                 (string= buf-name
                                          (buffer-name (current-buffer)))
                                 (cl-find-if #'(lambda (bn) (string= bn buf-name))
                                             window-buffer-names))
                       (kill-buffer buf)))))
      (mapc #'you-kill (buffer-list))))
  :config
  (evil-leader/set-leader "<SPC>")
  (use-package evil-org)
  ;; describe
  (evil-leader/set-key
    "=" 'all-indent
    ":" 'helm-M-x
    "<SPC>" 'avy-goto-word-1
    "aa" 'helm-do-ag
    "ab" 'helm-do-ag-buffers
    "ap" 'helm-projectile-ag
    "ag" 'ag
    "bb" 'helm-buffers-list
    "bb" 'helm-mini
    "bf" 'popwin:find-file
    "bk" 'kill-buffers
    "bl" 'popwin:popup-last-buffer
    "bp" 'popwin:pop-to-buffer
    "bw" 'projectile-switch-to-buffer-other-window
    "dc" 'helm-dash-at-point
    "da" 'helm-dash
    "dd" 'dired-open-current
    "di" 'helm-dash-install-docset
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
    "fd" 'helm-projectile-find-dir
    "ff" 'helm-find-files
    "fp" 'helm-browse-project
    "fr" 'helm-recentf
    "fs" 'reopen-with-sudo
    "gb" 'magit-blame-popup
    "gf" 'magit-fetch-popup
    "gg" 'magit-status
    "gm" 'git-messenger:popup-message
    "gn" 'git-gutter:next-hunk
    "gp" 'git-gutter:previous-hunk
    "gr" 'git-gutter:revert-hunk
    "gs" 'git-gutter:stage-hunk
    "gt" 'git-timemachine
    "gu" 'git-gutter:update-all-windows
    "gv" 'git-gutter:popup-hunk
    "hgc" 'helm-open-github-from-commit
    "hgf" 'helm-open-github-from-file
    "hgi" 'helm-open-github-from-issues
    "hgp" 'helm-open-github-from-pull-requests
    "hl" 'helm-resume
    "ho" 'helm-semantic-or-imenu
    "hm" 'helm-all-mark-rings
    "hp" 'helm-show-kill-ring
    "ig" 'indent-guide-mode
    "l" 'toggle-folding
    "ma" 'slack-select-rooms
    "mcs" 'slack-channel-select
    "mcc" 'slack-create-channel
    "mcu" 'slack-channel-list-update
    "mci" 'slack-channel-invite
    "mcr" 'slack-channel-rename
    "mcj" 'slack-channel-join
    "mcl" 'slack-channel-leave
    "mca" 'slack-channel-archive
    "mcA" 'slack-channel-unarchive
    "mga" 'slack-group-archive
    "mgA" 'slack-group-unarchive
    "mgs" 'slack-group-select
    "mgc" 'slack-create-group
    "mgi" 'slack-group-invite
    "mgu" 'slack-group-list-update
    "mgr" 'slack-group-rename
    "mgl" 'slack-group-leave
    "mis" 'slack-im-select
    "miu" 'slack-im-list-update
    "mus" 'slack-user-stars-list
    "mk" 'slack-ws-close
    "mfl" 'slack-file-list
    "mfu" 'slack-file-upload
    "mfd" 'slack-file-delete
    "ml" 'open-junk-dir
    "mn" 'open-junk-file
    "ms" 'slack-start
    "mt" 'slack-change-current-team
    ;; "pn" 'persp-next
    ;; "pp" 'persp-prev
    ;; "pS" 'persp-switch
    ;; "pbr" 'persp-remove-buffer
    ;; "pbk" 'persp-kill-buffer
    ;; "pbi" 'persp-import-buffers
    ;; "pba" 'persp-add-buffer
    ;; "pl" 'persp-load-state-from-file
    ;; "pk" 'persp-kill
    ;; "pr" 'persp-rename
    ;; "pN" 'persp-add-new
    "pk" 'projectile-invalidate-cache
    "ps" 'projectile-switch-project
    "pd" 'prodigy
    "qR" 'quickrun-region
    "qa" 'quickrun-with-arg
    "qr" 'quickrun
    "qs" 'quickrun-shell
    "r" 'create-restclient-buffer
    "s" 'create-eshell
    "tG" 'projectile-regenerate-tags
    "tQ" 'google-translate-query-translate-reverse
    "tl" 'google-translate-smooth-translate
    "tq" 'google-translate-query-translate
    "ts" 'timer
    "tt" 'elscreen-create
    "tn" 'elscreen-next
    "tp" 'elscreen-previous
    "tk" 'elscreen-kill
    "tK" 'elscreen-kill-screen-and-buffers
    "tw" 'twit
    "uv" 'undo-tree-visualize
    "wb" 'balance-windows
    "wc" 'whitespace-cleanup
    "wg" 'golden-ratio-mode
    "wm" 'toggle-window-maximized
    "wt" 'toggle-frame-alpha
    "ww" 'ace-window
    ;; "bn" 'switch-to-next-buffer
    ;; "bp" 'switch-to-prev-buffer
    ))

(provide '01-evil)
;;; 01-evil.el ends here
