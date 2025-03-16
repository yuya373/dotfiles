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
  (require 'evil-leader))

(use-package adoc-mode
  :ensure t
  :mode (("\\.asciidoc\\'" . adoc-mode))
  :init
  (add-hook 'adoc-mode-hook #'(lambda () (buffer-face-mode t))))

(use-package csv-mode
  :ensure t
  :mode (("\\.csv\\'" . csv-mode))
  :config
  (evil-define-key 'normal csv-mode-map
    ",a" 'csv-align-fields))

(use-package open-junk-file
  :ensure t
  :commands (open-junk-dir open-junk-file open-junk-org-today)
  :config
  (if (string= "windows" system-name)
      (setq open-junk-file-format "/mnt/c/Users/yuya373/Dropbox/junk/%Y-%m-%d")
    (setq open-junk-file-format "~/Dropbox/junk/%Y-%m-%d."))
  (setq open-junk-file-find-file-function 'find-file-other-window)

  (defun open-junk-org-today ()
    (interactive)
    (let ((file (format "%sorg"
                        (format-time-string open-junk-file-format (current-time)))))
      (make-directory (file-name-directory file) t)
      (funcall open-junk-file-find-file-function file)))

  (defun open-junk-file ()
    (interactive)
    (let ((file (let* ((path (format-time-string open-junk-file-format (current-time)))
                       (dir (file-name-directory path))
                       (filename (file-name-nondirectory path)))
                  (read-file-name "Junk Code (Enter extension): " dir nil nil
                                  filename))))
      (make-directory (file-name-directory file) t)
      (funcall open-junk-file-find-file-function file)))
  (defun open-junk-dir ()
    (interactive)
    (let* ((dir (file-name-directory open-junk-file-format))
           (file (read-file-name "Find file:" dir)))
      (when file
        (funcall open-junk-file-find-file-function file)))
    )
  )

;; (use-package nov
;;   :ensure t
;;   :mode (("\\.epub\\'" . nov-mode))
;;   :init
;;   (setq nov-text-width 80))


(provide '22-document)
;;; 22-document.el ends here
