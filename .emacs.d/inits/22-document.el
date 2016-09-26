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
  (require 'evil-leader)
  (el-get-bundle pdf-tools)
  (require 'pdf-tools))

(el-get-bundle pdf-tools)
(use-package pdf-tools
  :commands (pdf-tools-install)
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :init
  (setq pdf-view-resize-factor 1.1)
  ;; (add-hook 'pdf-view-mode-hook 'pdf-view-auto-slice-minor-mode)
  (add-hook 'pdf-view-mode-hook #'(lambda () (linum-mode -1)))
  ;; (add-hook 'pdf-view-mode-hook 'pdf-view-dark-minor-mode)
  ;; (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
  (add-hook 'pdf-view-mode-hook #'(lambda () (blink-cursor-mode -1)))
  (setq pdf-view-dump-file-name "pdf-view-dump")
  :config
  (defun pdf-view-dump-last-page ()
    (interactive)
    (let ((current-page (pdf-view-current-page)))
      (when (and current-page (< 1 current-page))
        (let* ((file-path (concat user-emacs-directory
                                  pdf-view-dump-file-name))
               (pdf-file-name (mapconcat #'identity
                                         (split-string
                                          (pdf-view-buffer-file-name)
                                          "\s") ""))
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
    (let* ((pdf-file-name (mapconcat #'identity
                                     (split-string
                                      (pdf-view-buffer-file-name)
                                      "\s") ""))
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
    ",vs" 'pdf-view-auto-slice-minor-mode
    ",vd" 'pdf-view-dark-minor-mode
    ",vm" 'pdf-view-midnight-minor-mode
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
                  (when (eql major-mode 'pdf-view-mode)
                    (setf (pdf-view-current-page win)
                          pdf-view-last-visited-page)
                    (setq pdf-view-display-size
                          pdf-view-last-display-size)
                    (pdf-view-redisplay win)))))

  (add-hook 'popwin:before-popup-hook #'mcc-pdf-view-save)
  (add-hook 'popwin:after-popup-hook #'mcc-pdf-view-restore)
  (use-package pdf-links)
  (use-package pdf-info)
  (use-package pdf-misc)
  (use-package pdf-sync)
  (use-package pdf-outline
    :config
    (evil-define-key 'normal pdf-outline-buffer-mode-map
      (kbd "TAB") 'outline-toggle-children
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

(el-get-bundle csv-mode)
(use-package csv-mode
  :mode (("\\.csv\\'" . csv-mode))
  :config
  (evil-define-key 'normal csv-mode-map
    ",a" 'csv-align-fields))

(el-get-bundle markdown-mode)
(use-package gfm-mode
  :mode (("\\.markdown\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("PULLREQ_MSG" . gfm-mode))
  :init
  (defun my-gfm-mode-hook ()
    (set (make-local-variable 'tab-width) 2)
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-ispell)
    (visual-line-mode t))
  (add-hook 'gfm-mode-hook #'my-gfm-mode-hook)
  :config
  (defun md-insert-task-list ()
    (interactive)
    (insert "- [ ] "))
  (evil-define-key 'visual gfm-mode-map
    ",C" 'markdown-insert-gfm-code-block)
  (evil-define-key 'normal gfm-mode-map
    ",iC" 'markdown-insert-gfm-code-block
    ",it" 'md-insert-task-list))

(el-get-bundle gist:2554919:github.css)
(el-get-bundle markdowncss/retro)
(el-get-bundle markdowncss/splendor)
(el-get-bundle markdowncss/modest)
(use-package markdown-mode
  :init
  (defun my-markdown-mode-setting ()
    (set (make-local-variable 'tab-width) 2)
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-ispell))
  (add-hook 'markdown-mode-hook #'my-markdown-mode-setting)
  (setq markdown-command "marked --gfm --breaks --tables")
  (setq markdown-css-paths (list (expand-file-name "~/.emacs.d/el-get/modest/css/modest.css")))

  (defun md-add-body-class-name ()
    (message "%s" (buffer-substring-no-properties (point-min) (point-max))))
  (add-hook 'markdown-after-export-hook 'md-add-body-class-name)

  :config
  (evil-define-key 'visual gfm-mode-map
    ",l" nil
    ",lr" 'markdown-insert-reference-link-dwim
    ",ll" 'markdown-insert-link
    ",lf" 'markdown-insert-footnote
    ",I" 'markdown-insert-image
    ",i" 'markdown-insert-italic
    ",b" 'markdown-insert-bold
    ",q" 'markdown-blockquote-region
    ",c" 'markdown-insert-code
    ",p" 'markdown-pre-region
    ",k" 'markdown-insert-kbd
    ",d" 'markdown-insert-strike-through
    ">" 'markdown-indent-region
    "<" 'markdown-exdent-region
    )
  (evil-define-key 'normal gfm-mode-map
    ",i" nil
    ",iL" 'markdown-insert-list-item
    ",ilr" 'markdown-insert-reference-link-dwim
    ",ill" 'markdown-insert-link
    ",ilf" 'markdown-insert-footnote
    ",ih" 'markdown-insert-header-dwim
    ",iH" 'markdown-insert-header-setext-dwim
    ",i-" 'markdown-insert-hr
    ",iI" 'markdown-insert-image
    ",ii" 'markdown-insert-italic
    ",ib" 'markdown-insert-bold
    ",iq" 'markdown-insert-blockquote
    ",ic" 'markdown-insert-code
    ",ik" 'markdown-insert-kbd
    ",id" 'markdown-insert-strike-through
    ",ip" 'markdown-insert-pre
    ",m" 'markdown-other-window
    ",p" 'markdown-preview
    ",k" 'markdown-promote
    ",j" 'markdown-demote
    ))

(el-get-bundle open-junk-file)
(use-package open-junk-file
  :commands (open-junk-file)
  :config
  (setq open-junk-file-format "~/Dropbox/junk/%Y-%m-%d."))

(el-get-bundle org)
(use-package org
  :mode (("\\.org\\'" . org-mode))
  :config
  (setq org-src-fontify-natively t)
  (setq org-directory "~/Dropbox/junk")
  (setq org-agenda-files (list org-directory))
  (use-package evil-org
    :init
    (setq org-src-fontify-natively t)
    :config
    (use-package org-bullets
      :init
      (add-hook 'org-mode-hook 'org-bullets-mode))
    (evil-define-key 'visual evil-org-mode-map
      ",m" 'org-md-convert-region-to-md)
    (evil-define-key 'normal evil-org-mode-map
      ;; ",tc" 'org-toggle-checkbox
      "t" nil
      ",m" 'org-md-export-to-markdown
      ",t" 'org-todo)))

(provide '22-document)
;;; 22-document.el ends here
