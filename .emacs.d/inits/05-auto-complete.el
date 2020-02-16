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

(el-get-bundle yasnippet)
(el-get-bundle yasnippet-snippets)
(el-get-bundle company-mode)
(el-get-bundle company-emoji)
(el-get-bundle company-statistics)
(el-get-bundle company-quickhelp)

(use-package yasnippet-snippets
  :after (yasnippet))

(use-package yasnippet
  :commands (yas-global-mode)
  :diminish yas-minor-mode
  :init
  (add-hook 'after-init-hook 'yas-global-mode))

(use-package company-statistics
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
  :commands (company-quickhelp-mode)
  :init
  (add-hook 'global-company-mode-hook 'company-quickhelp-mode)
  (setq company-quickhelp-use-propertized-text t)
  (setq company-quickhelp-delay 0.5)
  :config
  (add-to-list 'company-frontends 'company-quickhelp-frontend t))

(use-package company
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
                            company-preview-frontend
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
  ;;          company-gtags
  ;;          company-etags
  ;;          ;; company-yasnippet
  ;;          )))
  (use-package company-emoji
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
  (use-package company-ispell
    :init
    (defun toggle-company-ispell ()
      (interactive)
      (if (memq 'company-ispell company-backends)
          (progn
            (setq company-backends (delete 'company-ispell company-backends))
            (message "Turn OFF `company-ispell'"))
        (add-to-list 'company-backends 'company-ispell)
        (message "Turn ON `company-ispell'")))
    (defun add-company-ispell ()
      (make-local-variable 'company-backends)
      (add-to-list 'company-backends
                   '(company-ispell
                     company-files
                     company-dabbrev
                     )))
    (add-hook 'text-mode-hook #'add-company-ispell)
    ;; (add-hook 'gfm-mode-hook #'add-company-ispell)
    ;; (add-hook 'markdown-mode-hook #'add-company-ispell)
    ;; (add-hook 'org-mode-hook #'add-company-ispell)
    )

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
  (define-key company-active-map [tab] 'company-complete-common-or-cycle)
  ;; (define-key company-active-map [tab] 'company-select-next)
  (define-key company-active-map [backtab] 'company-select-previous)
  (define-key company-active-map (kbd "S-TAB") 'company-select-previous)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-w") 'backward-kill-word)
  (define-key company-search-map (kbd "C-h") 'delete-backward-char)
  ;; (define-key company-active-map [tab] 'company-complete-common2)
  ;; (define-key company-search-map [tab] 'company-select-next)
  (define-key company-search-map [backtab] 'company-select-previous)
  (define-key company-search-map (kbd "S-TAB") 'company-select-previous)
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
  (setq company-lsp-async t)

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

(el-get-bundle know-your-http-well)
(use-package know-your-http-well
  :defer t
  :init
  (add-to-list 'load-path
               (expand-file-name
                (concat user-emacs-directory
                        "el-get/know-your-http-well/emacs"))))
(el-get-bundle company-restclient)
(use-package company-restclient
  :commands (company-restclient)
  :init
  (defun my-comp-restclient ()
    ;; (make-local-variable 'company-backends)
    (add-to-list 'company-backends 'company-restclient))
  (add-hook 'restclient-mode-hook 'my-comp-restclient))


(el-get-bundle pos-tip
  :type github
  :pkgname "pitkali/pos-tip"
  :name pos-tip)

(el-get-bundle lsp-mode)
(el-get-bundle lsp-ui)
(el-get-bundle company-lsp)
(el-get-bundle treemacs)
(el-get-bundle treemacs-evil)
(el-get-bundle treemacs-projectile)
(el-get-bundle treemacs-magit)
(el-get-bundle lsp-treemacs)
(el-get-bundle helm-lsp)

(use-package treemacs
  :commands (treemacs-find-file treemacs-add-project)
  :defer t
  :init
  (setq treemacs-follow-after-init t
        treemacs-width 35
        treemacs-position 'left
        treemacs-is-never-other-window nil
        treemacs-silent-refresh nil
        treemacs-indentation 2
        treemacs-change-root-without-asking nil
        treemacs-sorting 'alphabetic-desc
        treemacs-show-hidden-files t
        treemacs-never-persist nil
        treemacs-goto-tag-strategy 'refetch-index
        treemacs-collapse-dirs 0
        )
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t)
  (treemacs-git-mode 'deferred)
  )
(use-package treemacs-evil
  :after (treemacs))
(use-package treemacs-projectile
  :after (treemacs))
(use-package treemacs-magit
  :after (treemacs))

(use-package lsp-mode
  :commands (lsp)
  :diminish lsp-mode
  :init
  (add-hook 'typescript-mode-hook 'lsp)
  (add-hook 'rjsx-mode-hook 'lsp)
  (add-hook 'web-mode-hook 'lsp)
  (add-hook 'enh-ruby-mode-hook 'lsp)
  (add-hook 'go-mode-hook 'lsp)
  (add-hook 'rust-mode-hook 'lsp)

  (setq lsp-auto-guess-root t
        lsp-enable-snippet t
        lsp-auto-configure t
        lsp-enable-xref t
        lsp-enable-indentation t
        lsp-enable-on-type-formatting t

        lsp-document-sync-method nil

        lsp-enable-completion-at-point nil

        lsp-prefer-flymake nil

        lsp-eldoc-render-all nil

        lsp-report-if-no-buffer t
        )
  :config
  (evil-collection-define-key 'normal 'lsp-mode-map
    ",hs" 'lsp-describe-session
    "K" 'lsp-describe-thing-at-point
    ",a" 'lsp-execute-code-action
    ",R" 'lsp-rename
    "gD" 'lsp-find-declaration
    "gt" 'lsp-find-type-definition
    "gR" 'lsp-restart-workspace
    )
  )

(use-package lsp-ui
  :commands (lsp-ui-mode)
  :init
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)

  (add-hook 'lsp-ui-mode-hook 'setup-lsp-ui-mode)
  (defun setup-lsp-ui-mode ()
    (interactive)
    (remove-hook 'lsp-after-diagnostics-hook 'lsp-ui-sideline--diagnostics-changed t))

  (setq lsp-ui-flycheck-enable t
        lsp-ui-flycheck-live-reporting nil
        lsp-ui-flycheck-list-position 'right)

  (setq lsp-ui-peek-always-show t)

  (setq lsp-ui-doc-position 'top
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t)

  (setq lsp-ui-sideline-show-diagnostics nil)

  :config
  (defun lsp-ui-peek--get-xrefs-in-file (file)
    "Return all references that contain a file.
FILE is a cons where its car is the filename and the cdr is a list of Locations
within the file.  We open and/or create the file/buffer only once for all
references.  The function returns a list of `ls-xref-item'."
    (let* ((filename (car file))
           (visiting (find-buffer-visiting filename))
           (fn (lambda (loc) (lsp-ui-peek--xref-make-item filename loc))))
      (cond
       (visiting
        (with-temp-buffer
          (insert-buffer-substring-no-properties visiting)
          (lsp-ui-peek--fontify-buffer filename)
          (mapcar fn (cdr file))))
       ((file-readable-p filename)
        (with-temp-buffer
          ;; (insert-file-contents-literally filename)
          (insert-file-contents filename)
          (lsp-ui-peek--fontify-buffer filename)
          (mapcar fn (cdr file))))
       (t (user-error "Cannot read %s" filename)))))
  (flycheck-add-next-checker 'lsp-ui 'javascript-eslint)
  (use-package helm-lsp :commands (helm-lsp-workspace-symbol))
  (use-package lsp-treemacs :commands (lsp-treemacs-errors-list))

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
    ",a" 'lsp-ui-sideline-apply-code-actions
    ",i" 'lsp-ui-imenu
    ",s" 'helm-lsp-workspace-symbol
    ",le" 'lsp-ui-flycheck-list
    )

  (defun lsp-ui-peek--goto-xref-vertical-window ()
    (interactive)
    (let ((display-buffer-function
           #'(lambda (buffer &rest _args)
               (let ((win (split-window (selected-window)
                                        nil
                                        'right)))
                 (set-window-buffer win buffer)
                 (select-window win)))))
      (lsp-ui-peek--goto-xref-other-window)))
  (defun lsp-ui-peek--goto-xref-horizontal-window ()
    (interactive)
    (let ((display-buffer-function
           #'(lambda (buffer &rest _args)
               (let ((win (split-window (selected-window)
                                        nil
                                        'above)))
                 (set-window-buffer win buffer)
                 (select-window win)))))
      (lsp-ui-peek--goto-xref-other-window)))
  (defun lsp-ui-peek--goto-xref-tab-window ()
    (interactive)
    (let ((display-buffer-function
           #'(lambda (buffer &rest _args)
               (let* ((marker (with-current-buffer buffer
                                (point-marker))))
                 (perspeen-tab-create-tab buffer marker)
                 (selected-window)))))
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

(use-package company-lsp
  :after (lsp-mode)
  :init
  (setq company-lsp-async t
        company-lsp-enable-recompletion t
        company-lsp-enable-additional-text-edit t
        company-lsp-enable-snippet t
        company-lsp-enable-trigger-kind t
        )
  :config

  (defun company-lsp-match-candidate-prefix (candidate prefix)
    "Return non-nil if the filter text of CANDIDATE starts with PREFIX.

The match is case-insensitive."
    (string-prefix-p prefix (company-lsp--candidate-filter-text candidate) nil))
  (setq company-lsp-match-candidate-predicate
        #'company-lsp-match-candidate-prefix)
  (push 'company-lsp company-backends))

;; (el-get-bundle company-box)
;; (use-package company-box
;;   :commands (company-box-mode)
;;   :init
;;   (setq company-box-show-single-candidate t
;;         company-box-doc-enable t
;;         company-box-doc-delay 0.1
;;         )
;;   (add-hook 'company-mode-hook 'company-box-mode))




(provide '05-auto-complete)
;;; 05-auto-complete.el ends here
