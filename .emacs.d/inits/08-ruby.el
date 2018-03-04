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
  (require 'evil)
  (require 'evil-common))

(el-get-bundle bundler)
(el-get-bundle rbenv)
(el-get-bundle robe-mode)
(el-get-bundle inf-ruby)
(el-get-bundle enh-ruby-mode)
(el-get-bundle ruby-test-mode)
(el-get-bundle ruby-block
  :github h3poteto/ruby-block.el)
(el-get-bundle ruby-end)
(el-get-bundle rspec-mode)

(defun my-ruby-modify-syntax (tables)
  (dolist (syntax-table tables)
    (dolist (tbl '((?$ . "_") (?@ . "_") (?: . "_") (?: . ".") (?! . "_") (?_ . "w") (?? . "w")))
      (modify-syntax-entry (car tbl) (cdr tbl) syntax-table))))

(use-package ruby-end
  :commands (ruby-end-mode)
  :diminish ruby-end-mode
  :init
  (setq ruby-end-insert-newline nil)
  (add-hook 'enh-ruby-mode-hook 'ruby-end-mode)
  )

(use-package ruby-block
  :commands (ruby-block-mode)
  :diminish ruby-block-mode
  :init
  (setq ruby-block-highlight-toggle t)
  (add-hook 'enh-ruby-mode-hook 'ruby-block-mode))

(use-package rbenv
  :commands (global-rbenv-mode rbenv-use-global rbenv-use-corresponding)
  :init
  (setq rbenv-show-active-ruby-in-modeline nil)
  (setq rbenv-executable "~/.rbenv/bin/rbenv")
  (add-hook 'enh-ruby-mode-hook 'global-rbenv-mode)
  (add-hook 'enh-ruby-mode-hook 'rbenv-use-global)
  ;; (add-hook 'enh-ruby-mode-hook (lambda () (rbenv-use-corresponding)))
  )

(use-package inf-ruby
  :commands (inf-ruby inf-ruby-minor-mode inf-ruby-console-auto)
  :init
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
  (defun my-inf-ruby-mode-hook ()
    ;; (make-local-variable 'company-backends)
    ;; (setq company-backends (remq 'company-capf company-backends))
    )
  (add-hook 'inf-ruby-mode-hook 'my-inf-ruby-mode-hook)
  :config
  (evil-define-key 'normal inf-ruby-minor-mode-map
    ",rr" 'ruby-switch-to-inf
    ",eb" 'ruby-send-block-and-go
    ",ed" 'ruby-send-definition-and-go
    ",el" 'ruby-load-file
    ",ee" 'ruby-send-last-sexp)
  (evil-define-key 'visual inf-ruby-minor-mode-map
    ",er" 'ruby-send-region-and-go))

(use-package robe
  :diminish robe-mode
  :commands (robe-mode robe-start)
  :init
  (setq robe-highlight-capf-candidates t)
  (add-hook 'enh-ruby-mode-hook 'robe-mode)
  (defun disable-robe-eldoc ()
    (interactive)
    (setq-local eldoc-documentation-function nil))
  (defun my-robe-mode-hook ()
    (disable-robe-eldoc)
    (setq-default tab-width 2)
    ;; (make-local-variable 'company-minimum-prefix-length)
    ;; (setq company-minimum-prefix-length 2)
    ;; (make-local-variable 'company-idle-delay)
    ;; (setq company-idle-delay 0.5)
    ;; (make-local-variable 'company-backends)
    ;; (add-to-list 'company-backends '(company-robe :with company-dabbrev))
    (add-to-list 'company-backends 'company-robe)
    ;; (setq company-backends (remq 'company-capf company-backends))
    (remove-hook 'completion-at-point-functions 'robe-complete-at-point t))
  (add-hook 'robe-mode-hook 'my-robe-mode-hook)
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
  (mapc #'(lambda (map) (evil-define-key 'normal map
                          (kbd ",be") 'bundle-exec
                          (kbd ",bc") 'bundle-console
                          (kbd ",bg") 'bundle-gemfile
                          (kbd ",bu") 'bundle-update
                          (kbd ",bi") 'bundle-install
                          (kbd ",bo") 'bundle-open))
        '(projectile-rails-mode-map enh-ruby-mode-map)))

(use-package enh-ruby-mode
  :mode (("\\(Rake\\|Thor\\|Guard\\|Gem\\|Cap\\|Vagrant\\|Berks\\|Pod\\|Puppet\\)file\\'" . enh-ruby-mode)
         ("\\.\\(rb\\|rabl\\|ru\\|builder\\|rake\\|thor\\|gemspec\\|jbuilder\\|schema\\|cap\\)\\'" . enh-ruby-mode))
  :init
  ;; (defun my-enh-setup-program ()
  ;;   (setq enh-ruby-program rbenv-ruby-shim))
  ;; (add-hook 'global-rbenv-mode-hook 'my-enh-setup-program)
  (setq enh-ruby-add-encoding-comment-on-save nil
        enh-ruby-deep-indent-paren nil
        ;; enh-ruby-program "~/.rbenv/shims/ruby"
        ;; enh-ruby-deep-arglist t
        enh-ruby-bounce-deep-indent nil)
  (setq ruby-insert-encoding-magic-comment nil)
  (setq ruby-deep-indent-paren-style nil)
  (setq ruby-align-chained-calls nil)
  (defun my-enh-ruby-modify-syntax ()
    (my-ruby-modify-syntax (list enh-ruby-mode-syntax-table enh-ruby-mode-syntax-table)))
  (add-hook 'enh-ruby-mode-hook 'my-enh-ruby-modify-syntax)
  :config

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

(use-package rspec-mode
  :init
  (setq rspec-use-docker-when-possible t)
  (setq rspec-docker-container "app")
  :config
  (defun rspec-spec-file-p (a-file-name)
    "Return true if the specified A-FILE-NAME is a spec."
    (or (numberp (string-match rspec-spec-file-name-re a-file-name))
        (numberp (string-match "spec" a-file-name)))
    )
  (with-eval-after-load "evil"
    (evil-define-key 'normal rspec-mode-map
      ",tt" 'rspec-verify-single
      ",tb" 'rspec-verify)
    (evil-define-key 'normal rspec-verifiable-mode-map
      ",tt" 'rspec-verify-single
      ",tb" 'rspec-verify)))

;; (use-package ruby-test-mode
;;   :diminish ruby-test-mode
;;   :commands (ruby-test-mode)
;;   :init
;;   (setq ruby-test-default-library "spec")
;;   (add-hook 'enh-ruby-mode-hook 'ruby-test-mode)
;;   :config
;;   (evil-define-key 'normal ruby-test-mode-map (kbd ",tt") 'ruby-test-run-at-point)
;;   (evil-define-key 'normal ruby-test-mode-map (kbd ",tb") 'ruby-test-run)
;;   (defun ruby-test-toggle-vsplit ()
;;     (interactive)
;;     (let ((window (split-window-right)))
;;       (select-window window)
;;       (balance-windows)
;;       (ruby-test-toggle-implementation-and-specification)))
;;   (defun ruby-test-toggle-split ()
;;     (interactive)
;;     (let ((window (split-window (selected-window) nil 'above)))
;;       (select-window window)
;;       (balance-windows)
;;       (ruby-test-toggle-implementation-and-specification)))
;;   (evil-define-key 'normal ruby-test-mode-map (kbd ",tv") 'ruby-test-toggle-vsplit)
;;   (evil-define-key 'normal ruby-test-mode-map (kbd ",ts") 'ruby-test-toggle-split)

;;   (defun ruby-test-spec-command (filename &optional line-number)
;;     (let (command options)
;;       (if (file-exists-p ".zeus.sock")
;;           (setq command "zeus rspec")
;;         (setq command "bundle exec spring rspec --format documentation"))
;;       (setq options ruby-test-rspec-options)
;;       (if line-number
;;           (setq filename (format "%s:%s" filename line-number)))
;;       (format "%s %s %s" command (mapconcat 'identity options " ") filename)))
;;   (defun ruby-test-run-command (command)
;;     (let ((default-directory (or (ruby-test-rails-root filename)
;;                                  (ruby-test-ruby-root filename)
;;                                  default-directory)))
;;       (compilation-start command t))))

(el-get-bundle yaml-mode)
(use-package yaml-mode
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode)))

(el-get-bundle haml-mode)
(use-package haml-mode
  :mode (("\\.haml\\'" . haml-mode))
  :init
  (defun my-haml-mode-modify-syntax ()
    (interactive)
    (my-ruby-modify-syntax (list haml-mode-syntax-table)))
  (add-hook 'haml-mode-hook 'my-haml-mode-modify-syntax))


(provide '08-ruby)
;;; 08-ruby.el ends here
