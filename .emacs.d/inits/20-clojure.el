;;; 20-clojure.el ---                                -*- lexical-binding: t; -*-

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

(el-get-bundle clojure-mode)
(use-package clojure-mode
  :mode (("\\.clj\\'" . clojure-mode))
  :init
  (defun my-clojure-mode-hook ()
    (setq-local helm-dash-docsets '("Clojure"))
    (cider-mode 1))
  (add-hook 'clojure-mode-hook #'my-clojure-mode-hook)
  :config
  (put-clojure-indent 'do 0)
  (put-clojure-indent 'my-ns/do 1)
  (define-clojure-indent (-> 1))
  (define-clojure-indent (->> 1)))

(el-get-bundle cider)
(use-package cider
  :commands (cider-mode)
  :init
  (setq cider-stacktrace-fill-column 80)
  (add-hook 'cider-mode-hook #'(lambda () (eldoc-mode 1))))

(el-get-bundle ac-cider)
(use-package ac-cider
  :commands (ac-cider-setup ac-flyspell-workaround)
  :init
  (add-hook 'cider-mode-hook 'ac-flyspell-workaround)
  (add-hook 'cider-mode-hook 'ac-cider-setup)
  (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
  :config
  (eval-after-load "auto-complete"
    '(progn
       (add-to-list 'ac-modes 'cider-mode)
       (add-to-list 'ac-modes 'cider-repl-mode)))
  (evil-define-key 'normal cider-stacktrace-mode-map
    "q" 'cider-popup-buffer-quit-function)
  (evil-define-key 'normal cider-inspector-mode-map
    "q" 'cider-popup-buffer-quit-function)
  (evil-define-key 'visual cider-mode-map
    ",er" 'cider-eval-region)
  (evil-define-key 'normal cider-mode-map
    ",cj" 'cider-jack-in
    ",cJ" 'cider-connect
    ",cr" 'cider-refresh
    ",cq" 'cider-quit
    ",ci" 'cider-inspect
    ",cu" 'cider-undef
    ",gn" 'cider-browse-ns--find-at-point
    ",hn" 'cider-browse-ns--doc-at-point
    ",hN" 'cider-browse-ns-all
    ",ha" 'cider-apropos
    ",hA" 'cider-apropos-documentation
    ",hd" 'cider-doc
    ",hg" 'cider-grimoire
    ",hG" 'cider-grimoire-web
    ",hj" 'cider-javadoc
    ",fv" 'cider-find-var
    ",fn" 'cider-find-ns
    ",fr" 'cider-find-resource
    ",eb" 'cider-eval-buffer
    ",ef" 'cider-eval-defun-at-point
    ",eF" 'cider-pprint-eval-defun-at-point
    ",es" 'cider-pprint-eval-last-sexp
    ",eS" 'cider-eval-last-sexp-to-repl
    ",en" 'cider-eval-ns-form
    ",me" 'cider-macroexpand-1
    ",ma" 'cider-macroexpand-all
    ",r" 'cider-switch-to-repl-buffer
    ",R" 'cider-load-buffer-and-switch-to-repl-buffer
    ",lb" 'cider-load-buffer
    ",lf" 'cider-load-file
    ",tt" 'cider-test-run-test
    ",ta" 'cider-test-run-test
    ",tr" 'cider-test-rerun-tests
    ",tv" 'cider-test-show-report))

;; can not connect with Melpa
;; Error (el-get): while installing flycheck-clojure: http://melpa.org/packages/flycheck-20151014.1156.tar: Not found
(el-get-bundle flycheck-clojure)
(el-get-bundle clojure-emacs/squiggly-clojure
  :name flycheck-clojure)
(use-package flycheck-clojure
  :commands (flycheck-clojure-setup)
  :init
  (add-to-list 'load-path
               (locate-user-emacs-file
                "el-get/flycheck-clojure/elisp/flycheck-clojure/"))
  (add-hook 'clojure-mode-hook 'flycheck-clojure-setup))

(provide '20-clojure)
;;; 20-clojure.el ends here