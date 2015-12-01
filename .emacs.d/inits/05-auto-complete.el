;;; 05-auto-complete.el ---                          -*- lexical-binding: t; -*-

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

(el-get-bundle pos-tip
  :type github
  :pkgname "pitkali/pos-tip"
  :name pos-tip)
(el-get-bundle auto-complete)
(el-get-bundle ac-emoji)
(use-package auto-complete-config
  :commands (ac-config-default)
  :init
  ;; (defun set-auto-complete-as-completion-at-point-function ()
  ;;   (setq completion-at-point-functions '(auto-complete)))
  ;; (add-hook 'auto-complete-mode-hook
  ;;           'set-auto-complete-as-completion-at-point-function)
  (add-hook 'evil-mode-hook 'ac-config-default)
  :config
  (use-package pos-tip)
  (use-package auto-complete
    :init
    (setq ac-auto-start 3
          ac-delay 0.2
          ac-auto-show-menu t
          ac-max-width 0.4
          ac-quick-help-delay 0.5
          ac-quick-help-prefer-pos-tip nil
          ac-use-fuzzy t
          ac-use-comphist t
          ac-fuzzy-enable t
          ac-use-menu-map t
          ac-use-quick-help t
          ac-quick-help-prefer-pos-tip t
          ac-dwim t)
    (setq-default ac-sources '(ac-source-filename
                               ac-source-dictionary
                               ac-source-words-in-same-mode-buffers))
    (add-hook 'emacs-lisp-mode-hook (lambda () (add-to-list 'ac-sources 'ac-source-symbols)))
    :config
    (setq ac-modes (append ac-modes '(git-commit-mode
                                      gfm-mode
                                      markdown-mode
                                      eshell-mode
                                      enh-ruby-mode)))
    (evil-define-key 'insert ac-menu-map (kbd "C-n") 'ac-next)
    (evil-define-key 'insert ac-menu-map (kbd "C-p") 'ac-previous)
    (evil-define-key 'insert ac-menu-map (kbd "<S-tab>") 'ac-previous)
    (ac-set-trigger-key "TAB")
    (use-package ac-emoji
      :commands (ac-emoji-setup)
      :init
      (add-hook 'slack-mode-hook 'ac-emoji-setup)
      (add-hook 'git-commit-mode-hook 'ac-emoji-setup)
      (add-hook 'gfm-mode-hook 'ac-emoji-setup)
      (add-hook 'markdown-mode-hook 'ac-emoji-setup))))

(provide '05-auto-complete)
;;; 05-auto-complete.el ends here
