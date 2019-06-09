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
(eval-when-compile
  (require 'use-package)
  (require 'el-get))

(el-get-bundle goto-chg)
(el-get-bundle evil)
(el-get-bundle evil-leader)
(el-get-bundle anzu)
(el-get-bundle evil-anzu)
(el-get-bundle evil-args)
(el-get-bundle evil-lisp-state)
(el-get-bundle evil-matchit)
(el-get-bundle evil-nerd-commenter)
(el-get-bundle evil-numbers)
(el-get-bundle highlight)
(el-get-bundle evil-surround)
(el-get-bundle evil-visualstar)
(el-get-bundle expand-region)
(el-get-bundle evil-indent-textobject)
(el-get-bundle evil-exchange)
(el-get-bundle avy)
(el-get-bundle momomo5717/avy-migemo)
(el-get-bundle ace-link)
(el-get-bundle migemo)
(el-get-bundle emacs-evil/evil-collection)

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

(use-package goto-chg
  :after (evil))
(use-package evil-collection
  :after (evil)
  :init
  (setq evil-collection-company-use-tng nil
        evil-collection-setup-minibuffer nil
        evil-collection-key-blacklist '("t" "SPC" "C-j" "C-k" "C-h" "C-l" "C-c" "C-c C-c" "C-b"))
  :config
  (evil-collection-init)
  (evil-collection-define-key 'normal 'compilation-mode-map
    (kbd "C-n") 'compilation-next-error
    (kbd "C-p") 'compilation-previous-error)
  (evil-collection-define-key 'normal 'flycheck-error-list-mode-map
    (kbd "C-n") 'flycheck-error-list-next-error
    (kbd "C-p") 'flycheck-error-list-previous-error)
  (evil-collection-define-key 'normal 'tide-project-errors-mode-map
    (kbd "C-n") 'tide-find-next-error
    (kbd "C-p") 'tide-find-previous-error)
  (evil-collection-define-key 'normal 'nov-mode-map
    (kbd "C-n") 'nov-next-document
    (kbd "C-p") 'nov-previous-document)
  (evil-set-initial-state 'shell-mode 'normal)
  )
(use-package evil-anzu
  :after (evil))
(use-package evil-indent-textobject
  :after (evil))
(use-package evil-exchange
  :after (evil)
  :config (evil-exchange-install))
(use-package evil-visualstar
  :after (evil)
  :config (global-evil-visualstar-mode))
(use-package evil-surround
  :after (evil)
  :config (global-evil-surround-mode t))
(use-package evil-matchit
  :after (evil)
  :init
  (setq evilmi-ignore-comments nil)
  :config
  (global-evil-matchit-mode t))
(use-package expand-region
  :after (evil)
  :commands (er/expand-region er/contract-region))
(use-package evil-numbers
  :after (evil)
  :commands (evil-numbers/inc-at-pt evil-numbers/dec-at-pt)
  :init
  (define-key evil-normal-state-map
    (kbd "+") 'evil-numbers/inc-at-pt)
  (define-key evil-normal-state-map
    (kbd "-") 'evil-numbers/dec-at-pt))
(use-package evil-nerd-commenter
  :after (evil)
  :commands (evilnc-comment-or-uncomment-lines)
  :init
  (define-key evil-normal-state-map
    (kbd ",,") 'evilnc-comment-or-uncomment-lines)
  (define-key evil-visual-state-map
    (kbd ",,") 'evilnc-comment-or-uncomment-lines))
(use-package evil-args
  :after (evil)
  :config
  (define-key evil-motion-state-map "L" 'evil-forward-arg)
  (define-key evil-motion-state-map "H" 'evil-backward-arg)

  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))
(use-package avy
  :after (evil)
  :init
  (setq avy-background t)
  (setq avy-highlight-first t)
  (setq avy-all-windows nil)
  (setq avy-keys (list ?a ?s ?d ?f ?g ?h ?j ?k ?l
                       ?q ?w ?e ?r ?t ?y ?u ?i ?o ?p
                       ?z ?x ?c ?v ?b
                       ?n ?m ?, ?. ??))
  :config
  (evil-define-motion evil-avy-goto-char-in-line (_count)
    :type inclusive
    :jump t
    :repeat motion
    :keep-visual t
    (evil-without-repeat
      (call-interactively 'avy-migemo-goto-char-in-line)))
  (evil-define-motion evil-avy-goto-word (_count)
    :type inclusive
    :jump t
    :repeat motion
    :keep-visual t
    (evil-without-repeat
      (evil-enclose-avy-for-motion
        (call-interactively 'avy-migemo-goto-word-1))))
  (define-key evil-normal-state-map "s" 'avy-migemo-goto-char-2)
  (define-key evil-operator-state-map (kbd "f") #'evil-avy-goto-char-in-line)
  (define-key evil-normal-state-map (kbd "f") #'evil-avy-goto-char-in-line)
  (define-key evil-visual-state-map (kbd "f") #'evil-avy-goto-char-in-line)
  (define-key evil-operator-state-map (kbd "m") #'evil-avy-goto-word)
  (define-key evil-visual-state-map (kbd "m") #'evil-avy-goto-word))

(use-package avy-migemo
  :after (avy)
  :config
  (avy-migemo-mode t)

  ;; (defun avy-migemo-goto-char (char &optional arg)
  ;;   "The same as `avy-migemo-goto-char' except for the candidates via migemo."
  ;;   (interactive (list (read-char "char: " t)
  ;;                      current-prefix-arg))
  ;;   (avy-with avy-goto-char
  ;;     (avy-jump
  ;;      (if (= 13 char)
  ;;          "\n"
  ;;        ;; Adapt for migemo
  ;;        (avy-migemo-regex-quote-concat (string char)))
  ;;      :window-flip arg)))

  ;; (defun avy-migemo-goto-char-2 (char1 char2 &optional arg beg end)
  ;;   "The same as `avy-goto-char-2' except for the candidates via migemo."
  ;;   (interactive (list (read-char "char 1: " t)
  ;;                      (read-char "char 2: " t)
  ;;                      current-prefix-arg
  ;;                      nil nil))
  ;;   (when (eq char1 ?)
  ;;     (setq char1 ?\n))
  ;;   (when (eq char2 ?)
  ;;     (setq char2 ?\n))
  ;;   (avy-with avy-goto-char-2
  ;;     (avy-jump
  ;;      ;; Adapt for migemo
  ;;      (if (eq char1 ?\n)
  ;;          (concat (string char1) (avy-migemo-regex-quote-concat (string char2)))
  ;;        (avy-migemo-regex-quote-concat (string char1 char2)))
  ;;      :window-flip arg
  ;;      :beg beg
  ;;      :end end)))

  ;; (defun avy-migemo-goto-char-in-line (char)
  ;;   "The same as `avy-goto-char-in-line' except for the candidates via migemo."
  ;;   (interactive (list (read-char "char: " t)))
  ;;   (avy-with avy-goto-char
  ;;     (avy-jump
  ;;      ;; Adapt for migemo
  ;;      (avy-migemo-regex-quote-concat (string char))
  ;;      :window-flip avy-all-windows
  ;;      :beg (line-beginning-position)
  ;;      :end (line-end-position))))

  ;; (defun avy-migemo-goto-word-1 (char &optional arg beg end symbol)
  ;;   "The same as `avy-goto-word-1' except for the candidates via migemo."
  ;;   (interactive (list (read-char "char: " t)
  ;;                      current-prefix-arg))
  ;;   (avy-with avy-goto-word-1
  ;;     (let* ((str (string char))
  ;;            (regex (cond ((string= str ".")
  ;;                          "\\.")
  ;;                         ((and avy-word-punc-regexp
  ;;                               (string-match avy-word-punc-regexp str))
  ;;                          ;; Adapt for migemo
  ;;                          (avy-migemo-regex-quote-concat str))
  ;;                         ((<= char 26) str)
  ;;                         (symbol (concat "\\_<" str))
  ;;                         (t ;; Adapt for migemo
  ;;                          (concat
  ;;                           "\\b"
  ;;                           (avy-migemo-regex-concat str))))))
  ;;       (avy-jump regex
  ;;                 :window-flip arg
  ;;                 :beg beg
  ;;                 :end end))))
  )

(el-get-bundle ace-window)
(use-package ace-window
  :commands (ace-window aw-select aw-switch-to-window)
  :init
  (setq aw-dispatch-always t)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package evil
  :commands (evil-mode)
  :init
  (setq evil-fold-level 4
        evil-search-module 'isearch
        evil-esc-delay 0
        evil-want-C-i-jump t
        evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-shift-width 2
        evil-cross-lines t
        evil-want-fine-undo t
        evil-auto-balance-windows t
        evil-want-keybinding nil
        evil-want-integration t
        evil-overriding-maps nil)
  :config
  (evil-define-command evil-scroll-down (count)
    "Scrolls the window and the cursor COUNT lines downwards.
If COUNT is not specified the function scrolls down
`evil-scroll-count', which is the last used count.
If the scroll count is zero the command scrolls half the screen."
    :repeat nil
    :keep-visual t
    (interactive "<c>")
    (evil-save-column
      (setq count (or count (max 0 evil-scroll-count)))
      (setq evil-scroll-count count)
      (when (eobp) (signal 'end-of-buffer nil))
      (when (zerop count)
        (setq count (/ (1- (window-height)) 2)))
      ;; BUG #660: First check whether the eob is visible.
      ;; In that case we do not scroll but merely move point.
      (if (<= (point-max) (window-end))
          (with-no-warnings (next-line count nil))
        (let ((xy (posn-x-y (posn-at-point))))
          (condition-case nil
              (progn
                (scroll-up count)
                (let* ((wend (window-end nil t))
                       (p (posn-at-x-y (car xy) (cdr xy)))
                       (margin (max 0 (- scroll-margin
                                         (cdr (posn-col-row p))))))
                  (when (posn-point p)
                    (goto-char (posn-point p)))
                  ;; ensure point is not within the scroll-margin
                  (when (> margin 0)
                    (with-no-warnings (next-line margin))
                    (recenter scroll-margin))
                  (when (<= (point-max) wend)
                    (save-excursion
                      (goto-char (point-max))
                      (recenter (- (max 1 scroll-margin)))))))
            (end-of-buffer
             (goto-char (point-max))
             (recenter (- (max 1 scroll-margin)))))))))
  (add-hook 'evil-normal-state-exit-hook 'evil-ex-nohighlight)
  ;; cleanup whitespace
  (defun evil-cleanup-whitespace ()
    (interactive)
    (unless (evil-insert-state-p)
      (when (bound-and-true-p whitespace-mode)
        (whitespace-cleanup-region (point-min) (point-max)))))
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
  (define-key isearch-mode-map (kbd "C-h") 'isearch-delete-char)

  ;; (defun evil-keyboard-quit ()
  ;;   "Keyboard quit and force normal state."
  ;;   (interactive)
  ;;   (message "evil-keyboard-quit: %s" evil-mode)
  ;;   (and evil-mode (evil-force-normal-state))
  ;;   (keyboard-quit))
  ;; (define-key evil-read-key-map       (kbd "C-g") #'evil-keyboard-quit)
  ;; (define-key evil-normal-state-map   (kbd "C-g") #'evil-keyboard-quit)
  ;; (define-key evil-motion-state-map   (kbd "C-g") #'evil-keyboard-quit)
  ;; (define-key evil-insert-state-map   (kbd "C-g") nil)
  ;; (define-key evil-window-map         (kbd "C-g") #'evil-keyboard-quit)
  ;; (define-key evil-operator-state-map (kbd "C-g") #'evil-keyboard-quit)
  ;; [emacs - Evil Mode best practice? - Stack Overflow](http://stackoverflow.com/questions/8483182/evil-mode-best-practice/10166400#10166400)
  ;;; esc quits
  ;; (defun minibuffer-keyboard-quit ()
  ;;   "Abort recursive edit.
  ;; In Delete Selection mode, if the mark is active, just deactivate it;
  ;; then it takes a second \\[keyboard-quit] to abort the minibuffer."
  ;;   (interactive)
  ;;   (if (and delete-selection-mode transient-mark-mode mark-active)
  ;;       (setq deactivate-mark  t)
  ;;     (when (get-buffer "*Completions*")
  ;;       (delete-windows-on "*Completions*"))
  ;;     (abort-recursive-edit)))

  ;; (define-key minibuffer-local-map (kbd "C-[") 'minibuffer-keyboard-quit)
  ;; (define-key minibuffer-local-ns-map (kbd "C-[") 'minibuffer-keyboard-quit)
  ;; (define-key minibuffer-local-completion-map (kbd "C-[") 'minibuffer-keyboard-quit)
  ;; (define-key minibuffer-local-must-match-map (kbd "C-[") 'minibuffer-keyboard-quit)
  ;; (define-key minibuffer-local-isearch-map (kbd "C-[") 'minibuffer-keyboard-quit)

  ;; C-h
  (global-set-key (kbd "C-h") 'evil-delete-backward-char)
  (define-key evil-ex-completion-map (kbd "C-h") 'evil-delete-backward-char)
  (define-key minibuffer-inactive-mode-map (kbd "C-h") 'evil-delete-backward-char)
  (define-key minibuffer-local-map (kbd "C-h") 'evil-delete-backward-char)
  (define-key minibuffer-local-ns-map (kbd "C-h") 'evil-delete-backward-char)
  (define-key minibuffer-local-completion-map (kbd "C-h") 'evil-delete-backward-char)
  (define-key minibuffer-local-must-match-map (kbd "C-h") 'evil-delete-backward-char)
  (define-key minibuffer-local-shell-command-map (kbd "C-h") 'evil-delete-backward-char)
  (define-key minibuffer-local-isearch-map (kbd "C-h") 'evil-delete-backward-char)
  ;; (keyboard-translate ?\C-h ?\C-?)

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
  ;; expand-region
  (define-key evil-visual-state-map (kbd "v") 'er/expand-region)
  (define-key evil-visual-state-map (kbd "C-v") 'er/contract-region)
  ;; avy

  ;; line move
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  ;; (define-key evil-motion-state-map (kbd "j") 'evil-next-visual-line)
  ;; (define-key evil-motion-state-map (kbd "k") 'evil-previous-visual-line)
  ;; (define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up)
  ;; (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  ;; (define-key evil-visual-state-map (kbd "C-u") 'evil-scroll-up)
  (defun my-save-if-bufferfilename (&rest args)
    (interactive)
    (if (buffer-file-name)
        (progn
          (set-buffer-modified-p t)
          (save-buffer))))
  (add-hook 'evil-insert-state-exit-hook #'my-save-if-bufferfilename)
  (define-key evil-normal-state-map (kbd "C-s") nil)
  (define-key evil-normal-state-map (kbd "C-s") 'my-save-if-bufferfilename)

  ;; (define-key evil-normal-state-map (kbd "C-d") 'scroll-up-command)
  ;; (define-key evil-normal-state-map (kbd "C-u") 'scroll-down-command)
  )

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
        ;; (set-buffer (find-file (concat "/sudo:root@localhost:" file-name)))
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

(defun :command-one-line (cmd args)
  (with-temp-buffer
    (when (zerop (apply 'call-process cmd nil t nil args))
      (goto-char (point-min))
      (buffer-substring-no-properties
       (line-beginning-position) (line-end-position)))))
(defun github-url ()
  (let* ((remote-url (:command-one-line "git"
                                        '("config" "--get" "remote.origin.url")))
         (url (replace-regexp-in-string ".git\\'"
                                        ""
                                        (replace-regexp-in-string "git@github.com:"
                                                                  "https://github.com/"
                                                                  remote-url))))
    url))

(defun github-open ()
  (interactive)
  (browse-url (github-url)))

(defun github-branches-open ()
  (interactive)
  (browse-url (format "%s/branches" (github-url))))

(defun github-pulls-open ()
  (interactive)
  (browse-url (format "%s/pulls" (github-url))))

(defun github-commit-open ()
  (interactive)
  (browse-url (format "%s/commit/%s"
                      (github-url)
                      (read-from-minibuffer "Commit: "))))

(use-package evil-leader
  :commands (global-evil-leader-mode)
  :init
  (add-hook 'after-init-hook 'global-evil-leader-mode)
  (add-hook 'global-evil-leader-mode-hook 'evil-mode)
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
    "ci" 'toggle-company-ispell
    "dt" 'treemacs-select-window
    "dc" 'treemacs-find-file
    "da" 'treemacs-add-project
    "dd" 'helm-dash-at-point
    ;; "da" 'helm-dash
    "di" 'helm-dash-async-install-docset
    "ef" 'flycheck-eslint-fix
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
    "eww" 'eww
    "ewB" 'helm-eww-buffers
    "ewb" 'helm-eww-bookmarks
    "ewh" 'helm-eww-history
    "ewe" 'helm-eww
    "fd" 'helm-projectile-find-dir
    "ff" 'helm-find-files
    "fp" 'helm-browse-project
    "fr" 'helm-recentf
    "fs" 'reopen-with-sudo
    "gb" 'magit-blame
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
    "goo" 'github-open
    "gob" 'github-branches-open
    "gop" 'github-pulls-open
    "goc" 'github-commit-open
    "gt" nil
    "gtt" 'git-timemachine
    "gtp" 'git-timemachine-show-previous-revision
    "gtn" 'git-timemachine-show-next-revision
    "gtg" 'git-timemachine-show-nth-revision
    "gtq" 'git-timemachine-quit
    "gtw" 'git-timemachine-kill-abbreviated-revision
    "gtW" 'git-timemachine-kill-revision
    "gtb" 'git-timemachine-blame
    "hgc" 'helm-open-github-from-commit
    "hgf" 'helm-open-github-from-file
    "hgi" 'helm-open-github-from-issues
    "hgp" 'helm-open-github-from-pull-requests
    "hkt" 'which-key-show-top-level
    "hkm" 'which-key-show-major-mode
    "hkM" 'which-key-show-minor-mode-keymap
    "hl" 'helm-resume
    "hL" '(lambda () (interactive) (helm-resume t))
    "hm" 'helm-all-mark-rings
    "hi" 'helm-imenu-anywhere
    "ho" 'helm-semantic-or-imenu
    "hp" 'helm-list-emacs-process
    "hun" 'easy-hugo-newpost-today
    "hud" 'easy-hugo-github-deploy
    "hul" 'easy-hugo-list-posts
    "ig" 'indent-guide-mode
    "jw" 'avy-migemo-goto-word-1
    "jl" 'avy-goto-line
    "jc" 'avy-migemo-goto-char
    "ju" 'exec-ace-link
    "l" 'toggle-folding
    "ma" 'helm-slack
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
    "mua" 'helm-slack-unreads
    "md" 'open-diary-dir
    "ml" 'open-junk-dir
    "mm" 'slack-start
    "mn" 'open-junk-file
    "mow" 'slack-log-open-websocket-buffer
    "moe" 'slack-log-open-event-buffer
    "moo" 'slack-log-open-buffer
    "msf" 'slack-search-from-files
    "msm" 'slack-search-from-messages
    "mss" 'slack-search-select
    "msl" 'slack-stars-list
    "mtt" 'slack-change-current-team
    "mta" 'slack-all-threads
    "oa" 'org-agenda
    "oo" 'open-junk-org-today
    "oco" 'org-clock-out
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
    "ti" 'timer
    "ts" 'text-scale-adjust
    "tw" 'twit-another-buffer
    "uv" 'undo-tree-visualize
    "wb" 'balance-windows
    "wc" 'whitespace-cleanup
    "wg" 'golden-ratio-mode
    "wk" 'kill-buffer-and-window
    "wm" 'toggle-window-maximized
    "wt" 'toggle-frame-alpha
    "ww" 'ace-window
    )
  )


(provide '01-evil)
;;; 01-evil.el ends here
