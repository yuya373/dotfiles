;;; 02-prog-mode.el --- prog-mode                    -*- lexical-binding: t; -*-

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

;; smartparens
;; (el-get-bundle smartparens)
;; (use-package smartparens-config
;;   :diminish smartparens-mode
;;   :commands (smartparens-mode turn-on-smartparens-mode)
;;   :init
;;   (add-hook 'elm-interactive-mode-hook 'smartparens-mode)
;;   (add-hook 'inferior-ess-mode-hook 'smartparens-mode)
;;   (add-hook 'ess-mode-hook 'smartparens-mode)
;;   (add-hook 'inferior-python-mode-hook 'smartparens-mode)
;;   (add-hook 'ensime-inf-mode-hook 'smartparens-mode)
;;   (add-hook 'eshell-mode-hook 'smartparens-mode)
;;   (add-hook 'slime-repl-mode-hook '(lambda () (turn-off-smartparens-mode)))
;;   (add-hook 'web-mode-hook '(lambda () (turn-off-smartparens-mode)))
;;   (add-hook 'yaml-mode-hook 'smartparens-mode)
;;   (add-hook 'inf-ruby-mode-hook 'smartparens-mode)
;;   (add-hook 'restclient-mode-hook 'smartparens-mode)
;;   (add-hook 'prog-mode-hook 'smartparens-mode)
;;   :config
;;   ;; (with-eval-after-load "evil"
;;   ;;   (evil-define-key 'normal smartparens-mode-map
;;   ;;     (kbd "C-s C-f") 'sp-forward-sexp
;;   ;;     (kbd "C-s C-b") 'sp-backward-sexp
;;   ;;     (kbd "C-s C-w") 'sp-unwrap-sexp
;;   ;;     (kbd "C-s C-p") 'sp-previous-sexp
;;   ;;     (kbd "C-s C-n") 'sp-next-sexp
;;   ;;     (kbd "C-s C-d") 'sp-down-sexp
;;   ;;     (kbd "C-s C-u") 'sp-up-sexp
;;   ;;     (kbd "C-s C-k") 'sp-kill-hybrid-sexp)
;;   ;; (define-key evil-normal-state-map (kbd "C-s") smartparens-mode-map))
;;   )

;; linum
(use-package linum-mode
  :commands (linum-mode)
  :init
  (setq linum-format "%4d ")
  (setq linum-delay t)
  (add-hook 'prog-mode-hook 'linum-mode))

(use-package elec-pair
  :commands (electric-pair-mode)
  :init
  (add-hook 'after-init-hook 'electric-pair-mode)
  :config
  (add-to-list 'electric-pair-pairs '(?| . ?|)))

(el-get-bundle rainbow-delimiters)
(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode)
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package eldoc
  :diminish eldoc-mode
  :commands (eldoc-mode)
  :init
  (add-hook 'prog-mode-hook 'eldoc-mode))

(el-get-bundle volatile-highlights)
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :commands (volatile-highlights-mode)
  :init
  (add-hook 'prog-mode-hook 'volatile-highlights-mode))

(el-get-bundle electric-operator)
(use-package electric-operator
  :commands (electric-operator-mode)
  :init
  (add-hook 'ess-mode-hook 'electric-operator-mode)
  (add-hook 'python-mode-hook 'electric-operator-mode))

(el-get-bundle quickrun)
(use-package quickrun
  :commands (quickrun
             quickrun-region
             quickrun-with-arg
             quickrun-shell)
  :init
  (setq quickrun-focus-p nil))

(provide '02-prog-mode)
;;; 02-prog-mode.el ends here
