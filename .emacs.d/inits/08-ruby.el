;;; 08-ruby.el ---                                   -*- lexical-binding: t; -*-

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

;; (el-get-bundle ruby-end)
(el-get-bundle bundler)
(el-get-bundle rbenv)
(el-get-bundle robe-mode)
(el-get-bundle inf-ruby)
(el-get-bundle enh-ruby-mode)
(el-get-bundle ruby-test-mode)

(use-package rbenv
  :commands (global-rbenv-mode rbenv-use-global rbenv-use-corresponding)
  :init
  (setq rbenv-show-active-ruby-in-modeline nil)
  (setq rbenv-executable "/usr/local/Cellar/rbenv/HEAD/bin/rbenv")
  (add-hook 'enh-ruby-mode-hook 'global-rbenv-mode)
  (add-hook 'enh-ruby-mode-hook 'rbenv-use-global)
  ;; (add-hook 'enh-ruby-mode-hook (lambda () (rbenv-use-corresponding)))
  )
(use-package inf-ruby
  :commands (inf-ruby inf-ruby-minor-mode inf-ruby-console-auto)
  :init
  (add-hook 'inf-ruby-mode-hook 'smartparens-mode)
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode))
(use-package robe
  :diminish robe-mode
  :commands (robe-mode robe-start)
  :init
  (setq robe-highlight-capf-candidates t)
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  :config
  (evil-define-key 'normal robe-mode-map (kbd ",rs") 'robe-start)
  (evil-define-key 'normal robe-mode-map (kbd ",rh") 'robe-doc)
  (evil-define-key 'normal robe-mode-map (kbd ",ra") 'robe-ask)
  (evil-define-key 'normal robe-mode-map (kbd ",rj") 'robe-jump)
  (evil-define-key 'normal robe-mode-map (kbd ",rR") 'robe-rails-refresh))
(use-package bundler
  :commands (bundle-open bundle-exec bundle-check bundle-gemfile
                         bundle-update bundle-console bundle-install)
  :config
  (evil-define-key 'normal projectile-rails-mode-map
    (kbd ",be") 'bundle-exec
    (kbd ",bc") 'bundle-console
    (kbd ",bg") 'bundle-gemfile
    (kbd ",bu") 'bundle-update
    (kbd ",bi") 'bundle-install
    (kbd ",bo") 'bundle-open))
(use-package enh-ruby-mode
  :mode (("\\(Rake\\|Thor\\|Guard\\|Gem\\|Cap\\|Vagrant\\|Berks\\|Pod\\|Puppet\\)file\\'" . enh-ruby-mode)
         ("\\.\\(rb\\|rabl\\|ru\\|builder\\|rake\\|thor\\|gemspec\\|jbuilder\\|schema\\|cap\\)\\'" . enh-ruby-mode))
  :init
  (defun my-company-ruby ()
    (setq-default tab-width 2)
    (make-local-variable 'company-minimum-prefix-length)
    (setq company-minimum-prefix-length 4)
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends '(company-robe company-dabbrev-code))
    ;; (setq company-backends (remq 'company-capf company-backends))
    )
  (add-hook 'enh-ruby-mode-hook 'my-company-ruby)
  (add-hook 'inf-ruby-mode-hook 'my-company-ruby)
  ;; (modify-syntax-entry ?_ "w")
  (setq
   enh-ruby-add-encoding-comment-on-save nil
   enh-ruby-deep-indent-paren nil
   ;; enh-ruby-deep-arglist t
   )
  ;; (setq ruby-insert-encoding-magic-comment nil)
  ;; (setq ruby-deep-indent-paren-style nil)
  ;; (setq ruby-align-chained-calls nil)
  :config
  ;; (use-package ruby-end)
  (modify-syntax-entry ?@ "_" enh-ruby-mode-syntax-table)
  (modify-syntax-entry ?: "_" enh-ruby-mode-syntax-table)
  (modify-syntax-entry ?! "_" enh-ruby-mode-syntax-table)
  (modify-syntax-entry ?_ "w" enh-ruby-mode-syntax-table)

  (evil-define-key 'normal enh-ruby-mode-map
    (kbd ",el") 'ruby-send-last-sexp
    (kbd ",ed") 'ruby-send-definition-and-go
    (kbd ",eb") 'ruby-send-block-and-go
    (kbd ",ric") 'inf-ruby-console-auto)
  (evil-define-key 'visual enh-ruby-mode-map
    (kbd ",er") 'ruby-send-region-and-go)
  (evil-define-key 'normal enh-ruby-mode-map
    (kbd ",be") 'bundle-exec
    (kbd ",bc") 'bundle-console
    (kbd ",bg") 'bundle-gemfile
    (kbd ",bu") 'bundle-update
    (kbd ",bi") 'bundle-install
    (kbd ",bo") 'bundle-open)
  )

(use-package ruby-test-mode
  :diminish ruby-test-mode
  :commands (ruby-test-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'ruby-test-mode)
  :config
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tt") 'ruby-test-run-at-point)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tb") 'ruby-test-run)
  (defun ruby-test-toggle-vsplit ()
    (interactive)
    (let ((window (split-window-right)))
      (select-window window)
      (balance-windows)
      (ruby-test-toggle-implementation-and-specification)))
  (defun ruby-test-toggle-split ()
    (interactive)
    (let ((window (split-window (selected-window) nil 'above)))
      (select-window window)
      (balance-windows)
      (ruby-test-toggle-implementation-and-specification)))
  (evil-define-key 'normal ruby-test-mode-map (kbd ",tv") 'ruby-test-toggle-vsplit)
  (evil-define-key 'normal ruby-test-mode-map (kbd ",ts") 'ruby-test-toggle-split))

(el-get-bundle yaml-mode)
(use-package yaml-mode
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode))
  :init
  (add-hook 'yaml-mode-hook 'smartparens-mode))



(provide '08-ruby)
;;; 08-ruby.el ends here
