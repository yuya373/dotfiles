;;; cocoa-emacs-config.el ---                        -*- lexical-binding: t; -*-

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
(when window-system
  ;; Ricty フォントの利用
  (create-fontset-from-ascii-font "Ricty for Powerline-17:weight=normal:slant=normal" nil "ricty")
  (set-fontset-font "fontset-ricty"
                    'unicode
                    (font-spec :family "Ricty for Powerline" :size 17)
                    nil
                    'append)
  (add-to-list 'default-frame-alist '(font . "fontset-ricty"))
  ;; 警告音の代わりに画面フラッシュ
  ;; (setq visible-bell t)
  ;; 警告音もフラッシュも全て無効(警告音が完全に鳴らなくなるので注意)
  (setq ring-bell-function 'ignore)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (set-fontset-font
   t 'symbol
   (font-spec :family "Apple Color Emoji") nil 'prepend))

(use-package ls-lisp
  :init
  (setq ls-lisp-use-insert-directory-program nil))

(provide 'cocoa-emacs-config)
;;; cocoa-emacs-config.el ends here
