;;; 05-auto-complete.el ---                          -*- lexical-binding: t; -*-

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

;; (unless (package-installed-p 'copilot)
;;   (package-vc-install "https://github.com/copilot-emacs/copilot.el"))
;; (use-package copilot
;;   :init
;;   (add-hook 'prog-mode-hook 'copilot-mode)
;;   (add-hook 'text-mode-hook 'copilot-mode)
;;   (add-to-list 'warning-suppress-types '(copilot copilot-exceeds-max-char))
;;   (setq copilot-indent-offset-warning-disable t)
;;   (setq copilot-idle-delay 0.5)
;;   :config
;;   (unless (file-exists-p (copilot-server-executable))
;;     (copilot-install-server))
;;   ;; (defun my/copilot-tab ()
;;   ;;   (interactive)
;;   ;;   (or (copilot-accept-completion-by-word)
;;   ;;       (indent-for-tab-command)))
;;   (evil-define-key 'insert copilot-mode-map
;;     (kbd "C-<tab>") #'copilot-accept-completion
;;     )
;;   (advice-add 'copilot-complete :around 'disable-copilot-complete-when-skk-henkan)
;;   (defun disable-copilot-complete-when-skk-henkan (func &rest args)
;;     (unless skk-henkan-mode
;;       (apply func args)))
;;   )

(use-package yasnippet-snippets
  :ensure t
  :after (yasnippet))

(use-package yasnippet
  :ensure t
  :commands (yas-global-mode)
  :diminish yas-minor-mode
  :init
  (add-hook 'after-init-hook 'yas-global-mode))

(use-package orderless
  :ensure t)

(use-package corfu
  :ensure t
  :config
  (setq corfu-auto t)
  (setq corfu-auto-prefix 2)
  (setq corfu-preview-current nil)
  (setq corfu-cycle t)
  (setq completion-styles '(orderless basic))
  (setq tab-always-indent 'complete)
  (define-key corfu-mode-map (kbd "C-n") 'corfu-next)
  (define-key corfu-mode-map (kbd "C-p") 'corfu-previous)
  (define-key corfu-mode-map (kbd "C-h") nil)
  (define-key corfu-map (kbd "C-h") nil)
  (defun corfu-mode-set-faces ()
    (custom-set-faces
     '(corfu-current ((t (:inherit corfu-default :extend t :inverse-video nil :weight bold))))
     '(orderless-match-face-0 ((t (:foreground "#2aa198"))))))
  (add-hook 'corfu-mode-hook 'corfu-mode-set-faces)
  (global-corfu-mode))

(use-package corfu-popupinfo
  :after (corfu)
  :config
  (define-key corfu-popupinfo-map (kbd "C-h") nil)
  (corfu-popupinfo-mode))
(use-package corfu-history
  :after (corfu)
  :config
  (corfu-history-mode))
(use-package nerd-icons-corfu
  :ensure t
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
(use-package cape
  :ensure t
  :after (corfu)
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

(use-package know-your-http-well :ensure t)
(use-package editorconfig :ensure t
  :config
  (editorconfig-mode 1))


(use-package pos-tip :ensure t)
(use-package lsp-treemacs :ensure t)
(use-package lsp-mode
  :ensure t
  :commands (lsp)
  :diminish lsp-mode
  :init
  (add-hook 'typescript-ts-mode-hook 'lsp)
  (add-hook 'tsx-ts-mode-hook 'lsp)
  (add-hook 'rjsx-mode-hook 'lsp)
  (add-hook 'web-mode-hook 'lsp)
  (add-hook 'enh-ruby-mode-hook 'lsp)
  (add-hook 'go-mode-hook 'lsp)
  (add-hook 'go-ts-mode-hook 'lsp)
  (add-hook 'rustic-mode-hook 'lsp)
  (add-hook 'scala-mode-hook 'lsp)
  (add-hook 'yaml-mode-hook 'lsp)
  (add-hook 'markdown-mode-hook 'lsp)

  (setq lsp-auto-guess-root t
        lsp-auto-touch-files nil
        lsp-enable-snippet t
        lsp-auto-configure t
        lsp-enable-xref t
        lsp-enable-indentation t
        lsp-enable-on-type-formatting t
        lsp-document-sync-method nil
        lsp-report-if-no-buffer t
        lsp-auto-execute-action nil

        lsp-lens-auto-enable t
        lsp-lens-check-interval 1
        lsp-lens-debounce-interval 2

        lsp-idle-delay 1
        lsp-links-check-internal 1

        lsp-diagnostic-package ':flycheck
        lsp-flycheck-live-reporting nil

        lsp-signature-auto-activate nil
        lsp-eldoc-render-all nil
        lsp-eldoc-enable-hover nil

        lsp-completion-enable t
        lsp-completion-provider :none

        lsp-inline-completion-enable nil

        lsp-log-io nil

        lsp-file-watch-threshold nil
        lsp-enable-file-watchers t

        lsp-response-timeout 10

        ;; lsp-rust-clippy-preference "on"
        ;; lsp-rust-server 'rls
        lsp-rust-server 'rust-analyzer
        ;; lsp-rust-analyzer-cargo-watch-enable nil
        lsp-rust-analyzer-cargo-watch-enable t
        lsp-rust-analyzer-cargo-all-targets nil
        ;; lsp-rust-analyzer-cargo-watch-command "clippy"
        ;; lsp-rust-analyzer-cargo-watch-args ["--message-format=json"]
        ;; lsp-rust-analyzer-cargo-override-command ["-x" "clippy" "--message-format=json"]
        lsp-rust-analyzer-server-display-inlay-hints t
        lsp-rust-analyzer-display-chaining-hints t
        lsp-rust-analyzer-display-parameter-hints t
        lsp-rust-analyzer-proc-macro-enable t
        lsp-rust-analyzer-experimental-proc-attr-macros t
        lsp-rust-all-features t
        standard-indent 2
        lsp-copilot-enabled nil
        )
  (defun my-lsp-inhibit-hooks ()
    (setq-local lsp-inhibit-lsp-hooks t))
  (defun my-lsp-activate-hooks ()
    (setq-local lsp-inhibit-lsp-hooks nil))
  (add-hook 'evil-normal-state-entry-hook #'my-lsp-activate-hooks)
  (add-hook 'evil-normal-state-exit-hook #'my-lsp-inhibit-hooks)


  (defun my-enable-eslint-for-next-of-lsp (&rest _)
    (flycheck-add-next-checker 'lsp 'javascript-eslint))

  (advice-add 'lsp-diagnostics--flycheck-enable
              :after
              'my-enable-eslint-for-next-of-lsp)
  :config
  (use-package lsp-lens)
  (use-package lsp-modeline)
  (use-package lsp-headerline)
  (use-package lsp-diagnostics)
  (use-package lsp-completion)

  ;; (defun my-lsp-completion-mode-hook-fn ()
  ;;   (interactive)
  ;;   (setq-local company-backends (cl-remove 'company-capf company-backends)))
  ;; (add-hook 'lsp-completion-mode-hook 'my-lsp-completion-mode-hook-fn)

  (defface my:lsp-modeline-code-actions-face-14
    '((t (:inherit homoglyph :foreground "#002b36" :bold t)))
    "Used to modeline code actions"
    :group 'lsp-mode)
  (setq lsp-modeline-code-actions-face 'my:lsp-modeline-code-actions-face-14)

  (evil-collection-define-key 'normal 'lsp-mode-map
    ",hs" 'lsp-describe-session
    "K" 'lsp-describe-thing-at-point
    ",aa" 'lsp-execute-code-action
    ",R" 'lsp-rename
    ",al" 'lsp-avy-lens
    "gd" 'lsp-find-definition
    "gD" 'lsp-find-declaration
    "gr" 'lsp-find-references
    "gt" 'lsp-find-type-definition
    "gi" 'lsp-find-implementation
    "gR" 'lsp-workspace-restart
    )
  ;; (evil-collection-define-key 'insert 'lsp-inline-completion-active-map
  ;;   (kbd "C-<tab>") #'lsp-inline-completion-accept
  ;;   )

  ;; https://github.com/emacs-lsp/lsp-mode/issues/2681#issuecomment-1500173268
  ;; (advice-add 'json-parse-buffer :around
  ;;             (lambda (orig &rest rest)
  ;;               (save-excursion
  ;;                 (while (re-search-forward "\\\\u0000" nil t)
  ;;                   (replace-match "")))
  ;;               (apply orig rest)))
  )

(use-package lsp-treemacs
  :after (lsp-mode)
  :init
  (setq lsp-treemacs-error-list-expand-depth 3)
  (setq lsp-treemacs-call-hierarchy-expand-depth 3)
  (setq lsp-treemacs-type-hierarchy-expand-depth 3)
  (setq lsp-treemacs-java-deps-list-expand-depth 3)
  (setq lsp-treemacs-error-list-current-project-only t)
  :config

  (evil-collection-define-key 'normal 'lsp-mode-map
    ",el" 'lsp-treemacs-errors-list
    )
  (evil-collection-define-key 'normal 'treemacs-mode-map
    "q" 'treemacs-kill-buffer
    )
  )

(use-package lsp-ui
  :ensure t
  :commands (lsp-ui-mode)
  :init
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)

  (setq lsp-ui-flycheck-list-position 'bottom)

  (setq lsp-ui-peek-always-show t)

  (setq lsp-ui-doc-position 'at-point
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-alignment 'window
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-doc-delay 0.2
        lsp-ui-doc-use-childframe t)

  (setq lsp-ui-sideline-show-diagnostics t)

  :config
  (defun lsp-ui-peek--peek-hide ()
    "Hide the chunk of code and restore previous state."
    (when (overlayp lsp-ui-peek--overlay)
      (delete-overlay lsp-ui-peek--overlay))
    (setq lsp-ui-peek--overlay nil
          lsp-ui-peek--last-xref nil)
    ;; (set-window-start (get-buffer-window) lsp-ui-peek--win-start)
    )
  (defun evil-lsp-ui-sideline--stop-p (org-func)
    (if (and (boundp 'evil-state)
             (eq evil-state 'insert))
        t
      (funcall org-func)))

  (advice-add 'lsp-ui-sideline--stop-p :around 'evil-lsp-ui-sideline--stop-p)

  (defun evil-lsp-ui-doc--make-request (org-func)
    (if (and (boundp 'evil-state)
             (eq evil-state 'insert))
        (lsp-ui-doc--hide-frame)
      (funcall org-func)))

  (advice-add 'lsp-ui-doc--make-request :around 'evil-lsp-ui-doc--make-request)

  (evil-collection-define-key 'normal 'lsp-ui-mode-map
    "gr" 'lsp-ui-peek-find-references
    "gd" 'lsp-ui-peek-find-definitions
    "gi" 'lsp-ui-peek-find-implementation
    ",a" nil
    ",i" 'lsp-ui-imenu
    ",k" 'lsp-ui-doc-show
    )
  (defun lsp-ui-peek--goto-xref-vertical-window ()
    (interactive)
    (let ((evil-vsplit-window-right t))
      (evil-window-vsplit)
      (lsp-ui-peek--goto-xref)))
  (defun lsp-ui-peek--goto-xref-horizontal-window ()
    (interactive)
    (let ((evil-split-window-below nil))
      (evil-window-split)
      (lsp-ui-peek--goto-xref)))
  (defun lsp-ui-peek--goto-xref-tab-window ()
    (interactive)
    (let ((display-buffer-alist
           '((t (lambda (buffer alist)
                  (let ((marker (with-current-buffer buffer (point-marker))))
                    (perspeen-tab-create-tab buffer marker)
                    (let ((window (selected-window)))
                      (mapc (lambda (w)
                              (unless (equal w window)
                                (window-eq)
                                (delete-window w)))
                            (window-list))
                      window)
                    ;; (delete-other-windows)
                    ;; (selected-window)
                    ))))))
      (lsp-ui-peek--goto-xref-other-window)))

  (define-key lsp-ui-peek-mode-map
              (kbd ",v") 'lsp-ui-peek--goto-xref-vertical-window
              )
  (define-key lsp-ui-peek-mode-map
              (kbd ",s") 'lsp-ui-peek--goto-xref-horizontal-window
              )
  (define-key lsp-ui-peek-mode-map
              (kbd ",t") 'lsp-ui-peek--goto-xref-tab-window
              )
  (evil-collection-define-key 'normal 'lsp-ui-peek-mode-map
    (kbd "TAB") 'lsp-ui-peek--toggle-file
    (kbd "RET") 'lsp-ui-peek--goto-xref
    (kbd "ESC") 'lsp-ui-peek--abort))

(use-package lsp-metals
  :ensure t
  :custom
  ;; You might set metals server options via -J arguments. This might not always work, for instance when
  ;; metals is installed using nix. In this case you can use JAVA_TOOL_OPTIONS environment variable.
  (lsp-metals-server-args '(;; Metals claims to support range formatting by default but it supports range
                            ;; formatting of multiline strings only. You might want to disable it so that
                            ;; emacs can use indentation provided by scala-mode.
                            "-J-Dmetals.allow-multiline-string-formatting=off"
                            ;; Enable unicode icons. But be warned that emacs might not render unicode
                            ;; correctly in all cases.
                            "-J-Dmetals.icons=unicode"))
  ;; In case you want semantic highlighting. This also has to be enabled in lsp-mode using
  ;; `lsp-semantic-tokens-enable' variable. Also you might want to disable highlighting of modifiers
  ;; setting `lsp-semantic-tokens-apply-modifiers' to `nil' because metals sends `abstract' modifier
  ;; which is mapped to `keyword' face.
  (lsp-metals-enable-semantic-highlighting t)
  )
(provide '05-auto-complete)
;;; 05-auto-complete.el ends here
