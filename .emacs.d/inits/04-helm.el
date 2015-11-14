;;; 04-helm.el ---                                   -*- lexical-binding: t; -*-

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

;; imenu
(use-package imenu
  :defer t
  :init
  (setq imenu-auto-rescan t)
  (add-hook 'imenu-after-jump-hook '(lambda ()
                                      (recenter 10))))

(el-get-bundle ace-window)
(use-package ace-window
  :commands (ace-window aw-select aw-switch-to-window)
  :init
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; helm
(el-get-bundle helm)
(el-get-bundle helm-ls-git)
(el-get-bundle helm-ag)

(use-package helm-ls-git
  :commands (helm-ls-git-ls
             helm-ls-git-source
             helm-ls-git-not-inside-git-repo)
  :init
  (setq helm-ls-git-default-sources '(helm-source-ls-git))
  (setq helm-ls-git-fuzzy-match t))

(use-package helm
  :diminish helm-mode
  :commands (helm-etags-select
             helm-do-ag
             helm-do-ag-buffers
             helm-M-x
             helm-buffers-list
             helm-find-file-at
             helm-recentf
             helm-browse-project
             helm-find-files
             helm-resume
             helm-mini
             helm-semantic-or-imenu
             helm-show-kill-ring)
  :init
  (setq helm-mini-default-sources '(helm-source-buffers-list
                                    helm-source-ls-git
                                    helm-source-recentf
                                    helm-source-buffer-not-found))
  (setq helm-M-x-fuzzy-match t
        helm-apropos-fuzzy-match t
        helm-file-cache-fuzzy-match t
        helm-imenu-fuzzy-match t
        helm-lisp-fuzzy-completion t
        helm-locate-fuzzy-match t
        helm-recentf-fuzzy-match t
        helm-semantic-fuzzy-match t
        helm-ag-fuzzy-match t
        helm-mode-fuzzy-match t
        helm-completion-in-region-fuzzy-match t
        helm-buffers-fuzzy-matching t)
  (setq helm-prevent-escaping-from-minibuffer t
        helm-buffers-truncate-lines t
        helm-buffer-max-length nil
        helm-ff-transformer-show-only-basename t
        helm-bookmark-show-location t
        helm-display-header-line t
        helm-split-window-in-side-p nil
        helm-always-two-windows t
        helm-autoresize-mode t
        helm-ff-file-name-history-use-recentf t
        helm-exit-idle-delay 0
        helm-ff-search-library-in-sexp t
        helm-move-to-line-cycle-in-source nil
        helm-echo-input-in-header-line t)
  :config
  (use-package helm-config)
  (defun make-helm-git-source ()
    (unless (helm-ls-git-not-inside-git-repo)
      (setq helm-source-ls-git
            (helm-make-source "Git files" 'helm-ls-git-source
              :fuzzy-match helm-ls-git-fuzzy-match))))

  (defun my-helm-mini ()
    (interactive)
    (make-helm-git-source)
    (helm-mini))

  (use-package helm-ag
    :config
    (setq helm-ag-insert-at-point 'symbol))
  (helm-mode +1)


  (defun switch-window-if-gteq-3-windows ()
    (if (>= (length (window-list)) 3)
        (aw-switch-to-window (aw-select "Ace - Window"))))

  (defun my-evil-vsplit-window (file-name)
    (let ((evil-vsplit-window-right t)
          (evil-auto-balance-windows t))
      (evil-window-vsplit nil (expand-file-name file-name))))

  (defun my-evil-split-window (file-name)
    (let ((evil-split-window-below nil)
          (evil-auto-balance-windows t))
      (evil-window-split nil (expand-file-name file-name))))

  (defun ace-split-find-file (candidate)
    (switch-window-if-gteq-3-windows)
    (my-evil-split-window candidate))
  (defun helm-ace-split-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-split-find-file)))

  (defun ace-split-helm-ag (filename)
    (let ((dir (or helm-ag--default-directory
                   helm-ag--last-default-directory
                   default-directory)))
      (switch-window-if-gteq-3-windows)
      (my-evil-split-window (concat dir filename))))
  (defun ace-split--helm-ag (candidate)
    (helm-ag--find-file-action candidate 'ace-split-helm-ag
                               (helm-ag--search-this-file-p)))
  (defun helm-ace-split-ag ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-split--helm-ag)))

  (defun ace-split-switch-to-buffer (buffer-or-name)
    (switch-window-if-gteq-3-windows)
    (let ((file-name (buffer-file-name buffer-or-name)))
      (if file-name
          (my-evil-split-window file-name)
        (let ((window (split-window (selected-window) nil 'above)))
          (unwind-protect
              (progn
                (aw-switch-to-window window)
                (switch-to-buffer buffer-or-name)))))))
  (defun helm-ace-split-sb ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-split-switch-to-buffer)))

  (defun ace-vsplit-find-file (candidate)
    (switch-window-if-gteq-3-windows)
    (my-evil-vsplit-window candidate))
  (defun helm-ace-vsplit-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-vsplit-find-file)))

  (defun ace-vsplit-helm-ag (filename)
    (let ((dir (or helm-ag--default-directory
                   helm-ag--last-default-directory
                   default-directory)))
      (switch-window-if-gteq-3-windows)
      (my-evil-vsplit-window (concat dir filename))))
  (defun ace-vsplit--helm-ag (candidate)
    (helm-ag--find-file-action candidate 'ace-vsplit-helm-ag
                               (helm-ag--search-this-file-p)))
  (defun helm-ace-vsplit-ag ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-vsplit--helm-ag)))

  (defun ace-vsplit-switch-to-buffer (buffer-or-name)
    (switch-window-if-gteq-3-windows)
    (let ((file-name (buffer-file-name buffer-or-name)))
      (if file-name
          (my-evil-vsplit-window file-name)
        (let ((window (split-window-right)))
          (unwind-protect
              (progn
                (aw-switch-to-window window)
                (switch-to-buffer buffer-or-name)))))))

  (defun helm-ace-vsplit-sb ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-vsplit-switch-to-buffer)))

  (defun ace-helm-find-file (candidate)
    (popwin:close-popup-window)
    (if (one-window-p)
        (find-file-other-window (expand-file-name candidate))
      (let ((buf (find-file-noselect (expand-file-name candidate)))
            (window (aw-select "Ace - Window")))
        (unwind-protect
            (progn
              (aw-switch-to-window window)
              (switch-to-buffer buf))))))
  (defun helm-ace-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-helm-find-file)))
  (defun ace-helm-switch-to-buffer (buffer-or-name)
    (popwin:close-popup-window)
    (if (= (length (window-list)) 1)
        (switch-to-buffer-other-window buffer-or-name)
      (let ((buf buffer-or-name)
            (window (aw-select "Ace - Window")))
        (unwind-protect
            (progn
              (aw-switch-to-window window)
              (switch-to-buffer buf))))))
  (defun helm-ace-sb ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action 'ace-helm-switch-to-buffer)))

  (define-key evil-normal-state-map (kbd ",ha") 'helm-apropos)

  (define-key helm-map (kbd "C-,") 'helm-toggle-visible-mark)
  (define-key helm-map (kbd "C-a") 'helm-select-action)
  (define-key helm-map (kbd "C-k") 'helm-previous-source)
  (define-key helm-map (kbd "C-j") 'helm-next-source)
  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-comp-read-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-comp-read-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-comp-read-map (kbd "C-o") 'helm-ace-ff)

  (define-key helm-buffer-map (kbd "C-s") 'helm-ace-split-sb)
  (define-key helm-buffer-map (kbd "C-v") 'helm-ace-vsplit-sb)
  (define-key helm-buffer-map (kbd "C-d") 'helm-buffer-run-kill-buffers)
  (define-key helm-buffer-map (kbd "C-o") 'helm-ace-sb)

  (define-key helm-find-files-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-find-files-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-find-files-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-find-files-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-find-files-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-read-file-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-read-file-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-read-file-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-read-file-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-read-file-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-generic-files-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-generic-files-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-generic-files-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-generic-files-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-generic-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-generic-files-map (kbd "TAB") 'helm-execute-persistent-action)

  (with-eval-after-load "helm-ls-git"
    (define-key helm-ls-git-map (kbd "C-s") 'helm-ace-split-ff)
    (define-key helm-ls-git-map (kbd "C-v") 'helm-ace-vsplit-ff)
    (define-key helm-ls-git-map (kbd "C-o") 'helm-ace-ff))

  (define-key helm-ag-map (kbd "C-s") 'helm-ace-split-ag)
  (define-key helm-ag-map (kbd "C-v") 'helm-ace-vsplit-ag)
  (define-key helm-ag-map (kbd "C-o") 'helm-ag--run-other-window-action))

(el-get-bundle helm-dash)
(use-package helm-dash
  :commands (helm-dash-at-point helm-dash helm-dash-install-docset)
  :init
  (setq helm-dash-min-length 1)
  (setq helm-dash-browser-func 'eww)
  (setq helm-dash-docsets-path (expand-file-name "~/.docsets"))
  (add-hook 'markdown-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Markdown"))))
  (add-hook 'enh-ruby-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Ruby"))))
  (add-hook 'projectile-rails-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Ruby" "Ruby on Rails"))))
  (add-hook 'emacs-lisp-mode-hook
            '(lambda () (setq-local helm-dash-docsets '("Emacs" "Emacs Lisp"))))
  (defun helm-lisp-mode ()
    (setq-local helm-dash-docsets '("Common Lisp")))
  (add-hook 'lisp-mode-hook 'helm-lisp-mode)
  (add-hook 'slime-repl-mode-hook 'helm-lisp-mode))

(el-get-bundle helm-gtags)
(use-package helm-gtags
  :diminish helm-gtags-mode
  :commands (helm-gtags-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'helm-gtags-mode)
  (setq helm-gtags-update-interval-second 1)
  (setq helm-gtags-auto-update t)
  (setq helm-gtags-preselect t)
  (setq helm-gtags-use-input-at-cursor t)
  (setq helm-gtags-path-style 'root)
  (setq helm-gtags-display-style 'detail)
  :config
  (defun helm-gtags-update-all-tags ()
    (interactive)
    (let ((how-to 'entire-update)
          (interactive-p (called-interactively-p 'interactive))
          (current-time (float-time (current-time))))
      (when (helm-gtags--update-tags-p how-to interactive-p current-time)
        (let* ((cmds (helm-gtags--update-tags-command how-to))
               (proc (apply 'start-file-process "helm-gtags-update-tag" nil cmds)))
          (if (not proc)
              (message "Failed: %s" (mapconcat 'identity cmds " "))
            (set-process-sentinel proc (helm-gtags--make-gtags-sentinel 'update))
            (setq helm-gtags--last-update-time current-time))))))
  (evil-define-key 'normal helm-gtags-mode-map
    (kbd "\C-]") 'helm-gtags-find-tag-from-here
    (kbd "\C-t") 'helm-gtags-pop-stack
    ",tc" 'helm-gtags-create-tags
    ",tf" 'helm-gtags-select
    ",tu" 'helm-gtags-update-tags
    ",tU" 'helm-gtags-update-all-tags
    ",td" 'helm-gtags-find-tag
    ",tr" 'helm-gtags-find-rtag
    ",tn" 'helm-gtags-next-history
    ",tp" 'helm-gtags-previous-history))

(el-get-bundle helm-open-github)
(use-package helm-open-github
  :commands (helm-open-github-from-file
             helm-open-github-from-commit
             helm-open-github-from-issues
             helm-open-github-from-pull-requests))

(provide '04-helm)
;;; 04-helm.el ends here
