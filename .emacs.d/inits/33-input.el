;;; 33-input.el ---                                  -*- lexical-binding: t; -*-

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

(el-get-bundle ddskk)
(use-package skk
  :commands (skk-mode skk-auto-fill-mode)
  :init
  (setq skk-echo t)
  (setq skk-tut-file (concat user-emacs-directory
                             "el-get/ddskk/etc/SKK.tut"))
  (setq define-input-method "japanese-skk")

  (setq skk-jisyo "~/Dropbox/skk-jisyo.ddskk"
        skk-jisyo-code nil
        skk-share-private-jisyo t
        skk-save-jisyo-instantly t
        )
  (setq skk-egg-like-newline t
        skk-auto-insert-paren t
        skk-show-annotation t
        skk-annotation-show-wikipedia-url t
        skk-use-look t
        skk-look-recursive-search t
        )
  (setq skk-show-tooltip nil
        skk-show-inline nil
        skk-show-candidates-always-pop-to-buffer nil
        skk-show-mode-show nil)
  (setq skk-dcomp-activate t
        skk-dcomp-multiple-activate t
        skk-dcomp-multiple-rows 10
        skk-previous-completion-use-backtab t)
  (setq skk-comp-use-prefix t
        skk-comp-circulate t)
  (setq skk-sticky-key ";")
  (setq skk-previous-candidate-keys (list "x" "\C-p"))
  (setq skk-isearch-mode-enable nil)
  (setq skk-check-okurigana-on-touroku 'auto)
  (setq skk-use-numeric-conversion t)

  ;; skk-server AquaSKK
  (setq skk-server-portnum 1178
        skk-server-host "0.0.0.0"
        skk-server-report-response t)
  (setq skk-large-jisyo "~/Dropbox/skk/dict/SKK-JISYO.L")
  (setq skk-itaiji-jisyo "~/Dropbox/skk/dict/SKK-JISYO.itaiji")
  ;; (setq skk-extra-jisyo-file-list '(
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.mazegaki"
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.station"
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.zipcode"
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.fullname"
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.geo"
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.jinmei"
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.law"
  ;;                                   "~/Dropbox/skk/dict/SKK-JISYO.propernoun"
  ;;                                   ))


  (setq skk-japanese-message-and-error t
        skk-show-japanese-menu t)
  (defun enable-skk-when-insert ()
    (unless (bound-and-true-p skk-mode)
      (skk-mode 1)
      (skk-latin-mode 1)))
  (add-hook 'evil-insert-state-entry-hook 'enable-skk-when-insert)
  ;; (add-hook 'skk-mode-hook
  ;;           #'(lambda ()
  ;;               (define-key skk-j-mode-map (kbd "C-h")
  ;;                 'skk-delete-backward-char)
  ;;               (evil-make-intercept-map skk-j-mode-map 'insert )))
  :config
  (defun skk-setup-modeline ()
    (setq skk-indicator-alist (skk-make-indicator-alist)))
  ;; (use-package skk-setup)
  (use-package ccc)
  (use-package skk-hint)
  (use-package skk-cus)
  (use-package skk-macs)
  (when window-system
    (use-package skk-cursor))
  (use-package skk-server-completion)
  (use-package skk-kcode)
  (use-package skk-annotation)
  (use-package skk-study)
  (use-package skk-cdb)
  (use-package skk-num)
  (use-package skk-dcomp)
  (use-package skk-look)
  (define-key skk-j-mode-map (kbd "C-h") 'skk-delete-backward-char)
  (define-key minibuffer-local-map (kbd "C-j") 'skk-j-mode-on)
  ;; @@ server completion
  (add-to-list 'skk-search-prog-list
               '(skk-server-completion-search) t)
  (add-to-list 'skk-completion-prog-list
               '(skk-comp-by-server-completion) t)

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
      ad-do-it))
  (with-eval-after-load "markdown"
    (skk-wrap-newline-command markdown-enter-key)))



(provide '33-input)
;;; 33-input.el ends here
