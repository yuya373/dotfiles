;;; 32-window.el ---                                  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  南優也

;; Author: 南優也 <yuyaminami@minamiyuuya-no-MacBook.local>
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
  (require 'helm))

(el-get-bundle golden-ratio)
(use-package golden-ratio
  :commands (golden-ratio-mode)
  :diminish golden-ratio-mode
  :init
  ;; (add-hook 'after-init-hook 'golden-ratio-mode)
  (setq golden-ratio-extra-commands '(windmove-up
                                      windmove-down
                                      windmove-left
                                      windmove-right
                                      evil-window-up
                                      evil-window-down
                                      evil-window-left
                                      evil-window-right))
  (setq golden-ratio-auto-scale t)
  (setq golden-ratio-recenter t)
  ;; (setq golden-ratio-exclude-modes '(eww-mode
  ;;                                    pdf-view-mode
  ;;                                    ediff-mode
  ;;                                    comint-mode
  ;;                                    compilation-mode
  ;;                                    inf-ruby-mode
  ;;                                    slime-repl-mode))
  ;; (setq golden-ratio-exclude-buffer-names '("*compilation*"
  ;;                                           "*Flycheck errors*"
  ;;                                           "slime-apropos*"
  ;;                                           "*slime-description*"
  ;;                                           "*slime-compilation*"
  ;;                                           "*Proccess List*"
  ;;                                           "*LV*"
  ;;                                           "*Warnings*"))
  )


(el-get-bundle shackle)
(use-package shackle
  :commands (shackle-mode)
  :init
  (defun display-buffer-full-screen (buffer _alist)
    (delete-other-windows)
    ;; make sure the window isn't dedicated, otherwise
    ;; `set-window-buffer' throws an error
    (set-window-dedicated-p nil nil)
    (set-window-buffer nil buffer)
    ;; return buffer's window
    (get-buffer-window buffer))
  (defun shackle-full-screen (buffer alist _plist)
    (display-buffer-full-screen buffer alist))
  (setq shackle-default-rule
        '(:select t :align t :popup t :size 0.3 :inhibit-window-quit nil))
  (setq shackle-default-alignment 'below)
  (setq shackle-rules
        '(("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)
          ("COMMIT_EDITMSG" :regexp t :custom shackle-full-screen)
          ("\\`\\*magit-.*?:.*?[^\\*]\\'" :regexp t :align right :size 0.5)
          ("\\`\\*magit:.*?[^\\*]\\'" :regexp t :custom shackle-full-screen)
          ("\\`\\*magit.*?\\*\\'" :regexp t :align t :size 0.4)
          (inf-ruby-mode :align t :size 0.4)
          ("\\`\\*projectile-rails.*?\\*\\'"
           :regexp t :select nil :align t :size 0.4)
          (slack-mode :align t :size 0.4 :select t)
          (slack-edit-message-mode :align t :size 0.2 :select t)
          (eww-mode :same t :inhibit-window-quit t)))
  (add-hook 'after-init-hook 'shackle-mode))

(el-get-bundle seudut/perspeen)
(el-get-bundle jimo1001/helm-perspeen)
(use-package perspeen
  :commands (perspeen-mode)
  :init
  (setq perspeen-use-tab t)
  (add-hook 'evil-mode-hook 'perspeen-mode)
  :config
  (use-package helm-perspeen
    :config

    (setq helm-source-perspeen-create-tab nil)
    (setq helm-source-perspeen-create-tab
          (helm-build-dummy-source
              "Create perspeen tab"
            :action (helm-make-actions
                     "Create Tab (perspeen)"
                     (lambda (candidate)
                       (perspeen-tab-create-tab) nil))))

    (defun helm-perspeen ()
      "Display workspaces (perspeen.el) with helm interface."
      (interactive)
      (helm '(helm-source-perspeen-tabs
              helm-source-perspeen-workspaces
              helm-source-perspeen-create-tab
              helm-source-perspeen-create-workspace))))

  ;; (defface perspeen-tab--header-line-inactive
  ;;   '((t (:foreground "#586e75")))
  ;;   "Face of header-line inactive"
  ;;   :group 'perspeen)

  ;; (defface perspeen-tab--header-line-active
  ;;   '((t (:inherit mode-line)))
  ;;   "Face of header-line active"
  ;;   :group 'perspeen)

  ;; (perspeen-tab--set-header-line-format t)

  (defun perspeen-tab--set-header-line-format (&optional force)
    "Set the header line format.
Optional argument FORCE force or not to set the header line."
    (if force
        (setq header-line-format
              '(:eval
                (perspeen-tab--construct-header-line)))
      (setq-default header-line-format
                    '(:eval
                      (perspeen-tab--construct-header-line)))))

  (define-key evil-normal-state-map "tw" nil)
  (define-key evil-normal-state-map "tww" 'perspeen-create-ws)
  (define-key evil-normal-state-map "twn" 'perspeen-next-ws)
  (define-key evil-normal-state-map "twp" 'perspeen-previous-ws)
  (define-key evil-normal-state-map "twl" 'perspeen-goto-last-ws)
  (define-key evil-normal-state-map "twg" 'perspeen-goto-ws)
  (define-key evil-normal-state-map "tws" 'perspeen-ws-eshell)
  (define-key evil-normal-state-map "twk" 'perspeen-delete-ws)
  (define-key evil-normal-state-map "tws" 'perspeen-ws-eshell)
  (define-key evil-normal-state-map "twr" 'perspeen-rename-ws)
  (define-key evil-normal-state-map "twj" 'perspeen-go-ws)
  (define-key evil-normal-state-map "twd" 'perspeen-change-root-dir)

  (define-key evil-normal-state-map "tt" 'helm-perspeen)
  (define-key evil-normal-state-map "to" 'perspeen-tab-create-tab)
  (define-key evil-normal-state-map "tk" 'perspeen-tab-del)
  (define-key evil-normal-state-map "tn" 'perspeen-tab-next)
  (define-key evil-normal-state-map "tp" 'perspeen-tab-prev)
  )
;; (el-get-bundle Bad-ptr/persp-mode.el
;;   :name persp-mode)
;; (use-package persp-mode
;;   :commands (persp-mode)
;;   :init
;;   (add-hook 'evil-mode-hook 'persp-mode)
;;   :preface
;;   (defvar persp-buffer-list-ordering-index nil)

;;   (defun build-persp-buffer-list-ordering-index ()
;;     (setq persp-buffer-list-ordering-index (make-hash-table))
;;     (let ((n 0))
;;       (mapc #'(lambda (b)
;;                 (puthash (buffer-name b) n persp-buffer-list-ordering-index)
;;                 (setq n (1+ n)))
;;             (funcall persp-buffer-list-function))))

;;   (defun persp-emacs-buffers-ordering-cmp (b bb)
;;     (unless persp-buffer-list-ordering-index
;;       (build-persp-buffer-list-ordering-index))
;;     (let ((b-i (gethash (buffer-name b) persp-buffer-list-ordering-index 1000000))
;;           (bb-i (gethash (buffer-name bb) persp-buffer-list-ordering-index 1000001)))
;;       (< b-i bb-i)))
;;   :config
;;   (setq persp-nil-name "####"
;;         persp-autokill-buffer-on-remove t
;;         persp-auto-save-opt 2
;;         persp-when-kill-switch-to-buffer-in-perspective t
;;         persp-kill-foreign-buffer-action 'kill
;;         )

;;   (add-to-list 'load-path (expand-file-name "~/dev/persp-tab-mode"))

;;   (use-package persp-tab-mode
;;     :config
;;     (persp-tab-start))
;;   ;; (add-hook 'find-file-hook 'persp-update-all-header-line t)
;;   ;; (remove-hook 'find-file-hook 'persp-update-all-header-line)
;;   ;; (add-hook 'kill-buffer-hook 'persp-update-all-header-line t)
;;   ;; (remove-hook 'kill-buffer-hook 'persp-update-all-header-line)
;;   ;; (remove-hook 'post-command-hook 'persp-update-header-line)
;;   ;; (advice-remove 'persp-next 'persp-enable-update-header-line)
;;   ;; (advice-remove 'persp-prev 'persp-enable-update-header-line)

;;   (defun persp-save-eww-buffer (buf)
;;     (with-current-buffer buf
;;       (when (string= major-mode "eww-mode")
;;         `(def-eww-buffer ,default-directory ,(eww-current-url) ,(point)))))

;;   (defun persp-load-eww-buffer (savelist)
;;     (when (eq (car savelist) 'def-eww-buffer)
;;       (let ((default-directory (cadr savelist))
;;             (buf (eww (caddr savelist))))
;;         (with-current-buffer buf
;;           (setq-local default-directory default-directory)
;;           (goto-char (cadddr savelist))
;;           (bury-buffer))
;;         buf)))

;;   (add-to-list 'persp-save-buffer-functions 'persp-save-eww-buffer)
;;   (add-to-list 'persp-load-buffer-functions 'persp-load-eww-buffer)

;;   (defun persp-helm-mini ()
;;     (interactive)
;;     (with-persp-buffer-list
;;      (:sortp (lambda (b bb)
;;                (persp-emacs-buffers-ordering-cmp b bb)))
;;      (build-persp-buffer-list-ordering-index)
;;      (helm-mini)))


;;   (defun persp-ignore-dired-buffer (b)
;;     (with-current-buffer b
;;       (string= major-mode "dired-mode")))

;;   (add-to-list 'persp-filter-save-buffers-functions #'persp-ignore-dired-buffer)

;;   ;; [spacemacs/funcs.el at master · syl20bnr/spacemacs](https://github.com/syl20bnr/spacemacs/blob/master/layers/%2Bspacemacs/spacemacs-layouts/funcs.el)

;;   (defun helm-perspectives-source ()
;;     (helm-build-in-buffer-source
;;         (concat "Current Perspective: " (safe-persp-name (get-frame-persp)))
;;       :data (persp-names)
;;       :fuzzy-match t
;;       :action
;;       '(("Switch to perspective" . persp-switch)
;;         ("Close perspective(s)" . (lambda (candidate)
;;                                     (mapcar
;;                                      'persp-kill-without-buffers
;;                                      (helm-marked-candidates))))
;;         ("Kill perspective(s)" . (lambda (candidate)
;;                                    (mapcar 'persp-kill
;;                                            (helm-marked-candidates)))))))

;;   (defun helm-perspectives ()
;;     "Control Panel for perspectives. Has many actions.
;;   If match is found
;;   f1: (default) Select perspective
;;   f2: Close Perspective(s) <- mark with C-SPC to close more than one-window
;;   f3: Kill Perspective(s)
;;   If match is not found
;;   <enter> Creates perspective
;;   Closing doesn't kill buffers inside the perspective while killing
;;   perspectives does."
;;     (interactive)
;;     (helm
;;      :buffer "*Helm Perspectives*"
;;      :sources
;;      `(,(helm-perspectives-source)
;;        ,(helm-build-dummy-source "Create new perspective"
;;           :requires-pattern t
;;           :action
;;           '(("Create new perspective" .
;;              (lambda (name)
;;                (let ((persp-reset-windows-on-nil-window-conf t))
;;                  (persp-switch name)
;;                  (switch-to-buffer "*GNU Emacs*")))))))))

;;   (with-eval-after-load "evil"
;;     (define-key evil-normal-state-map (kbd "tt") 'helm-perspectives)
;;     ;; (define-key evil-normal-state-map (kbd "tt") 'persp-switch)
;;     (define-key evil-normal-state-map (kbd "tR") 'persp-rename)
;;     (define-key evil-normal-state-map (kbd "tn") 'persp-next)
;;     (define-key evil-normal-state-map (kbd "tp") 'persp-prev)
;;     (define-key evil-normal-state-map (kbd "tk") 'persp-kill)
;;     (define-key evil-normal-state-map (kbd "ti") 'persp-import-buffers)
;;     (define-key evil-normal-state-map (kbd "ta") 'persp-add-buffer)
;;     (define-key evil-normal-state-map (kbd "tr") 'persp-remove-buffer)
;;     (define-key evil-normal-state-map (kbd "tw") 'persp-save-state-to-file)
;;     (define-key evil-normal-state-map (kbd "tl") 'persp-load-state-from-file)
;;     (define-key evil-normal-state-map (kbd "tb") 'persp-helm-mini)
;;     ;; (define-key evil-normal-state-map (kbd "\C-b") 'persp-helm-mini)
;;     ;; (define-key evil-normal-state-map (kbd "\C-B") 'helm-mini)
;;     )
;;   )

(provide '32-window)
;;; 32-window.el ends here
