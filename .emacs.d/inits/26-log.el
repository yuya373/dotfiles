;;; 26-log.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2016  南優也

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

(el-get-bundle logview)
(use-package logview
  :mode (("\\.log?\\'" . log4j-mode))
  :init
  (add-hook 'logview-mode-hook 'read-only-mode)
  )

(el-get-bundle log4j-mode)
(use-package log4j-mode
  :mode (("\\.log?\\'" . log4j-mode))
  :init
  (add-hook 'log4j-mode-hook 'read-only-mode))

(el-get-bundle command-log-mode)
(use-package command-log-mode
  :commands (clm/open-command-log-buffer
             global-command-log-mode)
  :diminish command-log-mode
  :init
  (setq command-log-mode-auto-show nil)
  (setq clm/logging-dir "~/.emacs.d/log/")
  (add-hook 'window-setup-hook 'global-command-log-mode)
  ;; (add-hook 'global-command-log-mode-hook 'clm/open-command-log-buffer)
  ;; (add-hook 'kill-emacs-hook 'clm/save-command-log)
  ;; (remove-hook 'kill-emacs-hook 'clm/save-command-log)
  )

(el-get-bundle yuya373/major-mode-log)
(add-to-list 'load-path (concat user-emacs-directory
                                "el-get/major-mode-log"))
(use-package major-mode-log
  :commands (global-major-mode-log-mode)
  :init
  ;; (add-hook 'after-init-hook 'global-major-mode-log-mode)
  )

(provide '26-log)
;;; 26-log.el ends here
