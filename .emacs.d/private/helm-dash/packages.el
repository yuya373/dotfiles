;;; packages.el --- helm-dash Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq helm-dash-packages
    '(
      helm-dash
      ))

;; List of packages to exclude.
(setq helm-dash-excluded-packages '())

;; For each package, define a function helm-dash/init-<package-name>
;;
(defun helm-dash/init-helm-dash ()
  (use-package helm-dash
    :config
    (evil-leader/set-key "dc" 'helm-dash)
    (evil-leader/set-key "da" 'helm-dash-at-point)
    (evil-leader/set-key "di" 'helm-dash-install-docset)
    (setq helm-dash-min-length 0)
    (setq helm-dash-browser-func 'eww)
    (defun lisp-doc ()
      (interactive)
      (setq-local helm-dash-docsets '("Common Lisp")))
    (add-hook 'lisp-mode-hook 'lisp-doc)
    (defun rails-doc ()
      (interactive)
      (setq-local helm-dash-docsets '("Ruby on Rails")))
    (add-hook 'projectile-rails-mode-hook 'rails-doc)
    (defun ruby-doc ()
      (interactive)
      (setq-local helm-dash-docsets '("Ruby")))
    (add-hook 'enh-ruby-mode 'ruby-doc)
    )
  )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
