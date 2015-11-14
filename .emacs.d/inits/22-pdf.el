;;; 22-pdf.el ---                                    -*- lexical-binding: t; -*-

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

(el-get-bundle pdf-tools)
(use-package pdf-tools
  :commands (pdf-tools-install)
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :init
  (linum-mode -1)
  (add-hook 'pdf-view-mode-hook 'pdf-view-dark-minor-mode)
  (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
  :config
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-define-key 'normal pdf-view-mode-map "g" 'pdf-view-goto-page)
  (evil-define-key 'normal pdf-view-mode-map "j" 'pdf-view-scroll-up-or-next-page)
  (evil-define-key 'normal pdf-view-mode-map "k" 'pdf-view-scroll-down-or-previous-page)
  (evil-define-key 'normal pdf-view-mode-map "h" 'left-char)
  (evil-define-key 'normal pdf-view-mode-map "l" 'right-char)
  (evil-define-key 'normal pdf-view-mode-map "d" 'pdf-view-next-page-command)
  (evil-define-key 'normal pdf-view-mode-map "u" 'pdf-view-previous-page-command)
  (evil-define-key 'normal pdf-view-mode-map "+" 'pdf-view-enlarge)
  (evil-define-key 'normal pdf-view-mode-map "-" 'pdf-view-shrink)
  (evil-define-key 'normal pdf-view-mode-map "=" 'pdf-view-fit-width-to-window)
  (evil-define-key 'normal pdf-view-mode-map "o" 'pdf-outline)
  (evil-define-key 'normal pdf-view-mode-map "b" 'pdf-view-position-to-register)
  (evil-define-key 'normal pdf-view-mode-map "B" 'pdf-view-jump-to-register)
  (defun mcc-pdf-view-save ()
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (when (eql major-mode 'pdf-view-mode)
                    (setq-local pdf-view-last-visited-page
                                (pdf-view-current-page))))))

  (defun mcc-pdf-view-restore ()
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (when (eql major-mode 'pdf-view-mode)
                    (pdf-view-goto-page pdf-view-last-visited-page)))))

  (add-hook 'popwin:before-popup-hook #'mcc-pdf-view-save)
  (add-hook 'popwin:after-popup-hook #'mcc-pdf-view-restore)
  ;; (use-package pdf-annot)
  (use-package pdf-links)
  (use-package pdf-info)
  (use-package pdf-misc)
  (use-package pdf-sync)
  (use-package pdf-outline)
  (use-package pdf-occur))

(provide '22-pdf)
;;; 22-pdf.el ends here
