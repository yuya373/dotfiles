;;; 22-document.el ---                                    -*- lexical-binding: t; -*-

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
  (require 'evil)
  (el-get-bundle pdf-tools)
  (require 'pdf-tools))

(el-get-bundle pdf-tools)
(use-package pdf-tools
  :commands (pdf-tools-install)
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :init
  (add-hook 'pdf-view-mode-hook #'(lambda () (linum-mode -1)))
  (add-hook 'pdf-view-mode-hook 'pdf-view-dark-minor-mode)
  (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
  (add-hook 'pdf-view-mode-hook #'(lambda () (blink-cursor-mode -1)))
  (setq pdf-view-dump-file-name "pdf-view-dump")
  :config
  (defun pdf-view-dump-last-page ()
    (interactive)
    (let ((current-page (pdf-view-current-page)))
      (when (and current-page (< 1 current-page))
        (message "pdf-view-dump-last-page: %s" current-page)
        (let* ((file-path (concat user-emacs-directory
                                  pdf-view-dump-file-name))
               (pdf-file-name (pdf-view-buffer-file-name))
               (old-data (pdf-view-read-dumped file-path))
               (data (cons (cons pdf-file-name current-page)
                           (cl-delete-if #'(lambda (n)
                                             (string= n pdf-file-name))
                                         old-data
                                         :key #'car))))
          (with-temp-buffer
            (insert (format "%s" data))
            (write-region (point-min) (point-max) file-path))))))

  (defun pdf-view-read-dumped (file-path)
    (when (file-readable-p file-path)
      (with-temp-buffer
        (insert-file-contents file-path)
        (when (> (length (buffer-string)) 0)
          (read (buffer-string))))))

  (defun pdf-view-find-last-page ()
    (let* ((pdf-file-name (pdf-view-buffer-file-name))
           (file-path (concat user-emacs-directory
                              pdf-view-dump-file-name))
           (data (pdf-view-read-dumped file-path)))
      (cdr (cl-assoc pdf-file-name data :test #'string=))))

  (defun pdf-view-restore-last-page ()
    (interactive)
    (let ((last-page (pdf-view-find-last-page)))
      (if (and last-page (y-or-n-p "Restore previous page? "))
          (pdf-view-goto-page last-page))))

  (defun pdf-view-restore-or-dump-page ()
    (interactive)
    (if (= 1 (pdf-view-current-page))
        (pdf-view-restore-last-page)
      (pdf-view-dump-last-page)))

  (add-hook 'pdf-view-after-change-page-hook 'pdf-view-restore-or-dump-page)
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-define-key 'normal pdf-view-mode-map
    "g" 'pdf-view-goto-page
    "j" 'pdf-view-scroll-up-or-next-page
    "k" 'pdf-view-scroll-down-or-previous-page
    "h" 'left-char
    "l" 'right-char
    "d" 'pdf-view-next-page-command
    "u" 'pdf-view-previous-page-command
    "+" 'pdf-view-enlarge
    "-" 'pdf-view-shrink
    "=" 'pdf-view-fit-width-to-window
    "o" 'pdf-outline
    "b" 'pdf-view-position-to-register
    "B" 'pdf-view-jump-to-register
    ",r" 'pdf-view-restore-last-page
    ",s" 'pdf-view-dump-last-page)
  (defun mcc-pdf-view-save ()
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (when (eql major-mode 'pdf-view-mode)
                    (setq-local pdf-view-last-display-size
                                pdf-view-display-size)
                    (setq-local pdf-view-last-visited-page
                                (pdf-view-current-page))))))

  (defun mcc-pdf-view-restore ()
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (message "%s" major-mode)
                  (when (eql major-mode 'pdf-view-mode)
                    (message "restore page: %s"
                             pdf-view-last-visited-page)
                    (setf (pdf-view-current-page win)
                          pdf-view-last-visited-page)
                    (setq pdf-view-display-size
                          pdf-view-last-display-size)
                    (pdf-view-redisplay win)))))

  (add-hook 'popwin:before-popup-hook #'mcc-pdf-view-save)
  (add-hook 'popwin:after-popup-hook #'mcc-pdf-view-restore)
  ;; (add-hook 'helm-before-initialize-hook #'mcc-pdf-view-save t)
  ;; (remove-hook 'helm-before-initialize-hook #'mcc-pdf-view-save)
  ;; (add-hook 'helm-cleanup-hook #'mcc-pdf-view-restore t)
  ;; (remove-hook 'helm-cleanup-hook #'mcc-pdf-view-restore)
 ; (use-package pdf-annot)
  (use-package pdf-links)
  (use-package pdf-info)
  (use-package pdf-misc)
  (use-package pdf-sync)
  (use-package pdf-outline
    :config
    (evil-define-key 'normal pdf-outline-buffer-mode-map
      "o" 'pdf-outline-follow-link-and-quit
      "q" 'quit-window
      "c" 'pdf-outline-move-to-current-page
      "l" 'outline-toggle-children))
  (use-package pdf-occur))

(el-get-bundle adoc-mode)
(use-package adoc-mode
  :mode (("\\.asciidoc\\'" . adoc-mode))
  :init
  (add-hook 'adoc-mode-hook #'(lambda () (buffer-face-mode t))))

(provide '22-document)
;;; 22-document.el ends here
