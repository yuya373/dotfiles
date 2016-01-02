;;; 28-rust.el ---                                   -*- lexical-binding: t; -*-

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

(el-get-bundle rust-mode)
(use-package rust-mode
  :mode (("\\.rs\\'" . rust-mode)))

(el-get-bundle racer-rust/emacs-racer)
(use-package racer
  :commands (racer-mode)
  :init
  (setq racer-rust-src-path (expand-file-name "~/rustc-1.5.0/src"))
  (add-hook 'rust-mode-hook 'racer-mode)
  (add-hook 'racer-mode-hook 'eldoc-mode))

(el-get-bundle company-racer)
(use-package company-racer
  :commands (company-racer)
  :init
  (defun my-company-racer ()
    (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-racer))
  (add-hook 'racer-mode-hook 'my-company-racer))

(provide '28-rust)
;;; 28-rust.el ends here
