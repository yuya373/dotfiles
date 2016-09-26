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

  (setq skk-jisyo "~/.skk-jisyo"
        skk-jisyo-code 'utf-8
        skk-share-private-jisyo t
        skk-save-jisyo-instantly t
        )
  (setq skk-egg-like-newline t
        skk-auto-insert-paren t
        skk-show-annotation t
        skk-annotation-show-wikipedia-url t
        skk-use-look t
        )
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
  (use-package ccc)
  (use-package skk-hint)
  (use-package skk-cus)
  (use-package skk-macs)
  (use-package skk-cursor)
  (use-package skk-server-completion)
  (use-package skk-kcode)
  (use-package skk-annotation)
  (use-package skk-study)
  (use-package skk-cdb)
  (use-package skk-num)
  ;; (define-key skk-j-mode-map (kbd "C-h") 'skk-delete-backward-char)
  ;; (evil-make-intercept-map skk-j-mode-map 'insert)
  ;; @@ server completion
  (add-to-list 'skk-search-prog-list
               '(skk-server-completion-search) t)
  (add-to-list 'skk-completion-prog-list
               '(skk-comp-by-server-completion) t)
  (evil-define-key 'insert skk-j-mode-map
    "\C-h" #'skk-delete-backward-char)
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



(provide '33-input)
;;; 33-input.el ends here
