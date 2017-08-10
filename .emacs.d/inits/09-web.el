;;; 09-web.el ---                                    -*- lexical-binding: t; -*-

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

(el-get-bundle web-mode)
(use-package web-mode
  :mode (("\\.erb\\'" . web-mode)
         ("\\.html?\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2))

(el-get-bundle scss-mode)
(use-package scss-mode
  :mode (("\\.scss\\'" . scss-mode))
  :init
  (defun scss-mode-setup ()
    (setq-local css-indent-offset 2)
    (setq-local scss-compile-at-save nil))
  (add-hook 'scss-mode-hook #'scss-mode-setup))

(el-get-bundle json-mode)
(use-package json-mode
  :mode (("\\.json\\'" . json-mode))
  :init
  (setq js-indent-level 2)
  (setq json-reformat:indent-width 2))

(use-package eww
  :commands (eww)
  :init
  (setq shr-use-fonts t)
  (defun eww-mode-hook--rename-buffer ()
    "Rename eww browser's buffer so sites open in new page."
    (rename-buffer "eww" t))
  ;; (add-hook 'eww-mode-hook 'eww-mode-hook--rename-buffer)
  (add-hook 'eww-mode-hook #'(lambda () (linum-mode -1)))
  (add-hook 'eww-mode-hook #'(lambda () (whitespace-mode -1)))
  (setq eww-search-prefix "https://www.google.co.jp/search?q=")
  ;; (setq url-user-agent "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A366 Safari/600.1.4")
  (defun eww-mode-hook--rename-buffer ()
    "Rename eww browser's buffer so sites open in new page."
    (interactive)
    (rename-buffer (format "eww - %s" (plist-get eww-data :title)) t))
  (add-hook 'eww-mode-hook 'eww-mode-hook--rename-buffer)
  (add-hook 'eww-after-render-hook 'eww-mode-hook--rename-buffer)
  :config
  (defvar eww-disable-colorize t)
  (defun shr-colorize-region--disable (orig start end fg &optional bg &rest _)
    (unless eww-disable-colorize
      (funcall orig start end fg)))
  (advice-add 'shr-colorize-region :around 'shr-colorize-region--disable)
  (advice-add 'eww-colorize-region :around 'shr-colorize-region--disable)
  (defun eww-disable-color ()
    "eww で文字色を反映させない"
    (interactive)
    (setq-local eww-disable-colorize t)
    (eww-reload))
  (defun eww-enable-color ()
    "eww で文字色を反映させる"
    (interactive)
    (setq-local eww-disable-colorize nil)
    (eww-reload))
  (setq url-privacy-level 'paranoid)
  ;; (defun url-http-user-agent-string ()
  ;;   (format "User-Agent: %s\r\n"
  ;;           "Mozilla/5.0 (iPhone; CPU iPhone OS 9_0_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13A452 Safari/601.1"))
  (define-key eww-link-keymap (kbd "w") nil)
  (evil-define-key 'normal eww-link-keymap
    "w" nil
    "\C-m" 'eww-follow-link
    ",y" 'shr-copy-url)
  (evil-define-key 'normal eww-history-mode-map
    "\C-m" 'eww-history-browse
    "q" 'quit-window)
  (evil-define-key 'normal eww-bookmark-mode-map
    "\C-k" nil
    "\C-y" nil
    "\C-m" 'eww-bookmark-browse
    ",k" 'eww-bookmark-kill
    ",y" 'eww-bookmark-yank
    "q" 'quit-window)
  (defun eww-copy-page-url-as-md ()
    (interactive)
    (kill-new (format "[%s](%s)"
                      (plist-get eww-data :title)
                      (plist-get eww-data :url))))
  (evil-define-key 'normal eww-mode-map
    "w" nil
    "g" nil
    "t" nil
    "n" nil
    "p" nil
    "d" nil
    "r" 'eww-reload
    "H" 'eww-back-url
    "L" 'eww-forward-url
    ",R" 'eww-readable
    ",c" 'url-cookie-list
    ",d" 'eww-download
    ",ln" 'eww-next-url
    ",lp" 'eww-previous-url
    ",yy" 'eww-copy-page-url
    ",ym" 'eww-copy-page-url-as-md
    ",o" 'eww-browse-with-external-browser
    ",B" 'eww-list-bookmarks
    ",b" 'eww-add-bookmark
    ",h" 'eww-list-histories
    "q" 'quit-window))

(provide '09-web)
;;; 09-web.el ends here
