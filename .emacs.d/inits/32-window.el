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
        '(:select t :align t :popup t :inhibit-window-quit nil :size 0.5))
  (setq shackle-default-alignment 'below)
  (setq shackle-rules nil)
  (setq shackle-rules
        '((org-mode :fra:align right :size 0.5)
          (pdf-outline-buffer-mode :size 0.4 :align right)
          (twittering-mode :size 0.5 :align right :select t)
          ;; ("\\`\\*helm.*?\\*\\'" :regexp t :align t :size 0.4)
          (comint-mode :size 0.3 :select nil :align bottom :popup t :inhibit-window-quit nil)
          ("*Backtrace*" :regexp t :popup t :size 0.3 :inhibit-window-quit t :align t)
          (help-mode :select t :popup t :size 0.4 :inhibit-window-quit t :align t)
          ("\\`\\*magit-.*-popup\\*\\'" :align right :size 0.5)
          (magit-revision-mode :popup nil :inhibit-window-quit nil :same t)
          (magit-status-mode :custom shackle-full-screen)
          (magit-log-mode :custom shackle-full-screen)
          (magit-log-select-mode :align right :size 0.5)
          (magit-diff-mode :align right :size 0.5)
          (magit-process-mode :custom shackle-full-screen)
          ;; ("COMMIT_EDITMSG" :regexp t :custom shackle-full-screen)
          ;; ("\\`\\*magit-.*?:.*?[^\\*]\\'" :regexp t :align right :size 0.5)
          ;; ("\\`\\*magit:.*?[^\\*]\\'" :regexp t :custom shackle-full-screen)
          ;; ("\\`\\*magit.*?\\*\\'" :regexp t :align t :size 0.5)
          (inf-ruby-mode :align t :size 0.4)
          ("\\`\\*projectile-rails.*?\\*\\'"
           :regexp t :select nil :align t :size 0.4)
          (slack-mode :align t :size 0.5 :select t)
          (slack-edit-message-mode :align t :size 0.2 :select t)
          (eww-mode :same t :inhibit-window-quit t)))
  (add-hook 'after-init-hook 'shackle-mode))

(el-get-bundle seudut/perspeen)
(el-get-bundle jimo1001/helm-perspeen)
(use-package perspeen
  :commands (perspeen-mode)
  :init
  (setq perspeen-use-tab t)
  (setq perspeen-workspace-default-name "emacs")
  (add-hook 'evil-mode-hook 'perspeen-mode)
  :config
  (use-package helm-perspeen
    :config

    (define-key helm-perspeen-workspaces-map
      (kbd "C-d")
      '(lambda () (interactive) (helm-exit-and-execute-action 'helm-perspeen--kill-workspace)))
    (define-key helm-perspeen-workspaces-map
      (kbd "C-r")
      '(lambda () (interactive) (helm-exit-and-execute-action 'helm-perspeen--rename-workspace)))
    (define-key helm-perspeen-tabs-map
      (kbd "C-d")
      '(lambda () (interactive) (helm-exit-and-execute-action 'helm-perspeen--kill-tab)))

    (setq helm-source-perspeen-create-tab nil)
    (setq helm-source-perspeen-create-tab
          (helm-build-dummy-source
              "Create perspeen tab"
            :action (helm-make-actions
                     "Create Tab (perspeen)"
                     (lambda (candidate)
                       (perspeen-tab-create-tab) nil))))

    (setq my-helm-source-perspeen-create-workspace
          (helm-build-dummy-source
              "Create perspeen workspace"
            :action (helm-make-actions
                     "Create Workspace (perspeen)"
                     #'helm-source--perspeen-create-workspace)))

    (defun helm-source--perspeen-create-workspace (candidate)
      (perspeen-create-ws)
      (perspeen-rename-ws candidate)
      (let ((projects (projectile-relevant-known-projects)))
        (when projects
          (projectile-completing-read
           "Switch to project: " projects
           :action (lambda (project)
                     (projectile-switch-project-by-name project))
           :initial-input candidate)))
      nil)

    (defun helm-perspeen ()
      "Display workspaces (perspeen.el) with helm interface."
      (interactive)
      (helm '(helm-source-perspeen-tabs
              helm-source-perspeen-workspaces
              ;; helm-source-perspeen-create-tab
              my-helm-source-perspeen-create-workspace))))
  (add-to-list 'helm-mini-default-sources 'helm-source-perspeen-tabs)
  (defun my-perspeen-set-ws-root-dir (project-to-switch &optional arg)
    (perspeen-change-root-dir project-to-switch))
  (advice-add 'projectile-switch-project-by-name :after 'my-perspeen-set-ws-root-dir)

  (defun perspeen-tab-advice-after-evil-window (_)
    (perspeen-tab--update-current-buffer))

  (dolist (fun '(evil-window-up
                 evil-window-bottom
                 evil-window-left
                 evil-window-right))
    ;; (advice-remove fun 'perspeen-tab--update-current-buffer)
    (advice-add fun :after 'perspeen-tab-advice-after-evil-window)
    )
  (advice-add 'evil-window-delete :after 'perspeen-tab--update-current-buffer)

  (define-key evil-normal-state-map "T" nil)
  (define-key evil-normal-state-map "Tt" 'perspeen-create-ws)
  (define-key evil-normal-state-map "Tn" 'perspeen-next-ws)
  (define-key evil-normal-state-map "Tp" 'perspeen-previous-ws)
  (define-key evil-normal-state-map "Tl" 'perspeen-goto-last-ws)
  (define-key evil-normal-state-map "Tg" 'perspeen-goto-ws)
  (define-key evil-normal-state-map "Ts" 'perspeen-ws-eshell)
  (define-key evil-normal-state-map "Tk" 'perspeen-delete-ws)
  (define-key evil-normal-state-map "Ts" 'perspeen-ws-eshell)
  (define-key evil-normal-state-map "Tr" 'perspeen-rename-ws)
  (define-key evil-normal-state-map "Tj" 'perspeen-go-ws)
  (define-key evil-normal-state-map "Td" 'perspeen-change-root-dir)

  (define-key evil-normal-state-map "tt" 'helm-perspeen)
  (define-key evil-normal-state-map "to" 'perspeen-tab-create-tab)
  (define-key evil-normal-state-map "tk" 'perspeen-tab-del)
  (define-key evil-normal-state-map "tn" 'perspeen-tab-next)
  (define-key evil-normal-state-map "tp" 'perspeen-tab-prev)
  )

(provide '32-window)
;;; 32-window.el ends here
