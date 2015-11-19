;;; 23-statistic.el ---                              -*- lexical-binding: t; -*-

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

(el-get-bundle ess)
(add-to-list 'load-path
             (locate-user-emacs-file "el-get/ess/lisp"))
(el-get-bundle ess-R-data-view)
(el-get-bundle ess-R-object-popup)
(el-get-bundle helm-R)

(use-package ess-site
  :mode (("\\.[rR]\\'" . R-mode))
  :init
  (add-hook 'ess-mode-hook 'linum-mode)
  (add-hook 'ess-mode-hook 'smartparens-mode)
  (add-hook 'inferior-ess-mode-hook 'smartparens-mode)
  (setq ess-use-auto-complete t
        ess-use-eldoc t
        ess-use-ido nil
        ess-ask-for-ess-directory nil)
  :config
  (use-package ess-R-data-view
    :config
    (evil-define-key 'normal ess-mode-map
      ",vd" 'ess-R-dv-pprint))
  (use-package ess-R-object-popup
    :config
    (evil-define-key 'normal ess-mode-map
      ",op" 'ess-R-object-popup))

  (evil-define-key 'visual ess-mode-map
    ",er" 'ess-eval-region
    ",eR" 'ess-eval-region-and-go)
  (evil-define-key 'normal ess-mode-map
    ",rs" 'R
    ",rq" 'ess-quit
    ",ee" 'ess-eval-region-or-function-or-paragraph-and-step
    ",eb" 'ess-eval-buffer
    ",eB" 'ess-eval-buffer-and-go
    ",ef" 'ess-eval-function
    ",eF" 'ess-eval-function-and-go
    ",ep" 'ess-eval-paragraph
    ",eP" 'ess-eval-paragraph-and-go
    ",el" 'ess-eval-line
    ",eL" 'ess-eval-line-and-go
    ",h" 'ess-display-help-on-object
    ",H" 'ess-display-help-apropos))

;; (use-package helm-R)


(provide '23-statistic)
;;; 23-statistic.el ends here
