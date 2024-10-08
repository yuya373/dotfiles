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

(use-package rustic
  :ensure t
  :init
  (setq rustic-lsp-setup-p t
        rustic-lsp-format t
        rustic-lsp-server 'rust-analyzer
        rustic-format-trigger 'on-compile
        )
  (setq rustic-default-test-arguments "-- --nocapture")
  ;; (setq rustic-default-test-arguments nil)
  (setq rustic-cargo-check-arguments "--benches --tests --all-features --workspace")
  (setq rustic-default-clippy-arguments "--all --tests --workspace")
  (setq flycheck-rust-check-tests nil)
  ;; (defun rustic-init-flycheck ()
  ;;   (interactive)
  ;;   ;; (setq-local flycheck-check-syntax-automatically '(save))
  ;;   (add-to-list 'flycheck-checkers 'rustic-clippy)
  ;;   (flycheck-add-next-checker 'lsp 'rustic-clippy)
  ;;   ;; (add-to-list 'flycheck-checkers 'rustic-check)
  ;;   ;; (flycheck-add-next-checker 'lsp 'rustic-check)
  ;;   )
  ;; (add-hook 'lsp-mode-hook 'rustic-init-flycheck)
  :config
  ;; (flycheck-define-checker rustic-check
  ;;   "A Rust syntax checker using check."
  ;;   :command ("cargo" "check"
  ;;             ;; "--all-targets"
  ;;             "--message-format=json")
  ;;   :error-parser flycheck-parse-cargo-rustc
  ;;   :error-filter flycheck-rust-error-filter
  ;;   :error-explainer flycheck-rust-error-explainer
  ;;   :modes rustic-mode
  ;;   :predicate flycheck-buffer-saved-p
  ;;   :enabled (lambda () (flycheck-rust-manifest-directory))
  ;;   :working-directory (lambda (_) (flycheck-rust-manifest-directory))
  ;;   :verify (lambda (_)
  ;;             (and buffer-file-name
  ;;                  (let ((has-toml (flycheck-rust-manifest-directory)))
  ;;                    (list (flycheck-verification-result-new
  ;;                           :label "Cargo.toml"
  ;;                           :message (if has-toml "Found" "Missing")
  ;;                           :face (if has-toml 'success '(bold warning))))))))

  (defun rustic-cargo-current-test ()
    "Run 'cargo test' for the test near point."
    (interactive)
    (rustic-compilation-process-live)
    (-if-let (test-to-run (setq rustic-test-arguments
                                (format "%s"
                                        (rustic-cargo--get-test-target)
                                        )
                                ))
        (rustic-cargo-run-test test-to-run)
      (message "Could not find test at point.")))
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
    ",f" 'rustic-cargo-fmt
    ))

(use-package toml-mode
  :ensure t
  :mode (("\\.toml\\'" . toml-mode)))

(provide '28-rust)
;;; 28-rust.el ends here
