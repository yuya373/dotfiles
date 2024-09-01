;;; 31-compilation.el ---                            -*- lexical-binding: t; -*-

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

(use-package compile
  :defer t
  :init
  (defun compile-finish-notify-alert (buffer msg)
    ;; (message "buffer: %s" buffer)
    ;; (message "msg: %s" msg)
    (alert msg :title (buffer-name buffer)))
  (add-to-list 'compilation-finish-functions 'compile-finish-notify-alert)

  ;; (defun compilation-apply-ansi-color ()
  ;;   (interactive)
  ;;   (let ((inhibit-read-only t))
  ;;     (ansi-color-apply-on-region (point-min)
  ;;                                 (point-max))))
  ;; (remove-hook 'compilation-filter-hook 'compilation-apply-ansi-color)

  (defvar my-ansi-escape-re
    (rx (or "(B"
            (: (or ?\233 (and ?\e ?\[))
               (zero-or-more (char (?0 . ?\?)))
               (zero-or-more (char ?\s ?- ?\/))
               (char (?@ . ?~))))))

  (defun my-nuke-ansi-escapes (beg end)
    (save-excursion
      (goto-char beg)
      (while (re-search-forward my-ansi-escape-re end t)
        (replace-match ""))))

  (defun compilation-filter-ansi ()
    (let ((inhibit-read-only t))
      (my-nuke-ansi-escapes (point-min)
                            (point-max))))
  (add-hook 'compilation-filter-hook 'compilation-filter-ansi)
  :config
  (setq compilation-max-output-line-length nil)
  (setq compilation-scroll-output t))

(provide '31-compilation)
;;; 31-compilation.el ends here
