;;; 43-typescript.el ---                             -*- lexical-binding: t; -*-

;; Copyright (C) 2018

;; Author:  <yuya373@archlinux>
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

(eval-when-compile
  (require 'use-package))



(use-package add-node-modules-path
  :ensure t
  :init
  :config
  (add-to-list 'add-node-modules-path-command "yarn bin")
  (add-to-list 'add-node-modules-path-command "pnpm bin")

  (defun vc-root-add-node-modules-path-command ()
    (interactive)
    (if-let((vc-root (vc-root-dir)))
        (let ((default-directory vc-root))
          (add-node-modules-path))
      (if-let ((current (locate-dominating-file default-directory "package.json"))
               (parent-dir (file-name-directory (directory-file-name current)))
               (parent (locate-dominating-file parent-dir "package.json")))
          (let ((default-directory parent))
            (add-node-modules-path)))))
  (with-eval-after-load 'typescript-ts-mode
    (add-hook 'typescript-ts-mode-hook 'add-node-modules-path -100)
    (add-hook 'typescript-ts-mode-hook 'vc-root-add-node-modules-path-command -100)
    (add-hook 'tsx-ts-mode-hook 'add-node-modules-path -100)
    (add-hook 'tsx-ts-mode-hook 'vc-root-add-node-modules-path-command -100))
  )

(use-package typescript-ts-mode
  :ensure t
  :mode (("\\.ts\\'" . typescript-ts-mode)
         ("\\.tsx\\'" . tsx-ts-mode))
  :config
  (defun eslint-fix ()
    (interactive)
    (call-process "eslint" nil "*ESLint Errors*" nil "--fix" buffer-file-name)
    (revert-buffer t t t))

  (with-eval-after-load 'evil-collection
    (evil-collection-define-key 'normal 'typescript-ts-mode-map
      (kbd ",f") 'eslint-fix)
    (evil-collection-define-key 'normal 'tsx-ts-mode-map
      (kbd ",f") 'eslint-fix)
    )

  ;; (defun enable-eslint-auto-fix ()
  ;;   (add-hook 'after-save-hook 'eslint-fix nil t))
  ;; (add-hook 'typescript-ts-mode-hook 'enable-eslint-auto-fix)
  ;; (add-hook 'tsx-ts-mode-hook 'enable-eslint-auto-fix)
  )


(provide '43-typescript)
;;; 43-typescript.el ends here
