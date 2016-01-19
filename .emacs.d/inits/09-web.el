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
  (add-hook 'web-mode-hook '(lambda () (turn-off-smartparens-mode)))
  (setq web-mode-markup-indent-offset 2))

(el-get-bundle scss-mode)
(use-package scss-mode
  :mode (("\\.scss\\'" . scss-mode)))

(el-get-bundle json-mode)
(use-package json-mode
  :mode (("\\.json\\'" . json-mode))
  :init
  (setq js-indent-level 2)
  (setq json-reformat:indent-width 2))

(el-get-bundle haml-mode)
(use-package haml-mode
  :mode (("\\.haml\\'" . haml-mode)))

(use-package eww
  :commands (eww)
  :init
  (setq shr-use-fonts nil)
  (defun eww-mode-hook--rename-buffer ()
    "Rename eww browser's buffer so sites open in new page."
    (rename-buffer "eww" t))
  ;; (add-hook 'eww-mode-hook 'eww-mode-hook--rename-buffer)
  (add-hook 'eww-mode-hook #'(lambda () (linum-mode -1)))
  (add-hook 'eww-mode-hook #'(lambda () (whitespace-mode -1)))
  (setq eww-search-prefix "https://www.google.co.jp/search?q=")
  ;; (setq url-user-agent "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12A366 Safari/600.1.4")
  :config
  (evil-define-key 'normal eww-history-mode-map "o" 'eww-history-browse)
  (evil-define-key 'normal eww-history-mode-map "q" 'quit-window)
  (evil-define-key 'normal eww-bookmark-mode-map "o" 'eww-bookmark-browse)
  (evil-define-key 'normal eww-bookmark-mode-map "d" 'eww-bookmark-kill)
  (evil-define-key 'normal eww-bookmark-mode-map "q" 'quit-window)
  (evil-define-key 'normal eww-mode-map "r" 'eww-reload)
  (evil-define-key 'normal eww-mode-map "H" 'eww-back-url)
  (evil-define-key 'normal eww-mode-map "L" 'eww-forward-url)
  (evil-define-key 'normal eww-mode-map ",o" 'eww-browse-with-external-browser)
  (evil-define-key 'normal eww-mode-map ",B" 'eww-list-bookmarks)
  (evil-define-key 'normal eww-mode-map ",b" 'eww-add-bookmark)
  (evil-define-key 'normal eww-mode-map ",@" 'eww-list-histories)
  (evil-define-key 'normal eww-mode-map "q" 'quit-window))

(provide '09-web)
;;; 09-web.el ends here
