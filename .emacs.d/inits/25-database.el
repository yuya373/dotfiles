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

(eval-when-compile
  (require 'evil))

(use-package sql
  :ensure t
  :commands (sql-postgres sql-mysql)
  :mode (("\\.sql\\'" . sql-mode))
  :init
  (defun mysql-buffer ()
    (interactive)
    (mysql-get-interactive-buffer)
    (mysql-run-with-hidden-buffer))

  (defun psql-buffer ()
    (interactive)
    (psql-get-interactive-buffer)
    (psql-run-with-hidden-buffer)
    )

  (defun mysql-ssh-buffer ()
    (interactive)
    (mysql-get-interactive-buffer)
    (mysql-run-with-hidden-buffer t))

  (defun mysql-get-interactive-buffer ()
    (let* ((buf-name "*MySQL Editor*")
           (buf (get-buffer-create buf-name)))
      (with-current-buffer buf
        (sql-mode)
        (sql-set-product 'mysql))
      (switch-to-buffer-other-window buf)))

  (defun psql-get-interactive-buffer ()
    (let* ((buf-name "*Postgres Editor*")
           (buf (get-buffer-create buf-name)))
      (with-current-buffer buf
        (sql-mode)
        (sql-set-product 'postgres))
      (switch-to-buffer-other-window buf)
      buf))

  (defun mysql-with-ssh ()
    (let* ((host (read-from-minibuffer "SSH Host: "))
           (default-directory (concat "/ssh:" host ":")))
      (mysql-run-with-hidden-buffer)))

  (defun mysql-run-with-hidden-buffer (&optional ssh)
    (let ((cur-win-conf (current-window-configuration)))
      (delete-window

       (get-buffer-window
        (if ssh
            (mysql-with-ssh)
          (sql-mysql))))
      (set-window-configuration cur-win-conf)))

  (defun psql-run-with-hidden-buffer ()
    (let ((cur-win-conf (current-window-configuration)))
      (delete-window
       (get-buffer-window
        (sql-postgres)))
      (set-window-configuration cur-win-conf)))

  (setq sql-electric-stuff 'semicolon)
  (setq sql-pop-to-buffer-after-send-region t)
  (setq sql-indent-offset 2)
  :config
  (evil-define-key 'normal sql-mode-map
    ",eb" 'sql-send-buffer
    ",ep" 'sql-send-paragraph
    ",es" 'sql-send-string
    ",sb" 'sql-set-sqli-buffer)
  (evil-define-key 'visual sql-mode-map
    ",er" 'sql-send-region))

(use-package sql-indent
  :ensure t
  :after (sql))

(use-package sqlformat
  :ensure t
  :init
  (setq sqlformat-command 'sqlfluff)
  (setq sqlformat-args '("--dialect" "postgres"))
  (evil-define-key 'normal sql-mode-map
    ",f" 'sqlformat-buffer)
  :config
  (reformatter-define sqlformat
    :program (pcase sqlformat-command
               (`sqlformat "sqlformat")
               (`pgformatter "pg_format")
               (`sqlfluff "sqlfluff")
               (`sql-formatter "sql-formatter"))
    :args (pcase sqlformat-command
            (`sqlformat  (append sqlformat-args '("-r" "-")))
            (`pgformatter (append sqlformat-args '("-")))
            (`sqlfluff (append '("format") sqlformat-args '("-")))
            (`sql-formatter sqlformat-args))
    :lighter " SQLFmt"
    :group 'sqlformat
    :exit-code-success-p (lambda (_x) t))


  (defun around-sqlformat-region (orig-fun &rest args)
    (let ((default-directory (or (vc-git-root (buffer-file-name)) default-directory)))
      (apply orig-fun args)))

  (advice-add 'sqlformat-region :around 'around-sqlformat-region)

  )

(provide '25-database)
;;; 25-database.el ends here
