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

(use-package python-mode
  :mode (("\\.py\\'" . python-mode))
  :init
  (add-hook 'python-mode-hook
            #'(lambda ()
                (run-python (python-shell-parse-command))
                (setq python-indent-offset 4)))
  (add-hook 'python-mode-hook #'set-python-helm-dash)
  (add-hook 'inferior-python-mode-hook #'(lambda ()
                                           (auto-complete-mode)
                                           (smartparens-mode)
                                           (setq-local helm-dash-docsets '("Python 2")))))
(el-get-bundle jedi)
(use-package jedi
  :commands (jedi:setup)
  :init
  (setq jedi:complete-on-doc t)
  (add-hook 'python-mode-hook 'jedi:setup)
  :config
  (evil-define-key 'normal jedi-mode-map
    ",hh" 'jedi:show-doc
    ",gd" 'jedi:goto-definition
    ",js" 'jedi:stop-server))

(el-get-bundle elpy)
(use-package elpy
  :commands (elpy-enable)
  :init
  (setq elpy-modules '(elpy-module-sane-defaults
                       elpy-module-eldoc
                       elpy-module-highlight-indentation
                       elpy-module-pyvenv))
  (add-hook 'python-mode-hook 'elpy-enable))

(provide '21-python)
;;; 21-python.el ends here
