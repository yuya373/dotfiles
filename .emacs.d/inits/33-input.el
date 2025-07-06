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

(use-package ddskk :ensure t)
(use-package skk
  :ensure ddskk
  :init
  (setq skk-echo t)
  (setq define-input-method "japanese-skk")

  (setq skk-egg-like-newline t
        skk-auto-insert-paren t
        skk-show-annotation t
        skk-use-look t
        skk-look-recursive-search t
        )
  (setq skk-show-tooltip nil
        skk-show-inline nil
        skk-show-candidates-always-pop-to-buffer nil
        skk-show-mode-show nil
        skk-show-icon nil
        )
  (setq skk-dcomp-activate t
        skk-dcomp-multiple-activate t
        skk-dcomp-multiple-rows 10
        skk-previous-completion-use-backtab t)
  (setq skk-comp-use-prefix t
        skk-comp-circulate t)
  (setq skk-sticky-key ";")
  (setq skk-previous-candidate-keys (list "x" "\C-p"))
  (setq skk-isearch-mode-enable t)
  (setq skk-check-okurigana-on-touroku 'auto)
  (setq skk-use-numeric-conversion t)
  (setq skk-show-candidates-nth-henkan-char 2)
  (setq skk-henkan-number-to-display-candidates 10)

  ;; skk-server
  ;; ~/dotfiles/start_yaskkserv.sh
  (setq skk-server-portnum 1178
        skk-server-host "0.0.0.0"
        skk-server-report-response t)

  (setq
   ;; skk-jisyo "~/Dropbox/skk-jisyo.ddskk"
   skk-share-private-jisyo nil
   skk-save-jisyo-instantly t
   )

  (setq skk-japanese-message-and-error t
        skk-show-japanese-menu t)

  (defun enable-skk-when-insert ()
    (unless (bound-and-true-p skk-mode)
      (skk-mode 1)
      (skk-latin-mode 1)))
  (add-hook 'evil-insert-state-entry-hook 'enable-skk-when-insert)
  :config
  (defun skk-isearch-setup-maybe ()
    (require 'skk-vars)
    (when (or (eq skk-isearch-mode-enable 'always)
              (and (boundp 'skk-mode)
                   skk-mode
                   skk-isearch-mode-enable))
      (skk-isearch-mode-setup)))
  (defun skk-isearch-cleanup-maybe ()
    (require 'skk-vars)
    (when (and (featurep 'skk-isearch)
               skk-isearch-mode-enable)
      (skk-isearch-mode-cleanup)))
  (add-hook 'isearch-mode-hook #'skk-isearch-setup-maybe)
  (add-hook 'isearch-mode-end-hook #'skk-isearch-cleanup-maybe)
  (define-key minibuffer-local-map (kbd "C-j") 'skk-j-mode-on)

  ;; @@ server completion
  (add-to-list 'skk-search-prog-list
               '(skk-server-completion-search))
  (add-to-list 'skk-completion-prog-list
               '(skk-comp-by-server-completion))

  (skk-setup-emulation-commands '(evil-delete-backward-char)
                                'skk-delete-backward-char)

  (defun evil-ensure-skk-latin-in-normal-mode ()
    (if (bound-and-true-p skk-mode)
        (skk-latin-mode 1)))
  (add-hook 'evil-normal-state-entry-hook 'evil-ensure-skk-latin-in-normal-mode)

  ;; SKKの未確定状態(skk-henkan-mode)ではない場合だけ, 検索パターンをアップデート
  (defun around-evil-ex-search-update-pattern-skk (orig-fun &rest args)
    (unless (bound-and-true-p skk-henkan-mode)
      (apply orig-fun args)))
  (advice-add 'evil-ex-search-update-pattern :around 'around-evil-ex-search-update-pattern-skk)
  (with-eval-after-load "markdown"
    (skk-wrap-newline-command markdown-enter-key)))

(provide '33-input)
;;; 33-input.el ends here
