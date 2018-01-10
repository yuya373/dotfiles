;;; 24-toy.el ---                                    -*- lexical-binding: t; -*-

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

;; (el-get-bundle hackernews)
;; (use-package hackernews
;;   :commands (hackernews))

(el-get-bundle twittering-mode)
(use-package twittering-mode
  :commands (twit twittering-buffer-p)
  :init
  (add-hook 'twittering-mode-hook #'(lambda () (twittering-icon-mode 1)
                                      (twittering-activate-buffer)))
  (setq twittering-use-master-password t
        twittering-timer-interval 60
        twittering-fill-column 80)
  (defun twa ()
    (interactive)
    (let ((buf (or (cl-find-if #'(lambda (b) (twittering-buffer-p b))
                               (buffer-list))
                   (let ((new-buf (generate-new-buffer "*twa*")))
                     (with-current-buffer new-buf
                       (twit))
                     new-buf))))
      (display-buffer buf)))

  (defun twit-another-buffer ()
    (interactive)
    (let ((evil-vsplit-window-right t)
          (evil-auto-balance-windows t))
      (evil-window-vsplit))
    (twit))

  (defun twit-get-user-name (twit)
    (cdr (or (cl-assoc 'user-name twit)
             (cl-assoc 'user-screen-name twit))))
  (defun twit-get-text (twit)
    (cdr (cl-assoc 'text twit)))
  (defun twit-alert ()
    (mapc #'(lambda (e)
              (alert (twit-get-text e)
                     :title (format "Tweet: %s" (twit-get-user-name e))))
          (reverse twittering-rendered-new-tweets)))
  (add-hook 'twittering-new-tweets-rendered-hook 'twit-alert)
  :config

  (defun tw-active-buffer-list ()
    (interactive)
    (message "%s" (twittering-get-active-buffer-list)))

  (evil-set-initial-state 'twittering-mode 'normal)
  (evil-define-key 'normal twittering-mode-map
    "q" 'twittering-kill-buffer
    ",T" 'twittering-visit-timeline
    ",tf" 'twittering-friends-timeline
    ",tr" 'twittering-replies-timeline
    ",tu" 'twittering-user-timeline
    ",td" 'twittering-direct-messages-timeline
    ",r" 'twittering-current-timeline
    ",su" 'twittering-view-user-page
    ",sr" 'twittering-toggle-show-replied-statuses
    ",st" 'twittering-other-user-timeline
    ",o" 'twittering-enter
    ",mr" 'twittering-retweet
    ",mn" 'twittering-update-status-interactive
    ",md" 'twittering-direct-message
    ",mf" 'twittering-favorite
    ",mF" 'twittering-unfavorite
    ",ta" 'twittering-toggle-activate-buffer
    ",ti" 'twittering-icon-mode
    ",ts" 'twittering-scroll-mode
    ",l" 'twittering-other-user-list-interactive
    (kbd "RET") 'twittering-enter))

;; (el-get-bundle wanderlust)
;; (use-package wl
;;   :commands (wl wl-draft)
;;   :init
;;   ;; You should set this variable if you use multiple e-mail addresses.
;;   (setq wl-user-mail-address-list (quote ("yuya373@me.com" "yuya.minami@rebase.co.jp" "roooooooooolling@gmail.com")))
;;   (setq elmo-imap4-default-stream-type 'ssl)
;;   ;;for non ascii-characters in folder-names
;;   (setq elmo-imap4-use-modified-utf7 t)
;;   (setq wl-smtp-connection-type 'starttls)
;;   ;; mark sent messages as read (sent messages get sent back to you and
;;   ;; placed in the folder specified by wl-fcc)
;;   (setq wl-fcc-force-as-read t

;;         ;;for when auto-compleating foldernames
;;         wl-default-spec "%")
;;   (setq mime-view-type-subtype-score-alist
;;         '(((text . plain) . 4)
;;           ((text . enriched) . 3)
;;           ((text . html) . 2)
;;           ((text . richtext) . 1)))
;;   ;; ignore  all fields
;;   (setq wl-message-ignored-field-list '("^.*:"))

;;   ;; ..but these five
;;   (setq wl-message-visible-field-list
;;         '("^To:"
;;           "^Cc:"
;;           "^From:"
;;           "^Subject:"
;;           "^Date:"))
;;   (setq wl-draft-config-alist
;;         '(((string-match "me.com" wl-draft-parent-folder)
;;            (template . "me.com")
;;            (wl-smtp-posting-user . "yuya373@me.com")
;;            (wl-smtp-posting-server . "smtp.mail.me.com")
;;            (wl-local-domain . "me.com")
;;            (wl-smtp-authenticate-type ."plain")
;;            (wl-smtp-posting-port . 587)
;;            (wl-smtp-connection-type . 'starttls))
;;           ((string-match "rebase.co.jp" wl-draft-parent-folder)
;;            (template . "rebase.co.jp")
;;            (wl-smtp-posting-user . "yuya.minami")
;;            (wl-smtp-posting-server . "smtp.gmail.com")
;;            (wl-smtp-authenticate-type ."plain")
;;            (wl-smtp-posting-port . 465)
;;            (wl-local-domain . "gmail.com")
;;            (wl-smtp-connection-type . 'ssl))
;;           ((string-match "gmail.com" wl-draft-parent-folder)
;;            (template . "gmail.com")
;;            (wl-smtp-posting-user . "roooooooooo")
;;            (wl-smtp-posting-server . "smtp.gmail.com")
;;            (wl-smtp-authenticate-type ."plain")
;;            (wl-smtp-posting-port . 465)
;;            (wl-local-domain . "gmail.com")
;;            (wl-smtp-connection-type . 'ssl))))

;;   (setq wl-template-alist
;;         '(("me.com"
;;            (wl-from . "南 優也 <yuya373@me.com>")
;;            ("From" . wl-from))
;;           ("rebase"
;;            (wl-from . "南 優也 <yuya.minami@rebase.co.jp>")
;;            ("From" . wl-from))
;;           ("gmail"
;;            (wl-from . "南 優也 <roooooooooolling@gmail.com>")
;;            ("From" . wl-from))))

;;   (setq mime-preview-situation-example-list
;;         '((((*body . visible)
;;             (body-presentation-method . mime-display-text/html)
;;             (body . invisible)
;;             (encoding . "base64")
;;             (disposition-type . inline)
;;             ("charset" . "UTF-8")
;;             (subtype . html)
;;             (type . text)
;;             (major-mode . wl-original-message-mode))
;;            . 0)
;;           (((*body . visible)
;;             (body-presentation-method . mime-display-text/html)
;;             (body . invisible)
;;             (encoding . "quoted-printable")
;;             ("charset" . "utf-8")
;;             (subtype . html)
;;             (type . text)
;;             (major-mode . wl-original-message-mode))
;;            . 0)
;;           (((*body . invisible)
;;             (*header . visible)
;;             (body-presentation-method . mime-display-text/html)
;;             (body . visible)
;;             (encoding . "8bit")
;;             ("charset" . "UTF-8")
;;             (subtype . html)
;;             (type . text)
;;             (entity-button . invisible)
;;             (header . visible)
;;             (major-mode . wl-original-message-mode))
;;            . 0)
;;           (((*header . visible)
;;             (body-presentation-method . mime-display-text/html)
;;             (body . visible)
;;             (encoding . "8bit")
;;             ("charset" . "UTF-8")
;;             (subtype . html)
;;             (type . text)
;;             (entity-button . invisible)
;;             (header . visible)
;;             (major-mode . wl-original-message-mode))
;;            . 2)))

;;   (setq mime-acting-situation-example-list
;;         '((((type . text)
;;             (mode . "extract")
;;             (method . wl-mime-save-content)
;;             (major-mode . wl-original-message-mode)
;;             ("charset" . "utf-8"))
;;            . 0)
;;           (((type . text)
;;             (subtype . plain)
;;             (mode . "extract")
;;             (method . wl-mime-save-content)
;;             (major-mode . wl-original-message-mode)
;;             (body . visible)
;;             (body-presentation-method . wl-mime-display-text/plain)
;;             (encoding . "7bit")
;;             ("charset" . "utf-8"))
;;            . 1)))
;;   (let ((folders "~/.folders"))
;;     (unless (file-exists-p folders)
;;       (with-temp-buffer
;;         (insert "%inbox  \"Inbox\"\n%Sent   \"Sent\"\n")
;;         (insert "%Trash  \"Trash\"\n%Junk   \"Junk\"\n")
;;         (insert "+draft  \"Draft\"")
;;         (write-region (point-min) (point-max) folders))))
;;   :config
;;   (evil-define-key 'normal wl-news-mode-map
;;     ",q" 'wl-news-exit
;;     ",Q" 'wl-news-force-exit
;;     ",a" 'wl-news-show-all
;;     ",n" 'outline-next-visible-heading
;;     ",p" 'outline-previous-visible-heading)
;;   (evil-define-key 'visual wl-folder-mode-map
;;     ",s" 'wl-folder-sync-region)
;;   (evil-define-key 'normal wl-folder-mode-map
;;     ",q" 'wl-exit
;;     ",w" 'wl-draft
;;     ",C" 'wl-folder-check-all
;;     ",c" 'wl-folder-check-current-entity
;;     ",s" 'wl-folder-sync-current-entity
;;     ",?" 'wl-folder-pick
;;     "\C-i" 'wl-folder-open-close
;;     "\C-m" 'wl-folder-jump-to-current-entity)
;;   (defun wl-summary-exit-virtual ()
;;     (interactive)
;;     (wl-summary-virtual t))
;;   (defun wl-summary-enter-handler-reverse ()
;;     (interactive)
;;     (wl-summary-enter-handler t))
;;   (evil-define-key 'normal wl-summary-mode-map
;;     "\C-p" 'wl-summary-enter-handler-reverse
;;     "\C-n" 'wl-summary-enter-handler
;;     "\C-m" 'wl-summary-enter-handler
;;     "\C-i" 'wl-summary-toggle-disp-msg
;;     "q" 'wl-summary-exit
;;     ",j" 'wl-summary-jump-to-current-message
;;     ",d" 'wl-summary-delete
;;     ",ta" 'wl-thread-open-all
;;     ",g" 'wl-summary-goto-folder
;;     ",r"'wl-summary-reply-with-citation
;;     ",R" 'wl-summary-reply
;;     ",n" 'wl-summary-next
;;     ",p" 'wl-summary-prev
;;     ",mk" 'wl-summary-unmark
;;     ",mK" 'wl-summary-unmark-all
;;     ",mi" 'wl-summary-mark-as-important
;;     ",mr" 'wl-summary-mark-as-read
;;     ",mR" 'wl-summary-mark-as-read-all
;;     ",mu" 'wl-summary-mark-as-unread
;;     ",tt" 'wl-summary-toggle-thread
;;     ",th" 'wl-summary-toggle-all-header
;;     ",tm" 'wl-summary-toggle-mime-buttons
;;     ",B" 'wl-summary-burst
;;     ",vk" 'wl-summary-exit-virtual
;;     ",vv" 'wl-summary-virtual
;;     ",p" 'wl-summary-pick
;;     ",e" 'wl-summary-expire
;;     ",ss" 'wl-summary-sync
;;     ",sm" 'wl-summary-sync-marks
;;     ",su" 'wl-summary-sync-update
;;     ",c" 'wl-summary-exec)
;;   (evil-define-key 'normal mime-view-mode-map
;;     "C-k" 'mime-preview-move-to-previous
;;     "C-j" 'mime-preview-move-to-next
;;     ",p" 'mime-preview-move-to-previous
;;     ",n" 'mime-preview-move-to-next
;;     ",th" 'mime-preview-toggle-header
;;     ",tc" 'mime-preview-toggle-content))

(el-get-bundle easy-hugo)
(use-package easy-hugo
  :commands (easy-hugo easy-hugo-newpost easy-hugo-github-deploy)
  :init
  (setq easy-hugo-postdir "content/posts")
  (setq easy-hugo-basedir "~/dev/blog/")
  (defun easy-hugo-list-posts ()
    (interactive)
    (helm-find-files-1 (expand-file-name
                        (format "%s%s/"
                                easy-hugo-basedir
                                easy-hugo-postdir))))
  (defun easy-hugo-newpost-today  ()
    (interactive)
    (let ((format "%Y_%m_%d"))
      (easy-hugo-newpost
       (format "%s.md"
               (format-time-string format))))))


(provide '24-toy)
;;; 24-toy.el ends here
