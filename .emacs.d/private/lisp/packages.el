;;; packages.el --- lisp Layer packages File for Spacemacs
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
(setq lisp-packages
    '(
      ac-slime
      ))

;; List of packages to exclude.
(setq lisp-excluded-packages '())

;; For each package, define a function lisp/init-<package-name>
;;
(defun lisp/init-ac-slime ()
  (use-package ac-slime
    :config
    (add-hook 'slime-mode-hook (lambda () (set-up-slime-ac t)))
    ;; (add-hook 'slime-repl-mode-hook (lambda () (set-up-slime-ac t)))
    (eval-after-load "auto-complete"
      '(add-to-list 'ac-modes 'slime-repl-mode-hook)))
  )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
