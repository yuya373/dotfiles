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

(eval-when-compile
  (require 'evil)
  (el-get-bundle pdf-tools)
  (require 'pdf-tools))

(el-get-bundle pdf-tools)
(use-package pdf-tools
  :commands (pdf-tools-install)
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :init
  (add-hook 'pdf-view-mode-hook #'(lambda () (linum-mode -1)))
  (add-hook 'pdf-view-mode-hook 'pdf-view-dark-minor-mode)
  (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode)
  (add-hook 'pdf-view-mode-hook #'(lambda () (blink-cursor-mode -1)))
  :config
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (evil-define-key 'normal pdf-view-mode-map
    "g" 'pdf-view-goto-page
    "j" 'pdf-view-scroll-up-or-next-page
    "k" 'pdf-view-scroll-down-or-previous-page
    "h" 'left-char
    "l" 'right-char
    "d" 'pdf-view-next-page-command
    "u" 'pdf-view-previous-page-command
    "+" 'pdf-view-enlarge
    "-" 'pdf-view-shrink
    "=" 'pdf-view-fit-width-to-window
    "o" 'pdf-outline
    "b" 'pdf-view-position-to-register
    "B" 'pdf-view-jump-to-register)
  (defun mcc-pdf-view-save ()
    (message "mcc-pdf-view-save called!!!")
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (when (eql major-mode 'pdf-view-mode)
                    (setq-local pdf-view-last-display-size
                                pdf-view-display-size)
                    (setq-local pdf-view-last-visited-page
                                (pdf-view-current-page))))))

  (defun mcc-pdf-view-restore ()
    (message "mcc-pdf-view-restore called!!!")
    (cl-loop for win in (window-list)
             do (with-selected-window win
                  (message "%s" major-mode)
                  (when (eql major-mode 'pdf-view-mode)
                    (message "restore page: %s"
                             pdf-view-last-visited-page)
                    (setf (pdf-view-current-page win)
                          pdf-view-last-visited-page)
                    (setq pdf-view-display-size
                          pdf-view-last-display-size)
                    (pdf-view-redisplay win)))))

  (add-hook 'popwin:before-popup-hook #'mcc-pdf-view-save)
  (add-hook 'popwin:after-popup-hook #'mcc-pdf-view-restore)
  ;; (add-hook 'helm-before-initialize-hook #'mcc-pdf-view-save t)
  ;; (remove-hook 'helm-before-initialize-hook #'mcc-pdf-view-save)
  ;; (add-hook 'helm-cleanup-hook #'mcc-pdf-view-restore t)
  ;; (remove-hook 'helm-cleanup-hook #'mcc-pdf-view-restore)
 ; (use-package pdf-annot)
  (use-package pdf-links)
  (use-package pdf-info)
  (use-package pdf-misc)
  (use-package pdf-sync)
  (use-package pdf-outline
    :config
    (evil-define-key 'normal pdf-outline-buffer-mode-map
      "o" 'pdf-outline-follow-link-and-quit
      "q" 'quit-window
      "c" 'pdf-outline-move-to-current-page
      "t" 'outline-toggle-children))
  (use-package pdf-occur))

(provide '22-pdf)
;;; 22-pdf.el ends here
