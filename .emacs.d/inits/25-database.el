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

(use-package sql
  :commands (sql-postgres sql-mysql)
  :mode (("\\.sql\\'" . sql-mode))
  :init
  (defun mysql-buffer ()
    (interactive)
    (let* ((buf-name "*MySQL Editor*")
           (buf (get-buffer-create buf-name)))
      (with-current-buffer buf (sql-mode))
      (switch-to-buffer-other-window buf))
    (let ((cur-win-conf (current-window-configuration)))
      (delete-window (get-buffer-window (sql-mysql)))
      (set-window-configuration cur-win-conf)))
  (setq sql-electric-stuff 'semicolon)
  (setq sql-pop-to-buffer-after-send-region t)
  (setq sql-indent-offset 2)
  :config
  (use-package sql-indent)
  (load-library "sql-complete")
  (use-package sql-transform)
  (evil-define-key 'normal sql-mode-map
    ",eb" 'sql-send-buffer
    ",ep" 'sql-send-paragraph
    ",es" 'sql-send-string
    ",sb" 'sql-set-sqli-buffer)
  (evil-define-key 'visual sql-mode-map
    ",er" 'sql-send-region))

(provide '25-database)
;;; 25-database.el ends here
