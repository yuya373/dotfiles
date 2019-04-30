;;; 02-prog-mode.el --- prog-mode                    -*- lexical-binding: t; -*-

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

(defun align-regexp-repeated (start stop regexp)
  "Like align-regexp, but repeated for multiple columns. See
http://www.emacswiki.org/emacs/AlignCommands"
  (interactive "r\nsAlign regexp: ")
  (let ((spacing 1)
        (old-buffer-size (buffer-size)))
    ;; If our align regexp is just spaces, then we don't need any
    ;; extra spacing.
    (when (string-match regexp " ")
      (setq spacing 0))
    (align-regexp start stop
                  ;; add space at beginning of regexp
                  (concat "\\([[:space:]]*\\)" regexp)
                  1 spacing t)
    ;; modify stop because align-regexp will add/remove characters
    (align-regexp start (+ stop (- (buffer-size) old-buffer-size))
                  ;; add space at end of regexp
                  (concat regexp "\\([[:space:]]*\\)")
                  1 spacing t)))
;; linum
(el-get-bundle nlinum)
(use-package nlinum
  :commands (nlinum-mode)
  :init
  (setq nlinum-eager nil)
  (setq nlinum-format "%4d ")
  (setq nlinum-delay t)
  (add-hook 'prog-mode-hook 'nlinum-mode))

(use-package elec-pair
  :commands (electric-pair-mode)
  :init
  (add-hook 'after-init-hook 'electric-pair-mode)
  (defun add-ruby-do-arg-pair ()
    (make-local-variable 'electric-pair-pairs)
    (add-to-list 'electric-pair-pairs '(?| . ?|)))
  (add-hook 'enh-ruby-mode-hook
            'add-ruby-do-arg-pair)
  (setq electric-pair-open-newline-between-pairs t))

(el-get-bundle rainbow-delimiters)
(use-package rainbow-delimiters
  :commands (rainbow-delimiters-mode)
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package eldoc
  :diminish eldoc-mode
  :commands (eldoc-mode)
  :init
  (add-hook 'after-init-hook 'global-eldoc-mode))

(el-get-bundle volatile-highlights)
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :commands (volatile-highlights-mode)
  :init
  (add-hook 'prog-mode-hook 'volatile-highlights-mode))

(el-get-bundle electric-operator)
(use-package electric-operator
  :commands (electric-operator-mode)
  :init
  (add-hook 'ess-mode-hook 'electric-operator-mode)
  (add-hook 'python-mode-hook 'electric-operator-mode))

(el-get-bundle quickrun)
(use-package quickrun
  :commands (quickrun
             quickrun-region
             quickrun-with-arg
             quickrun-shell)
  :init
  (setq quickrun-focus-p nil))

(el-get-bundle wbolster/emacs-direnv
  :name direnv)

(use-package direnv
  :commands (direnv-mode)
  :init
  (add-hook 'after-init-hook 'direnv-mode))

(provide '02-prog-mode)
;;; 02-prog-mode.el ends here
