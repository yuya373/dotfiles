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
  :mode (("\\.rs\\'" . rust-mode))
  :init
  (setq rust-format-on-save t)
  :config
  (modify-syntax-entry ?! "_" rust-mode-syntax-table)
  (modify-syntax-entry ?_ "w" rust-mode-syntax-table)
  )

(el-get-bundle dash)
(el-get-bundle s)
(el-get-bundle racer-rust/emacs-racer
  :name racer)
(use-package racer
  :commands (racer-mode)
  :diminish racer-mode
  :init
  ;; (global-set-key (kbd "TAB") #'company-indent-or-complete-common)
  (defun my-racer-setup ()
    ;; (add-to-list 'company-backends '(company-capf :with company-dabbrev))
    )
  (add-hook 'racer-mode-hook 'my-racer-setup)
  (add-hook 'racer-mode-hook 'eldoc-mode)
  (add-hook 'rust-mode-hook 'racer-mode)
  :config

  (evil-define-key 'normal racer-mode-map
    ",h" 'racer-describe
    ",d" 'racer-find-definition))

(el-get-bundle flycheck-rust)
(use-package flycheck-rust
  :commands (flycheck-rust-setup)
  :init
  (add-hook 'flycheck-mode-hook 'flycheck-rust-setup))

(el-get-bundle cargo)
(use-package cargo
  :commands (cargo-minor-mode)
  :diminish cargo-minor-mode
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode)
  :config
  (evil-define-key 'normal cargo-minor-mode-map
    ",C" 'cargo-process-clean
    ",d" 'cargo-process-doc
    ",b" 'cargo-process-build
    ",n" 'cargo-process-new
    ",i" 'cargo-process-init
    ",r" 'cargo-process-run
    ",s" 'cargo-process-search
    ",u" 'cargo-process-update
    ",B" 'cargo-process-bench
    ",t" 'cargo-process-test
    )
  )

(el-get-bundle toml-mode)
(use-package toml-mode
  :mode (("\\.toml\\'" . toml-mode)))

(provide '28-rust)
;;; 28-rust.el ends here
