;;; 25-database.el ---                               -*- lexical-binding: t; -*-

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

(el-get-bundle sql)
(el-get-bundle sql-indent)
(el-get-bundle sql-complete)
(el-get-bundle sql-transform)

;; C-c C-c : 'sql-send-paragraph
;; C-c C-r : 'sql-send-region
;; C-c C-s : 'sql-send-string
;; C-c C-b : 'sql-send-buffer
(use-package sql
  :commands (sql-mysql)
  ;; :mode (("\\.sql\\'" . sql-mode))
  :config
  (use-package sql-indent)
  (load-library "sql-complete")
  (use-package sql-transform))

;; (add-hook 'sql-interactive-mode-hook
;;           #'(lambda ()
;;               (interactive)
;;               (set-buffer-process-coding-system 'sjis-unix 'sjis-unix )
;;               (setq show-trailing-whitespace nil)))


;; (sql-set-product-feature
;;  'ms :font-lock 'sql-mode-ms-font-lock-keywords)

;; (sql-get-product-feature 'mysql :sql-program)
;; (defcustom sql-ms-program "sqlcmd"
;;   "Command to start sqlcmd by SQL Server."
;;   :type 'file
;;   :group 'SQL)

;; (sql-set-product-feature
;;  'ms :sql-program 'sql-ms-program)
;; (sql-set-product-feature
;;  'ms :sqli-prompt-regexp "^[0-9]*>")
;; (sql-set-product-feature
;;  'ms :sqli-prompt-length 5)

;; (defcustom sql-ms-login-params
;;   '(user password server database)
;;   "Login parameters to needed to connect to mssql."
;;   :type '(repeat (choice
;;                   (const user)
;;                   (const password)
;;                   (const server)
;;                   (const database)))
;;   :group 'SQL)

;; (defcustom sql-ms-options '("-U" "-P" "-S" "-d")
;;   "List of additional options for `sql-ms-program'."
;;   :type '(repeat string)
;;   :group 'SQL)

;; (defun sql-connect-ms ()
;;   "Connect ti SQL Server DB in a comint buffer."
;;   ;; Do something with `sql-user', `sql-password',
;;   ;; `sql-database', and `sql-server'.
;;   (let ((f #'(lambda (op val)
;;                (unless (string= "" val)
;;                  (setq sql-ms-options
;;                        (append (list op val) sql-ms-options)))))
;;         (params `(("-U" . ,sql-user)("-P" . ,sql-password)
;;                   ("-S" . ,sql-server)("-d" . ,sql-database))))
;;     (dolist (pair params)
;;       (funcall f (car pair)(cdr pair)))
;;     (sql-connect-1 sql-ms-program sql-ms-options)))

;; (sql-set-product-feature
;;  'ms :sqli-login 'sql-ms-login-params)
;; (sql-set-product-feature
;;  'ms :sqli-connect 'sql-connect-ms)

;; (defun run-mssql ()
;;   "Run mssql by SQL Server as an inferior process."
;;   (interactive)
;;   (sql-product-interactive 'ms))

(provide '25-database)
;;; 25-database.el ends here
