;;; 37-markdown.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2017  南優也

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
(require 'use-package)
(el-get-bundle sindresorhus/github-markdown-css)

(use-package markdown-mode
  :ensure t
  :mode (("\\.markdown\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("PULLREQ_MSG" . gfm-mode))
  :init
  (setq markdown-header-scaling t)
  (setq markdown-indent-on-enter 'indent-and-new-item)
  (setq markdown-fontify-code-blocks-natively t)
  (setq markdown-list-indent-width 2)
  (setq markdown-command "marked --gfm --breaks --tables")
  (setq markdown-css-paths (list
                            ;; (expand-file-name "~/.emacs.d/el-get/primer-css/modules/primer/build/build.css")
                            "https://thomasf.github.io/solarized-css/solarized-light.min.css"
                            (expand-file-name "~/.emacs.d/el-get/github-markdown-css/github-markdown.css")
                            ))
  (defun my-gfm-mode-hook ()
    (whitespace-mode -1)
    ;; (set (make-local-variable 'tab-width) 2)
    ;; (visual-line-mode t)
    )
  (add-hook 'gfm-mode-hook #'my-gfm-mode-hook)
  (defun my-gfm-map ()
    (interactive)
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
      ",C" 'markdown-insert-gfm-code-block)
    (evil-define-key 'normal gfm-mode-map
      (kbd "TAB") 'markdown-cycle
      ",ta" 'markdown-table-align
      ",tic" 'markdown-table-insert-column
      ",tir" 'markdown-table-insert-row
      ",tdc" 'markdown-table-delete-column
      ",tdr" 'markdown-table-delete-row
      ",tt" 'markdown-toggle-gfm-checkbox
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
      ",iC" 'markdown-insert-gfm-code-block
      ",it" 'md-insert-task-list
      ",iTt" 'markdown-insert-table
      ",m" 'markdown-other-window
      ",p" 'markdown-preview
      ",k" 'markdown-promote
      ",j" 'markdown-demote))
  (defun md-insert-task-list ()
    (interactive)
    (insert "- [ ] "))
  (add-hook 'gfm-mode-hook 'my-gfm-map)

  (setq markdown-body-class-name "markdown-body")
  :config
  (setq auto-mode-alist
        (cl-remove-if #'(lambda (mode) (eq (cdr mode) 'markdown-mode))
                      auto-mode-alist))
  (defun markdown-add-xhtml-header-and-footer (title)
    "Wrap XHTML header and footer with given TITLE around current buffer."
    (goto-char (point-min))
    (insert "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n"
            "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\n"
            "\t\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n\n"
            "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n\n"
            "<head>\n<title>")
    (insert title)
    (insert "</title>\n")
    (when (> (length markdown-content-type) 0)
      (insert
       (format
        "<meta http-equiv=\"Content-Type\" content=\"%s;charset=%s\"/>\n"
        markdown-content-type
        (or (and markdown-coding-system
                 (fboundp 'coding-system-get)
                 (coding-system-get markdown-coding-system
                                    'mime-charset))
            (and (fboundp 'coding-system-get)
                 (coding-system-get buffer-file-coding-system
                                    'mime-charset))
            "iso-8859-1"))))
    (if (> (length markdown-css-paths) 0)
        (insert (mapconcat 'markdown-stylesheet-link-string markdown-css-paths "\n")))
    (when (> (length markdown-xhtml-header-content) 0)
      (insert markdown-xhtml-header-content))
    (insert "\n</head>\n\n"
            (or (and markdown-body-class-name
                     (format "<body class=\"%s\">" markdown-body-class-name))
                "<body>")
            "\n\n")
    (goto-char (point-max))
    (insert "\n"
            "</body>\n"
            "</html>\n")))

(provide '37-markdown)
;;; 37-markdown.el ends here
