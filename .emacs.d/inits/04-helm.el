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
  (require 'use-package)
  (require 'el-get))

(defvar diary-root-dir (expand-file-name "~/dev/diary"))
(defvar diary-year-format "%Y")
(defvar diary-month-format "%m")
(defvar diary-file-format (concat (format "%s/%s"
                                          diary-year-format
                                          diary-month-format)
                                  "/%d.md"))

(el-get-bundle vertico)
(el-get-bundle consult)
(el-get-bundle consult-flycheck)
(el-get-bundle consult-lsp)
(el-get-bundle consult-dir)
(el-get-bundle marginalia)
(el-get-bundle orderless)
(el-get-bundle embark)
(el-get-bundle embark-consult)
(el-get-bundle consult-projectile)
(el-get-bundle all-the-icons)
(el-get-bundle all-the-icons-completion)

(defun consult-normalize-file-string (s)
  (let* ((splitted (split-string s ":"))
         (path (car splitted))
         (line (cadr splitted))
         (word (caddr splitted))
         (path (if (file-name-absolute-p path)
                   path
                 (expand-file-name path default-directory))))
    (list path (when line (string-to-number line)) word)))

(use-package orderless
  :after (vertico)
  :init
  (setq orderless-matching-styles
        '(
          orderless-prefixes
          ;; orderless-flex
          orderless-literal
          orderless-regexp
          ))
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package vertico
  :init
  (vertico-mode)
  :config
  (marginalia-mode)
  (savehist-mode)
  (setq vertico-count 20)
  (setq vertico-cycle t)
  (define-key vertico-map
    (kbd "C-l") 'vertico-directory-up)
  (defun my/vertico-truncate-candidates (args)
    ;; (message "ARGS: %s" args)
    (if-let ((arg (car args))
             (type (get-text-property 0 'multi-category arg))
             ;; ((eq (car-safe type) 'file))
             (w (max 30 (- (window-width) (* 2 38))))
             (l (length arg))
             ((> l w)))
        (progn
          ;; (message "ARG: %s W: %s, L: %s, WW: %s" arg w l (window-width))
          (if (eq (car-safe type) 'file)
              (setcar args (concat "…" (truncate-string-to-width arg l (- l w))))
            (setcar args (concat (truncate-string-to-width arg l (- l w)) "…"))))
      )
    args)
  (advice-add #'vertico--format-candidate
              :filter-args
              #'my/vertico-truncate-candidates)
  )

(use-package marginalia
  :after (vertico)
  :config
  (setq all-the-icons-scale-factor 0.8)
  (use-package all-the-icons)
  (use-package all-the-icons-completion)
  (all-the-icons-completion-mode))

(use-package consult
  :after (vertico)
  :config
  (recentf-mode)
  (define-key evil-normal-state-map
    (kbd "C-b") 'consult-buffer)
  (setq consult-goto-line-numbers nil)
  (setq consult--source-buffer-perspeen
        `(:name "Buffer"
          :narrow   ?b
          :category buffer
          :face     consult-buffer
          :history  buffer-name-history
          :state    ,#'consult--buffer-state
          :default  t
          :items
          ,(lambda ()
             (let ((buffers (perspeen-ws-struct-buffers perspeen-current-ws)))
               (consult--buffer-query :sort 'visibility
                                      :predicate (lambda (buf) (member buf buffers))
                                      :as 'buffer-name)))
          ))
  (setq consult-buffer-sources '(
                                 consult--source-buffer-perspeen
                                 ;; consult--source-hidden-buffer
                                 ;; consult--source-buffer
                                 ;; consult--source-recent-file
                                 ))

  (setq consult-narrow-key "<")
  (defun consult-narrow-cycle-backward ()
    "Cycle backward through the narrowing keys."
    (interactive)
    (when consult--narrow-keys
      (consult-narrow
       (if consult--narrow
           (let ((idx (seq-position consult--narrow-keys
                                    (assq consult--narrow consult--narrow-keys))))
             (unless (eq idx 0)
               (car (nth (1- idx) consult--narrow-keys))))
         (caar (last consult--narrow-keys))))))

  (defun consult-narrow-cycle-forward ()
    "Cycle forward through the narrowing keys."
    (interactive)
    (when consult--narrow-keys
      (consult-narrow
       (if consult--narrow
           (let ((idx (seq-position consult--narrow-keys
                                    (assq consult--narrow consult--narrow-keys))))
             (unless (eq idx (1- (length consult--narrow-keys)))
               (car (nth (1+ idx) consult--narrow-keys))))
         (caar consult--narrow-keys)))))

  (define-key consult-narrow-map (kbd "C-,") #'consult-narrow-cycle-backward)
  (define-key consult-narrow-map (kbd "C-.") #'consult-narrow-cycle-forward)

  (defun consult-git-grep-at-point ()
    (interactive)
    (consult-git-grep nil (evil-visual-thing-at-point)))

  (defun consult-line-at-point ()
    (interactive)
    (consult-line (evil-visual-thing-at-point)))

  (defun consult-line-multi-at-point ()
    (interactive)
    (consult-line-multi nil (evil-visual-thing-at-point)))

  (defun consult-grep-in-directory ()
    (interactive)
    (consult-git-grep t (evil-visual-thing-at-point)))

  (defun evil-visual-thing-at-point ()
    (if (evil-visual-state-p)
        (progn
          (let ((thing (buffer-substring-no-properties (marker-position evil-visual-beginning)
                                                       (marker-position evil-visual-end))))
            (evil-exit-visual-state)
            thing))
      (thing-at-point 'symbol t)))

  (use-package evil-leader
    :config
    (evil-leader/set-key
      "cG" 'consult-grep
      "cg" nil
      "cgg" 'consult-git-grep
      "cgl" 'consult-goto-line
      "cb" 'consult-buffer
      "cr" 'consult-recent-file
      "ca" 'consult-apropos
      "cef" 'consult-flycheck
      "co" 'consult-outline
      "cm" 'consult-mark
      "cM" 'consult-global-mark
      "ci" 'consult-imenu
      "cI" 'consult-imenu-multi
      "cf" 'consult-find
      "cl" nil
      "cll" 'consult-line
      "cld" 'consult-lsp-diagnostics
      "cls" 'consult-lsp-symbols
      "clfs" 'consult-lsp-file-symbols
      "cL" 'consult-line-multi
      "cy" 'consult-yank-from-kill-ring
      "cd" 'consult-dir
      "cgg" 'consult-git-grep-at-point
      "cgd" 'consult-grep-in-directory
      "cll" 'consult-line-at-point
      "cL" 'consult-line-multi-at-point)))

(use-package consult-flycheck :after (consult flycheck))

(use-package consult-lsp
  :after (consult lsp-mode))

(use-package consult-dir :after (consult))

(use-package consult-projectile
  :after (consult projectile)
  :config
  (add-to-list 'consult-buffer-sources
               'consult-projectile--source-projectile-file
               t))

(use-package embark
  :after (consult)
  :bind (("C-a" . embark-act))
  :config
  (use-package ace-window)
  (use-package projectile)
  ;; (:orig-type multi-category :orig-target .emacs.d/elpa/consult-20220408.657/consult-imenu.el����� :bounds nil :type file :target .emacs.d/elpa/consult-20220408.657/consult-imenu.el)
  (defun embark--act-around-projectile (func &rest args)
    (let ((action (car args))
          (target (cadr args))
          (quit (caddr args)))
      (if-let ((project-p (projectile-project-root))
               (type (plist-get target :type))
               (type-file-p (eq 'file type))
               (relative-p (not (file-name-absolute-p (plist-get target :target))))
               (path (expand-file-name (plist-get target :target)
                                       (projectile-project-root))))
          (funcall func action (plist-put target :target path) quit)
        (apply func args))))

  (advice-add 'embark--act :around 'embark--act-around-projectile)

  (defun evil-vsplit-find-file (filename)
    (let ((evil-vsplit-window-right t)
          (evil-auto-balance-windows t))
      (evil-window-vsplit nil (expand-file-name filename))))

  (defun evil-split-find-file (filename)
    (let ((evil-split-window-below nil)
          (evil-auto-balance-windows t))
      (evil-window-split nil (expand-file-name filename))))

  (defun switch-window-if-gteq-3-windows ()
    (let ((windows (cl-remove-if #'(lambda (window)
                                     (member (buffer-name (window-buffer window))
                                             aw-ignored-buffers))
                                 (window-list))))
      (if (>= (1+ (length windows)) 3)
          (aw-switch-to-window (aw-select "Ace - Window")))))


  (defun embark-find-file-vsplit (filename &optional wildcards)
    (switch-window-if-gteq-3-windows)
    (evil-vsplit-find-file filename))

  (defun embark-find-file-split (filename &optional wildcards)
    (switch-window-if-gteq-3-windows)
    (evil-split-find-file filename))

  (defun embark-find-file-other-window (filename &optional wildcards)
    (if (one-window-p)
        (find-file-other-window (expand-file-name filename))
      (let ((buf (find-file-noselect (expand-file-name filename)))
            (window (aw-select "Ace - Window")))
        (unwind-protect
            (progn
              (aw-switch-to-window window)
              (switch-to-buffer buf)
              (select-window window))))))

  (define-key embark-file-map
    (kbd "v") 'embark-find-file-vsplit)
  (define-key embark-file-map
    (kbd "C-v") 'embark-find-file-vsplit)
  (define-key embark-file-map
    (kbd "s") 'embark-find-file-split)
  (define-key embark-file-map
    (kbd "C-s") 'embark-find-file-split)
  (define-key embark-file-map
    (kbd "o") 'embark-find-file-other-window)
  (define-key embark-file-map
    (kbd "C-o") 'embark-find-file-other-window)
  (define-key embark-file-map
    (kbd "V") 'embark-vc-file-map)

  (defun embark-switch-to-buffer-split (buffer-or-name)
    (switch-window-if-gteq-3-windows)
    (split-window (selected-window) nil 'below)
    (balance-windows (window-parent))
    (switch-to-buffer (window-normalize-buffer-to-switch-to buffer-or-name)))

  (defun embark-switch-to-buffer-vsplit (buffer-or-name)
    (switch-window-if-gteq-3-windows)
    (split-window (selected-window) nil 'left)
    (balance-windows (window-parent))
    (switch-to-buffer (window-normalize-buffer-to-switch-to buffer-or-name)))

  (defun embark-switch-to-buffer-other-window (buffer-or-name)
    (if (= (length (window-list)) 1)
        (embark-switch-to-buffer-split buffer-or-name)
      (let ((buf buffer-or-name)
            (window (aw-select "Ace - Window")))
        (aw-switch-to-window window)
        (switch-to-buffer buf))))

  (define-key embark-buffer-map
    (kbd "v") 'embark-switch-to-buffer-vsplit)
  (define-key embark-buffer-map
    (kbd "C-v") 'embark-switch-to-buffer-vsplit)
  (define-key embark-buffer-map
    (kbd "s") 'embark-switch-to-buffer-split)
  (define-key embark-buffer-map
    (kbd "C-s") 'embark-switch-to-buffer-split)
  (define-key embark-buffer-map
    (kbd "o") 'embark-switch-to-buffer-other-window)
  (define-key embark-buffer-map
    (kbd "C-o") 'embark-switch-to-buffer-other-window)

  (embark-define-keymap embark-consult-grep-map
    "Keymap for consult-grep actions."
    :parent embark-general-map)

  (add-to-list 'embark-keymap-alist '(consult-grep embark-consult-grep-map))
  (defun embark-switch-to-file-vsplit (filename)
    (let* ((n (consult-normalize-file-string filename))
           (path (car n))
           (line (cadr n)))
      (embark-switch-to-buffer-vsplit (find-file-noselect path))
      (when line (goto-line line))))
  (defun embark-switch-to-file-split (filename)
    (let* ((n (consult-normalize-file-string filename))
           (path (car n))
           (line (cadr n)))
      (embark-switch-to-buffer-split (find-file-noselect path))
      (when line (goto-line line))))
  (defun embark-switch-to-file-window (filename)
    (let* ((n (consult-normalize-file-string filename))
           (path (car n))
           (line (cadr n)))
      (embark-switch-to-buffer-other-window (find-file-noselect path))
      (when line (goto-line line))))

  (define-key embark-consult-grep-map
    (kbd "v") 'embark-switch-to-file-vsplit)
  (define-key embark-consult-grep-map
    (kbd "C-v") 'embark-switch-to-file-vsplit)
  (define-key embark-consult-grep-map
    (kbd "s") 'embark-switch-to-file-split)
  (define-key embark-consult-grep-map
    (kbd "C-s") 'embark-switch-to-file-split)
  (define-key embark-consult-grep-map
    (kbd "o") 'embark-switch-to-file-window)
  (define-key embark-consult-grep-map
    (kbd "C-o") 'embark-switch-to-file-window)

  (defun embark-which-key-indicator ()
    "An embark indicator that displays keymaps using which-key.
The which-key help message will show the type and value of the
current target followed by an ellipsis if there are further
targets."
    (lambda (&optional keymap targets prefix)
      (if (null keymap)
          (which-key--hide-popup-ignore-command)
        (which-key--show-keymap
         (if (eq (plist-get (car targets) :type) 'embark-become)
             "Become"
           (format "Act on %s '%s'%s"
                   (plist-get (car targets) :type)
                   (embark--truncate-target (plist-get (car targets) :target))
                   (if (cdr targets) "…" "")))
         (if prefix
             (pcase (lookup-key keymap prefix 'accept-default)
               ((and (pred keymapp) km) km)
               (_ (key-binding prefix 'accept-default)))
           keymap)
         nil nil t (lambda (binding)
                     (not (string-suffix-p "-argument" (cdr binding))))))))

  (setq embark-indicators
        '(embark-which-key-indicator
          embark-highlight-indicator
          embark-isearch-highlight-indicator))

  (defun embark-hide-which-key-indicator (fn &rest args)
    "Hide the which-key indicator immediately when using the completing-read prompter."
    (which-key--hide-popup-ignore-command)
    (let ((embark-indicators
           (remq #'embark-which-key-indicator embark-indicators)))
      (apply fn args)))

  (advice-add #'embark-completing-read-prompter
              :around #'embark-hide-which-key-indicator)
  (require 'embark-consult))

(use-package embark-consult
  :after (consult embark)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(el-get-bundle seudut/perspeen)
(use-package perspeen
  :commands (perspeen-mode)
  :init
  (setq perspeen-use-tab t)
  (setq perspeen-workspace-default-name "emacs")
  (add-hook 'evil-mode-hook 'perspeen-mode)
  :config
  (defun perspeen-update-mode-string ()
    (setq perspeen-modestring ""))

  (defun perspeen-tab--set-header-line-format-advice (&rest _args)
    (perspeen-tab--update-current-buffer))

  (advice-add 'perspeen-tab--set-header-line-format
              :before
              'perspeen-tab--set-header-line-format-advice)


  (defun perspeen-tab-create-tab-advice (org-func &optional buffer marker switch-to-tab)
    ;; (unless buffer
    ;;   (funcall org-func buffer marker switch-to-tab))
    ;; (let* ((bufname (buffer-name buffer))
    ;;        (tab (cl-find-if #'(lambda (tab)
    ;;                             (string= (buffer-name (get tab 'current-buffer))
    ;;                                      bufname))
    ;;                         (perspeen-tab-get-tabs))))
    ;;   (if tab
    ;;       (perspeen-tab-switch-to-tab tab)
    ;;     (funcall org-func buffer marker switch-to-tab)))
    (funcall org-func buffer marker switch-to-tab)
    )

  (advice-add 'perspeen-tab-create-tab
              :around
              'perspeen-tab-create-tab-advice)
  ;; (advice-remove 'perspeen-tab-create-tab
  ;;                'perspeen-tab-create-tab-advice)
  (defun my-perspeen-set-ws-root-dir (project-to-switch &optional arg)
    (perspeen-change-root-dir project-to-switch))
  (advice-add 'projectile-switch-project-by-name :after 'my-perspeen-set-ws-root-dir)

  (defun perspeen-tab-advice-bofore-evil-window (_)
    (perspeen-tab--construct-header-line))

  (defun perspeen-tab-advice-after-evil-window (_)
    (perspeen-tab--update-current-buffer))

  (dolist (fun '(evil-window-up
                 evil-window-bottom
                 evil-window-left
                 evil-window-right))
    ;; (advice-remove fun 'perspeen-tab--update-current-buffer)
    (advice-add fun :after 'perspeen-tab-advice-after-evil-window)
    ;; (advice-add fun :before 'perspeen-tab-advice-bofore-evil-window)
    ;; (advice-remove fun 'perspeen-tab-advice-bofore-evil-window)
    )

  (defun perspeen-workspaces-source-consult ()
    (mapcar (lambda (ws)
              (let ((name (perspeen-ws-struct-name ws)))
                name))
            perspeen-ws-list))

  (defun perspeen-tabs-source-consult ()
    (if perspeen-tab-configurations
        (let ((index -1))
          (mapcar (lambda (tab)
                    (let* ((buffer (get tab 'current-buffer))
                           (current-dir (or (file-name-directory (or (buffer-file-name buffer) ""))
                                            default-directory)))
                      (setq index (1+ index))
                      (format "%s: %s" index (buffer-name buffer))))
                  (perspeen-tab-get-tabs)))
      nil))

  (use-package embark
    :config
    (defun embark-find-file-tab (filename &optional wildcards)
      (perspeen-tab-create-tab
       (find-file-noselect (expand-file-name filename))
       0)
      (perspeen-update-mode-string))
    (define-key embark-file-map (kbd "t") 'embark-find-file-tab)
    (defun embark-switch-to-buffer-tab (buffer-or-name)
      (perspeen-tab-create-tab
       (window-normalize-buffer-to-switch-to buffer-or-name)
       0)
      (perspeen-update-mode-string))
    (define-key embark-buffer-map (kbd "t") 'embark-switch-to-buffer-tab)
    (defun embark-switch-to-file-tab (file-name)
      (let* ((n (consult-normalize-file-string file-name))
             (path (car n))
             (line (cadr n))
             (path (if (file-name-absolute-p path)
                       path
                     (expand-file-name path default-directory)))
             (buffer (find-file-noselect path)))
        (perspeen-tab-create-tab
         (window-normalize-buffer-to-switch-to buffer)
         0)
        (perspeen-update-mode-string)
        (when line
          (goto-line line))))
    (define-key embark-consult-grep-map (kbd "t") 'embark-switch-to-file-tab)
    )

  (use-package consult
    :config
    (defun consult--workspace-action (name)
      (let ((ws (cl-find-if #'(lambda (ws) (string= name (perspeen-ws-struct-name ws)))
                            perspeen-ws-list)))
        (when ws
          (perspeen-switch-ws-internal ws)
          (perspeen-update-mode-string))))

    (defvar consult--source-perspeen-workspaces
      `(
        :name "Workspaces"
        :narrow ?w
        :category perspeen-workspace
        :face consult-bookmark
        :items ,#'perspeen-workspaces-source-consult
        :action ,#'consult--workspace-action
        ))

    (defun consult--perspeen-tab-action (name)
      (if-let ((idx-s (car (split-string name ":")))
               (idx (string-to-number idx-s)))
          (progn
            (perspeen-tab-switch-internal idx))))

    (defvar consult--source-perspeen-tabs
      `(
        :name "Tabs"
        :narrow ?t
        :category perspeen-tab
        :face consult-bookmark
        :items ,#'perspeen-tabs-source-consult
        :action ,#'consult--perspeen-tab-action
        ))
    (add-to-list 'consult-buffer-sources
                 'consult--source-perspeen-tabs
                 t)

    (defun consult-perspeen ()
      (interactive)
      (when-let (buffer (consult--multi (list consult--source-perspeen-tabs
                                              consult--source-perspeen-workspaces)
                                        :require-match nil
                                        :prompt "Switch to: "))
        (unless(plist-get (cdr buffer) :match)
          (let ((name (car buffer)))
            (perspeen-create-ws)
            (perspeen-rename-ws name)
            (let ((projects (projectile-relevant-known-projects)))
              (when projects
                (projectile-completing-read
                 "Switch to project: " projects
                 :action (lambda (project)
                           (projectile-switch-project-by-name project))
                 :initial-input name)))
            ))))
    (define-key evil-normal-state-map "tt" 'consult-perspeen))

  (advice-add 'evil-window-delete :after 'perspeen-tab--update-current-buffer)

  (define-key evil-normal-state-map "T" nil)
  (define-key evil-normal-state-map "Tt" 'perspeen-create-ws)
  (define-key evil-normal-state-map "Tn" 'perspeen-next-ws)
  (define-key evil-normal-state-map "Tp" 'perspeen-previous-ws)
  (define-key evil-normal-state-map "Tl" 'perspeen-goto-last-ws)
  (define-key evil-normal-state-map "Tg" 'perspeen-goto-ws)
  (define-key evil-normal-state-map "Ts" 'perspeen-ws-eshell)
  (define-key evil-normal-state-map "Tk" 'perspeen-delete-ws)
  (define-key evil-normal-state-map "Ts" 'perspeen-ws-eshell)
  (define-key evil-normal-state-map "Tr" 'perspeen-rename-ws)
  (define-key evil-normal-state-map "Tj" 'perspeen-go-ws)
  (define-key evil-normal-state-map "Td" 'perspeen-change-root-dir)

  (define-key evil-normal-state-map "to" 'perspeen-tab-create-tab)
  (define-key evil-normal-state-map "tk" 'perspeen-tab-del)
  (define-key evil-normal-state-map "tn" 'perspeen-tab-next)
  (define-key evil-normal-state-map "tp" 'perspeen-tab-prev)
  )

(provide '04-helm)
;;; 04-helm.el ends here
