;;; 49-posframe.el ---                               -*- lexical-binding: t; -*-

;; Copyright (C) 2025  DESKTOP2

;; Author: DESKTOP2 <yuya373@DESKTOP2>
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

(use-package posframe
  :ensure t)

(defun update-posframe-min-with (&optional _)
  (let* ((w (frame-width)))
    (setq vertico-posframe-min-width w)
    (setq transient-posframe-parameters `((min-width . ,w)))
    (setq which-key-posframe-parameters `((min-width . ,w)
                                          (left-fringe . 10)
                                          (right-fringe . 10)))))
(add-to-list 'window-size-change-functions 'update-posframe-min-with)

(unless (package-installed-p 'vertico-posframe)
  (package-vc-install "https://github.com/tumashu/vertico-posframe"))
(use-package vertico-posframe
  :after (vertico)
  :config
  (vertico-posframe-mode)
  (setq vertico-posframe-poshandler 'posframe-poshandler-frame-bottom-center))

(use-package transient-posframe
  :after (transient)
  :ensure t
  :config
  (transient-posframe-mode)
  (setq transient-posframe-poshandler 'posframe-poshandler-frame-bottom-center))

(use-package which-key-posframe
  :after (which-key)
  :ensure t
  :config
  (which-key-posframe-mode)
  (setq which-key-posframe-poshandler 'posframe-poshandler-frame-bottom-center))

(use-package ddskk-posframe
  :after (ddskk)
  :ensure t
  :config
  (ddskk-posframe-mode))

(provide '49-posframe)
;;; 49-posframe.el ends here
