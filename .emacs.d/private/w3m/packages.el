;;; packages.el --- w3m Layer packages File for Spacemacs
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
(setq w3m-packages
    '(
      w3m
      ))

;; List of packages to exclude.
(setq w3m-excluded-packages '())

;; For each package, define a function w3m/init-<package-name>
;;
(defun w3m/init-w3m ()
  (use-package w3m
    :config
    (eval-after-load "w3m-search"
      '(add-to-list 'w3m-search-engine-alist
                    '("google" "https://www.google.co.jp/search?q=%s" utf-8)))
    (setq w3m-search-default-engine "google")
    (setq w3m-home-page "http://www.google.co.jp")
    (setq w3m-use-cookies t)
    (setq browse-url-browser-function #'w3m-browse-url)
    ;; (eval-after-load "hyperspec" '(defadvice common-lisp-hyperspec
    ;;                                   (around hyperspec-lookup-w3m () activate)
    ;;                                 (let* ((window-configuration (current-window-configuration))
    ;;                                        (browse-url-browser-function
    ;;                                         `(lambda (url new-window)
    ;;                                            (w3m-browse-url url nil)
    ;;                                            (let ((hs-map (copy-keymap w3m-mode-map)))
    ;;                                              (define-key hs-map (kbd "q")
    ;;                                                (lambda ()
    ;;                                                  (interactive)
    ;;                                                  (kill-buffer nil)
    ;;                                                  (set-window-configuration ,window-configuration)))
    ;;                                              (use-local-map hs-map)))))
    ;;                                   ad-do-it)))
    ))
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package
