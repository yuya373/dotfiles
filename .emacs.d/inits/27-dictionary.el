;;; 27-dictionary.el ---                             -*- lexical-binding: t; -*-

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

(el-get-bundle google-translate)
(use-package google-translate
  :commands (google-translate-at-point
             google-translate-query-translate
             google-translate-query-translate-reverse
             google-translate-smooth-translate)
  :init
  (setq google-translate-translation-directions-alist '(("en" . "ja")
                                                        ("ja" . "en"))
        google-translate-input-method-auto-toggling t)
  :config
  (use-package google-translate-smooth-ui)
  (setq google-translate-default-source-language "en"
        google-translate-default-target-language "ja"))

(el-get-bundle syohex/emacs-codic)
(use-package codic
  :commands (codic codic-translate))

(provide '27-dictionary)
;;; 27-dictionary.el ends here
