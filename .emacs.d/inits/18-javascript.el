;;; 18-javascript.el ---                             -*- lexical-binding: t; -*-

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

(el-get-bundle js2-mode)
(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode)))

(el-get-bundle coffee-mode)
(use-package coffee-mode
  :mode (("\\.coffee\\'" . coffee-mode))
  :init
  (setq coffee-tab-width 2)
  (setq coffee-indent-tabs-mode nil))

(provide '18-javascript)
;;; 18-javascript.el ends here
