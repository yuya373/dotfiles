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

(el-get-bundle brotzeit/rustic)
(el-get-bundle xterm-color)
(use-package rustic
  :init
  (setq rustic-lsp-format t
        ;; rustic-lsp-server 'rust-analyzer
        rustic-lsp-server 'rls
        )
  :config
  (evil-define-key 'normal rustic-mode-map
    ",p" 'rustic-popup
    ",CC" 'rustic-compile
    ",CR" 'rustic-recompile
    ",cb" 'rustic-cargo-build
    ",cc" 'rustic-cargo-check
    ",cr" 'rustic-cargo-run
    ",cf" 'rustic-cargo-fmt
    ",ct" 'rustic-cargo-test
    ",cT" 'rustic-cargo-current-test
    ",cl" 'rustic-cargo-clippy
    ",co" 'rustic-cargo-outdated
    ",f" 'rustic-format-buffer
    ))

(el-get-bundle toml-mode)
(use-package toml-mode
  :mode (("\\.toml\\'" . toml-mode)))

(provide '28-rust)
;;; 28-rust.el ends here
