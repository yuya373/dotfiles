;;; 21-python.el ---                                 -*- lexical-binding: t; -*-

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

(use-package python-mode
  :mode (("\\.py\\'" . python-mode))
  :init
  (defun my-python-mode-hook ()
    (run-python (python-shell-parse-command))
    (setq-local helm-dash-docsets '("Python 2"))
    (setq python-indent-offset 4))
  (defun my-inf-python-mode-hook ()

    (smartparens-mode)
    (setq-local helm-dash-docsets '("Python 2"))
    )
  (add-hook 'python-mode-hook #'my-python-mode-hook)
  (add-hook 'inferior-python-mode-hook #'my-inf-python-mode-hook)
  :config
  (evil-define-key 'normal python-mode-map
    ",ef" 'python-shell-send-defun
    ",eb" 'python-shell-send-buffer)
  (evil-define-key 'visual python-mode-map
    ",er" 'python-shell-send-region))
;; (el-get-bundle company-jedi)
;; (use-package company-jedi
;;   :commands (company-jedi)
;;   :init
;;   (add-hook 'python-mode-hook
;;             #'(lambda ()
;;                 (make-local-variable 'company-backends)
;;                 (add-to-list 'company-backends 'company-jedi))))

;; (el-get-bundle jedi)
;; (use-package jedi-core
;;   :commands (jedi:setup)
;;   :init
;;   (add-hook 'python-mode-hook 'jedi:setup)
;;   (setq jedi:complete-on-dot t)
;;   (setq jedi:use-shortcuts t)
;;   :config
;;   (evil-define-key 'normal jedi-mode-map
;;     ",g" 'jedi:goto-definition
;;     ",h" 'jedi:show-doc))

(el-get-bundle elpy)
(use-package elpy
  :commands (elpy-enable)
  :init
  (setq elpy-modules '(elpy-module-sane-defaults
                       elpy-module-eldoc
                       elpy-module-highlight-indentation
                       elpy-module-pyvenv
                       elpy-module-company))
  (add-hook 'python-mode-hook 'elpy-enable)
  (add-hook 'python-mode-hook 'elpy-mode))

(provide '21-python)
;;; 21-python.el ends here
