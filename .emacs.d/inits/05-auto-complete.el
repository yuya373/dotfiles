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

(use-package company-statistics
  :ensure t
  :commands (company-statistics-mode)
  :init
  (setq company-statistics-auto-save t)
  (setq company-statistics-auto-restore t)
  (add-hook 'company-mode-hook 'company-statistics-mode)
  :config
  (setq company-transformers '(company-sort-by-statistics
                               company-sort-by-backend-importance
                               company-sort-by-occurrence))
  )

(use-package company-quickhelp
  :ensure t
  :commands (company-quickhelp-mode)
  :init
  (add-hook 'global-company-mode-hook 'company-quickhelp-mode)
  (setq company-quickhelp-use-propertized-text t)
  (setq company-quickhelp-delay 0.5)
  :config
  (add-to-list 'company-frontends 'company-quickhelp-frontend t))

(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

(use-package company
  :ensure t
  :commands (company-mode global-company-mode)
  ;; :diminish company-mode
  :init
  (setq company-idle-delay 0.5) ; デフォルトは0.5
  (setq company-minimum-prefix-length 1) ; デフォルトは4
  (setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
  (setq company-auto-complete nil)
  (setq company-tooltip-align-annotations t)
  (setq company-dabbrev-other-buffers t)
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-downcase nil)
  (setq company-frontends '(company-pseudo-tooltip-frontend
                            company-echo-metadata-frontend))

  ;; (add-to-list 'completion-styles 'initials)
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  ;; (setq company-backends
  ;;       '((company-capf
  ;;          company-dabbrev-code
  ;;          company-files
  ;;          company-keywords)
  ;;         (company-dabbrev-code
  ;;          company-dabbrev
  ;;          company-files          ; files & directory
  ;;          company-keywords       ; keywords
  ;;          ;; company-gtags
  ;;          ;; company-etags
  ;;          ;; company-yasnippet
  ;;          )))
  ;; (setq company-backends (cons 'company-capf (delete 'company-capf company-backends)))
  (setq company-backends '((company-capf company-files) company-keywords company-dabbrev-code company-dabbrev))

  (use-package company-emoji
    :ensure t
    :commands (company-emoji)
    :init
    ;; (add-to-list 'company-backends 'company-emoji)
    (setq company-emoji-insert-unicode nil)
    ;; (defun add-company-emoji ()
    ;;   (make-local-variable 'company-backends)
    ;;   (add-to-list 'company-backends 'company-emoji))
    ;; ;; (add-hook 'gfm-mode-hook #'add-company-emoji)
    ;; ;; (add-hook 'slack-edit-message-mode-hook #'add-company-emoji)
    ;; ;; (add-hook 'slack-mode-hook #'add-company-emoji)
    ;; (add-hook 'git-commit-mode-hook #'add-company-emoji)
    ;; (add-hook 'markdown-mode-hook #'add-company-emoji)
    )
  ;; (use-package company-yasnippet
  ;;   :config
  ;;   (add-to-list 'company-backends 'company-yasnippet))
  ;; (use-package company-ispell
  ;;   :init
  ;;   (defun toggle-company-ispell ()
  ;;     (interactive)
  ;;     (if (memq 'company-ispell company-backends)
  ;;         (progn
  ;;           (setq company-backends (delete 'company-ispell company-backends))
  ;;           (message "Turn OFF `company-ispell'"))
  ;;       (add-to-list 'company-backends 'company-ispell)
  ;;       (message "Turn ON `company-ispell'")))
  ;;   (defun add-company-ispell ()
  ;;     (make-local-variable 'company-backends)
  ;;     (add-to-list 'company-backends
  ;;                  '(company-ispell
  ;;                    company-files
  ;;                    company-dabbrev
  ;;                    )))
  ;;   (add-hook 'text-mode-hook #'add-company-ispell)
  ;; (add-hook 'gfm-mode-hook #'add-company-ispell)
  ;; (add-hook 'markdown-mode-hook #'add-company-ispell)
  ;; (add-hook 'org-mode-hook #'add-company-ispell)
  ;; )

  (defun company--insert-candidate2 (candidate)
    (when (> (length candidate) 0)
      (setq candidate (substring-no-properties candidate))
      (if (eq (company-call-backend 'ignore-case) 'keep-prefix)
          (insert (company-strip-prefix candidate))
        (if (equal company-prefix candidate)
            (company-select-next)
          (delete-region (- (point) (length company-prefix)) (point))
          (insert candidate)))))

  (defun company-complete-common2 ()
    (interactive)
    (when (company-manual-begin)
      (if (and (not (cdr company-candidates))
               (equal company-common (car company-candidates)))
          (company-complete-selection)
        (company--insert-candidate2 company-common))))

  (define-key company-active-map (kbd "C-w") 'backward-kill-word)
  (define-key company-active-map (kbd "C-h") 'delete-backward-char)
  (define-key company-active-map (kbd "TAB") nil)
  (define-key company-active-map [backtab] nil)
  ;; (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  ;; (define-key company-active-map [backtab] 'company-select-previous)
  ;; (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-w") 'backward-kill-word)
  (define-key company-search-map (kbd "C-h") 'delete-backward-char)
  ;; (define-key company-active-map [tab] 'company-complete-common2)
  ;; (define-key company-search-map [tab] 'company-select-next)
  ;; (define-key company-search-map [backtab] 'company-select-previous)
  ;; (define-key company-search-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)

  (set-face-attribute 'company-tooltip-mouse
                      nil
                      :foreground nil :background nil)
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "white" :background "#2aa198")
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "white" :background "#2aa198")
  (set-face-attribute 'company-tooltip-annotation nil
                      :foreground "#2aa198")
  (set-face-attribute 'company-tooltip-annotation-selection nil
                      :foreground "white")

  ;; (set-face-attribute 'company-tooltip nil
  ;;                     :foreground "black" :background "lightgrey")
  ;; (set-face-attribute 'company-tooltip-common nil
  ;;                     :foreground "black" :background "lightgrey")
  ;; (set-face-attribute 'company-tooltip-common-selection nil
  ;;                     :foreground "white" :background "steelblue")
  ;; (set-face-attribute 'company-tooltip-selection nil
  ;;                     :foreground "black" :background "steelblue")
  ;; (set-face-attribute 'company-preview-common nil
  ;;                     :background nil :foreground "lightgrey" :underline t)
  ;; (set-face-attribute 'company-scrollbar-fg nil
  ;;                     :background "orange")
  ;; (set-face-attribute 'company-scrollbar-bg nil
  ;;                     :background "gray40")
  ;; (set-face-attribute 'company-tooltip-annotation nil
  ;;                     :foreground "black" :background "lightgrey")
  ;; (set-face-attribute 'company-tooltip-annotation-selection nil
  ;;                     :foreground "white" :background "steelblue")
  (diminish 'abbrev-mode))

(use-package know-your-http-well :ensure t)
(use-package editorconfig :ensure t
  :config
  (editorconfig-mode 1))
(use-package company-restclient
  :ensure t
  :commands (company-restclient)
  :init
  (defun my-comp-restclient ()
    ;; (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-restclient))
  (add-hook 'restclient-mode-hook 'my-comp-restclient))


(use-package pos-tip :ensure t)
(use-package lsp-treemacs :ensure t)
(use-package dap-mode :ensure t)
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
        lsp-prefer-capf t

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
        lsp-inline-completion-enable nil
        lsp-inline-completion-idle-delay 2
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
  (use-package lsp-inline-completion)

  (defun my-lsp-completion-mode-hook-fn ()
    (interactive)
    (setq-local company-backends (cl-remove 'company-capf company-backends)))
  (add-hook 'lsp-completion-mode-hook 'my-lsp-completion-mode-hook-fn)

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
                  (let ((marker (with-current-buffer buffer (point-marker)))
                        )
                    (perspeen-tab-create-tab buffer marker)
                    (let ((window (selected-window)))
                      (mapc (lambda (w)
                              (unless (equal w window)
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
