;;; 17-haskell.el ---                                -*- lexical-binding: t; -*-

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

(el-get-bundle haskell-mode)
(use-package haskell-mode
  :mode (("\\.hs\\'" . haskell-mode)
         ("\\.lhs\\'" . literate-haskell-mode))
  :init
  (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
  (add-hook 'haskell-mode-hook 'font-lock-mode)
  (add-hook 'haskell-mode-hook 'inf-haskell-mode))
(use-package haskell-cabel-mode
  :mode (("\\.cabal\\'" . haskell-cabel-mode)))
(use-package haskell-indentation-mode
  :commands (haskell-indentation-mode)
  :init
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode))
(el-get-bundle ghc-mod)
(use-package ghc
  :commands (ghc-init)
  :init
  (add-hook 'haskell-mode-hook '(lambda () (ghc-init)))
  :config
  (add-to-list 'ac-sources 'ac-source-ghc-mod))

(provide '17-haskell)
;;; 17-haskell.el ends here
