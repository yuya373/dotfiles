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
  (require 'evil))

(use-package golden-ratio
  :ensure t
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


(use-package shackle
  :ensure t
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
  (defun shackle-new-tab (buffer alist plist)
    (perspeen-tab-create-tab buffer 0))
  (setq shackle-default-rule nil)
  (setq shackle-default-alignment 'below)
  (setq shackle-rules nil)
  (setq shackle-rule-bottom '(:align bottom :select nil :size 0.4 :popup t))
  (setq shackle-rule-right-half '(:align right :select nil :size 0.4 :popup t))
  (setq shackle-rule-bottom-wide '(:align bottom :select nil :size 0.6 :popup t))
  (setq shackle-rule-ignore '(:ignore t))
  (setq shackle-rules
        (append (mapcar (lambda (l) (append l shackle-rule-ignore))
                        '(("\\`\\*flycheck-eslint-fix" :regexp t)))
                (mapcar (lambda (l) (append l shackle-rule-bottom-wide))
                        '(((slack-message-buffer-mode
                            slack-search-result-buffer-mode)
                           :select t)))

                (mapcar (lambda (l) (append l shackle-rule-bottom))
                        '((timer-list-mode)
                          (flycheck-error-list-mode)
                          (ert-results-mode)
                          ("\\`\\*quickrun\\*\\'" :regexp t :select t)
                          ("\\`\\*Org.*Export\\*\\'" :regexp t)
                          ("\\`\\*HTTP\sResponse\\*\\'" :regexp t)
                          (twittering-mode)
                          (inf-ruby-mode)
                          (rspec-compilation-mode)
                          (ensime-inf-mode)
                          (("\\`\\*eshell\\*\\(<.*>\\)?\\'") :regexp t :select t)
                          ("\\`\\*websocket\s.*\sdebug\\*\\'" :regexp t)

                          (cargo-process-mode :select t)
                          (racer-help-mode :select t)

                          (compilation-mode)
                          (godoc-mode)
                          (tide-project-errors-mode)
                          ("\\`\\*tide-documentation\\*\\'" :regexp t :select t)
                          ("\\`\\*lsp-help\\*\\'" :regexp t :select t)

                          ("\\`\\*Codic Result\\*\\'" :regexp t)

                          ((slack-edit-file-comment-buffer-mode
                            slack-message-compose-buffer-mode
                            slack-message-edit-buffer-mode
                            slack-message-share-buffer-mode)
                           :select t :size 0.3)
                          (rustic-format-mode)
                          (rustic-compilation-mode)
                          (rustic-cargo-test-mode)
                          (occur-mode)
                          (apropos-mode :select t)
                          (ag-mode :select t)
                          (consult-typescript-compilation-mode)
                          ("\\`\\*Claude.*\\*\\'" :regexp t :select t)
                          ))
                (mapcar (lambda (l) (append l shackle-rule-right-half))
                        '(((woman-mode
                            slack-message-attachment-preview-buffer-mode))
                          (("\\`\\*vterm.*\\*\\'") :regexp t :select t)
                          ((slack-file-list-buffer-mode
                            slack-all-threads-buffer-mode
                            slack-thread-message-buffer-mode
                            slack-user-profile-buffer-mode
                            slack-stars-buffer-mode
                            slack-pinned-items-buffer-mode
                            slack-dialog-buffer-mode
                            slack-dialog-edit-element-buffer-mode)
                           :select t)))

                '((slack-file-info-buffer-mode :custom shackle-new-tab)
                  ;; (slack-message-attachment-preview-buffer-mode :align right :size 0.4 :popup t :select nil)
                  ("\\`\\*Slack\sEvent\sLog" :regexp t :custom shackle-new-tab)
                  ("\\`\\*Slack\sLog" :regexp t :custom shackle-new-tab)
                  (tuareg-interactive-mode :align t :select t :size 0.4 :popup t)
                  ("\\`\\*eww\\*" :regexp t :align right :size 0.5 :select t :popup t)
                  (eww-bookmark-mode :align t :size 0.5 :popup t)
                  (org-mode :align right :size 0.5)
                  (pdf-outline-buffer-mode :size 0.4 :align right)
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

                  ("\\`\\*projectile-rails.*?\\*\\'" :regexp t :select nil :align t :size 0.4)
                  (slack-mode :align t :size 0.5 :select t)
                  (slack-thread-mode :align t :size 0.5 :select t)
                  (slack-edit-message-mode :align t :size 0.2 :select t))
                )
        )
  (add-hook 'after-init-hook 'shackle-mode))

(provide '32-window)
;;; 32-window.el ends here
