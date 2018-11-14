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
  (require 'evil)
  (require 'evil-leader))

(el-get-bundle ace-window)
(use-package ace-window
  :commands (ace-window aw-select aw-switch-to-window)
  :init
  (setq aw-dispatch-always t)
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; helm
(el-get-bundle helm)
(el-get-bundle helm-ls-git)
(el-get-bundle helm-ag)
(el-get-bundle migemo)



(use-package helm
  :diminish helm-mode
  :commands (helm-eshell-history
             helm-etags-select
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
             helm-show-kill-ring
             helm-all-mark-rings
             helm-semantic-or-imenu
             helm-elscreen)
  :init
  (setq helm-mini-default-sources '(
                                    helm-source-buffers-list
                                    helm-source-files-in-current-dir
                                    helm-source-recentf
                                    helm-source-buffer-not-found
                                    helm-source-ls-git
                                    ))
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
        helm-autoresize-max-height 40
        helm-autoresize-mode t
        helm-ff-file-name-history-use-recentf t
        helm-exit-idle-delay 0
        helm-ff-search-library-in-sexp t
        helm-move-to-line-cycle-in-source nil
        helm-echo-input-in-header-line t)
  :config
  (use-package helm-man)
  (use-package helm-config)
  (use-package helm-eshell)
  (use-package helm-ls-git
    ;; :commands (helm-ls-git-ls
    ;;            helm-ls-git-source
    ;;            helm-ls-git-not-inside-git-repo)
    :init
    (setq helm-ls-git-default-sources '(helm-source-ls-git))
    (setq helm-ls-git-fuzzy-match t))
  (helm-migemo-mode t)
  (diminish 'helm-migemo-mode)
  (defun make-helm-git-source ()
    (unless (helm-ls-git-not-inside-git-repo)
      (setq helm-source-ls-git
            (helm-make-source "Git files" 'helm-ls-git-source
              :fuzzy-match helm-ls-git-fuzzy-match))))
  (use-package helm-ag
    :config
    (setq helm-ag-insert-at-point 'symbol))
  (helm-mode +1)
  (defun switch-window-if-gteq-3-windows ()
    (if (>= (1+ (length (window-list))) 3)
        (aw-switch-to-window (aw-select "Ace - Window"))))

  (defun my-helm-normalize-candidate (candidate)
    (cl-labels
        ((normalize-string
          (candidate)
          (let ((candidates (split-string candidate ":"))
                (default-directory (or helm-ag--default-directory
                                       helm-ag--last-default-directory
                                       default-directory)))
            (expand-file-name (cl-first candidates)))))
      (let ((file-name (or (and (stringp candidate)
                                (normalize-string candidate))
                           (and (consp candidate)
                                (buffer-file-name (marker-buffer
                                                   (cdr candidate))))
                           (and (markerp candidate)
                                (buffer-file-name (marker-buffer candidate)))
                           (and (bufferp candidate)
                                (buffer-file-name candidate)))))
        file-name)))

  (defun my-handle-marker-position (candidate)
    (let ((pos (or (markerp candidate)
                   (and (consp candidate)
                        (markerp (cdr candidate))
                        (cdr candidate))
                   (and (stringp candidate)
                        (cl-second (split-string candidate ":"))))))
      (when pos
        (if (markerp pos)
            (with-current-buffer (current-buffer)
              (goto-char (marker-position pos)))
          (progn
            (goto-char (point-min))
            (forward-line (1- (string-to-number pos))))))))

  (defun my-evil-vsplit-window (candidate)
    (let ((evil-vsplit-window-right t)
          (evil-auto-balance-windows t)
          (file-name (my-helm-normalize-candidate candidate)))
      (evil-window-vsplit nil (expand-file-name file-name))
      (my-handle-marker-position candidate)))

  (defun my-evil-split-window (candidate)
    (let ((evil-split-window-below nil)
          (evil-auto-balance-windows t)
          (file-name (expand-file-name
                      (my-helm-normalize-candidate candidate))))
      (evil-window-split nil file-name)
      (my-handle-marker-position candidate)))

  (defun helm-perspeen-open-with-new-tab ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action
       #'(lambda (candidate)
           (let ((file-name (my-helm-normalize-candidate candidate)))
             (perspeen-tab-create-tab
              (or (and file-name (find-file-noselect (expand-file-name file-name)))
                  candidate)
              0)
             (my-handle-marker-position candidate))))))

  (defun ace-split-find-file (candidate)
    (switch-window-if-gteq-3-windows)
    (my-evil-split-window candidate))

  (defun helm-ace-split-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action #'(lambda (candidate)
                                        (ace-split-find-file candidate)))))

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
      (helm-exit-and-execute-action #'(lambda (candidate)
                                        (ace-split--helm-ag candidate)))))

  (defun ace-ff--helm-ag (candidate)
    (message "%s" candidate)
    ;; (helm-ag--find-file-action candidate 'ace-
    (ace-helm-find-file candidate)
    )

  (defun helm-ace-ff-ag ()
    (interactive
     (with-helm-alive-p
       (helm-exit-and-execute-action #'(lambda (candidate)
                                         (ace-ff--helm-ag candidate))))))

  (defun ace-split-switch-to-buffer (buffer-or-name)
    (switch-window-if-gteq-3-windows)
    (let ((file-name (ignore-errors (buffer-file-name buffer-or-name))))
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
      (helm-exit-and-execute-action #'(lambda (candidate)
                                        (ace-split-switch-to-buffer candidate)))))

  (defun ace-vsplit-find-file (candidate)
    (switch-window-if-gteq-3-windows)
    (my-evil-vsplit-window candidate))

  (defun helm-ace-vsplit-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action '(lambda (candidate)
                                       (ace-vsplit-find-file candidate)))))

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
      (helm-exit-and-execute-action '(lambda (candidate)
                                       (ace-vsplit--helm-ag candidate)))))

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
      (helm-exit-and-execute-action '(lambda (candidate)
                                       (ace-vsplit-switch-to-buffer candidate)))))

  (defun ace-helm-find-file (candidate)
    (let ((file-name (my-helm-normalize-candidate candidate)))
      (message "file-name: %s\ncandidate: %s" file-name candidate)
      (if (one-window-p)
          (find-file-other-window (expand-file-name file-name))
        (let ((buf (find-file-noselect (expand-file-name file-name)))
              (window (aw-select "Ace - Window")))
          (unwind-protect
              (progn
                (aw-switch-to-window window)
                (switch-to-buffer buf))))))
    (my-handle-marker-position candidate))

  (defun helm-ace-ff ()
    (interactive)
    (with-helm-alive-p
      (helm-exit-and-execute-action '(lambda (candidate)
                                       (ace-helm-find-file candidate)))))

  (defun ace-helm-switch-to-buffer (buffer-or-name)
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
      (helm-exit-and-execute-action '(lambda (candidate)
                                       (ace-helm-switch-to-buffer candidate)))))

  ;; (defun helm-imenu--execute-action-at-once-p ()
  ;;   ;; (let ((cur (helm-get-selection))
  ;;   ;;       (mb (with-helm-current-buffer
  ;;   ;;             (save-excursion
  ;;   ;;               (goto-char (point-at-bol))
  ;;   ;;               (point-marker)))))
  ;;   ;;   (if (equal (cdr cur) mb)
  ;;   ;;       (prog1 nil
  ;;   ;;         (helm-set-pattern "")
  ;;   ;;         (helm-force-update))
  ;;   ;;     t))
  ;;   nil)
  (with-eval-after-load "evil"
    (define-key evil-motion-state-map
      (kbd "C-b") 'helm-mini)
    (define-key evil-normal-state-map
      (kbd "C-b") 'helm-mini))

  (define-key helm-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
  (define-key helm-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-map (kbd "C-,") 'helm-toggle-visible-mark)
  (define-key helm-map (kbd "C-a") 'helm-select-action)
  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-map (kbd "C-w") 'backward-kill-word)
  (define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-map [escape] 'helm-keyboard-quit)
  (define-key helm-map (kbd "C-[") 'helm-keyboard-quit)
  (define-key helm-map (kbd "C-j") 'helm-next-source)
  (define-key helm-map (kbd "C-k") 'helm-previous-source)
  (define-key helm-map (kbd "C-n") 'helm-next-line)
  (define-key helm-map (kbd "C-p") 'helm-previous-line)


  (define-key helm-comp-read-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
  (define-key helm-comp-read-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-comp-read-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-comp-read-map (kbd "C-o") 'helm-ace-ff)

  (define-key helm-buffer-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
  (define-key helm-buffer-map (kbd "C-s") 'helm-ace-split-sb)
  (define-key helm-buffer-map (kbd "C-v") 'helm-ace-vsplit-sb)
  (define-key helm-buffer-map (kbd "C-d") 'helm-buffer-run-kill-buffers)
  (define-key helm-buffer-map (kbd "C-o") 'helm-ace-sb)
  (define-key helm-buffer-map (kbd "C-g") 'helm-keyboard-quit)

  (define-key helm-find-files-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
  (define-key helm-find-files-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-find-files-map (kbd "C-v") 'helm-ace-vsplit-ff)
  ;; (define-key helm-find-files-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-find-files-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-find-files-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-find-files-map (kbd "C-d") 'helm-ff-run-delete-file)

  (define-key helm-read-file-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
  (define-key helm-read-file-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-read-file-map (kbd "C-v") 'helm-ace-vsplit-ff)
  ;; (define-key helm-read-file-map (kbd "C-t") 'helm-ff-run-etags)
  (define-key helm-read-file-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-read-file-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-read-file-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-read-file-map (kbd "C-w") 'backward-kill-word)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

  (define-key helm-generic-files-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
  (define-key helm-generic-files-map (kbd "C-s") 'helm-ace-split-ff)
  (define-key helm-generic-files-map (kbd "C-v") 'helm-ace-vsplit-ff)
  (define-key helm-generic-files-map (kbd "C-o") 'helm-ace-ff)
  (define-key helm-generic-files-map (kbd "C-r") 'helm-ff-run-rename-file)
  (define-key helm-generic-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-generic-files-map (kbd "C-w") 'backward-kill-word)
  (define-key helm-generic-files-map (kbd "TAB") 'helm-execute-persistent-action)

  (with-eval-after-load "helm-ls-git"
    (define-key helm-ls-git-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
    (define-key helm-ls-git-map (kbd "C-s") 'helm-ace-split-ff)
    (define-key helm-ls-git-map (kbd "C-v") 'helm-ace-vsplit-ff)
    (define-key helm-ls-git-map (kbd "C-o") 'helm-ace-ff))

  (define-key helm-ag-map (kbd "C-t") 'helm-perspeen-open-with-new-tab)
  (define-key helm-ag-map (kbd "C-s") 'helm-ace-split-ag)
  (define-key helm-ag-map (kbd "C-v") 'helm-ace-vsplit-ag)
  (define-key helm-ag-map (kbd "C-o") 'helm-ace-ff-ag)
  ;; (define-key helm-ag-map (kbd "C-o") 'helm-ag--run-other-window-action)

  )

(el-get-bundle helm-dash)
(use-package helm-dash
  :commands (helm-dash-at-point helm-dash helm-dash-install-docset helm-dash-install-docset-from-file)
  :init
  (setq helm-dash-common-docsets '("Ruby" "Ruby on Rails" "Rust" "React" "PostgreSQL"
                                   "NodeJS" "Nginx" ;; "MySQL"
                                   "Markdown" "JavaScript"
                                   ;; "Java"
                                   "Haskell" "Haml" "HTML" "Emacs Lisp"
                                   "ElasticSearch" "Docker" ;; "Common Lisp"
                                   "Bash" ;; "OCaml"
                                   ;; "NET Framework" "Unity 3D"
                                   ))
  (setq helm-dash-min-length 1)
  (setq helm-dash-browser-func 'eww)
  ;;   (add-hook 'markdown-mode-hook
  ;;             '(lambda () (setq-local helm-dash-docsets '("Markdown"))))
  ;;   (add-hook 'enh-ruby-mode-hook
  ;;             '(lambda () (setq-local helm-dash-docsets '("Ruby"))))
  ;;   (add-hook 'projectile-rails-mode-hook
  ;;             '(lambda () (setq-local helm-dash-docsets '("Ruby" "Ruby on Rails"))))
  ;;   (add-hook 'emacs-lisp-mode-hook
  ;;             '(lambda () (setq-local helm-dash-docsets '("Emacs Lisp"))))
  ;;   (defun helm-lisp-mode ()
  ;;     (setq-local helm-dash-docsets '("Common Lisp")))
  ;;   (add-hook 'lisp-mode-hook 'helm-lisp-mode)
  ;;   (add-hook 'slime-repl-mode-hook 'helm-lisp-mode)
  :config
  (defun helm-dash-get-docset-url (feed-path)
    "Parse a xml feed with docset urls and return the first url.
The Argument FEED-PATH should be a string with the path of the xml file."
    (let* ((xml (xml-parse-file feed-path))
           (urls (car xml))
           (url (xml-get-children urls 'url))
           (_url (cl-caddr (or (cl-find-if #'(lambda (e) (string-match-p "tokyo" (cl-caddr e))) url)
                               (cl-first url)))))

      (message "%s" _url)
      _url)))

(el-get-bundle helm-gtags)
(use-package helm-gtags
  :diminish helm-gtags-mode
  :commands (helm-gtags-mode)
  :init
  (add-hook 'enh-ruby-mode-hook 'helm-gtags-mode)
  (add-hook 'scala-mode-hook 'helm-gtags-mode)
  (setq helm-gtags-update-interval-second 60)
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
  (evil-leader/set-key-for-mode 'helm-gtags-mode
    "tc" 'helm-gtags-create-tags
    "tf" 'helm-gtags-select
    "tu" 'helm-gtags-update-tags
    "tU" 'helm-gtags-update-all-tags
    "td" 'helm-gtags-find-tag
    "tr" 'helm-gtags-find-rtag
    "tn" 'helm-gtags-next-history
    "tp" 'helm-gtags-previous-history)
  (evil-define-key 'normal helm-gtags-mode-map
    (kbd "\C-]") 'helm-gtags-find-tag-from-here
    (kbd "\C-t") 'helm-gtags-pop-stack))

(el-get-bundle helm-open-github)
(use-package helm-open-github
  :commands (helm-open-github-from-file
             helm-open-github-from-commit
             helm-open-github-from-issues
             helm-open-github-from-pull-requests))

(provide '04-helm)
;;; 04-helm.el ends here
