;;; 45-terraform.el ---                              -*- lexical-binding: t; -*-

;; Copyright (C) 2019  南優也

;; Author: 南優也 <yuya373@minamiyuuyanoMacBook-Pro.local>
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
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:


(el-get-bundle terraform-mode)
(use-package terraform-mode
  :mode (("\\.tf\\(vars\\)?\\'" . terraform-mode)))

(el-get-bundle company-terraform)
(use-package company-terraform
  :commands (company-terraform-init)
  :init
  (add-hook 'terraform-mode-hook 'company-terraform-init))

(provide '45-terraform)
;;; 45-terraform.el ends here
