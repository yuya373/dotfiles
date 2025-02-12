;;; 03-util.el --- util                              -*- lexical-binding: t; -*-

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
  (require 'use-package))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :commands (which-key-mode)
  :init
  (setq which-key-use-C-h-commands t)
  (setq which-key-idle-delay 0.3)
  (setq which-key-separator " - ")
  (setq which-key-show-prefix 'echo)
  (setq which-key-popup-type 'side-window)
  (setq which-key-side-window-location 'bottom)
  (setq which-key-side-window-max-height 0.50)
  (setq which-key-allow-evil-operators t)
  (add-hook 'evil-mode-hook 'which-key-mode)
  :config
  ;; (which-key-add-key-based-replacements "SPC r" " Rest")
  (which-key-add-key-based-replacements "SPC a" " Ag")
  (which-key-add-key-based-replacements "SPC d" " Dash")
  (which-key-add-key-based-replacements "SPC f" " Find-File")
  (which-key-add-key-based-replacements "SPC p" " Projectile")
  ;; (which-key-add-key-based-replacements "SPC u" " Undo-Tree")
  (which-key-add-key-based-replacements "SPC b" " Buffers")
  (which-key-add-key-based-replacements "SPC e" " Errors")
  (which-key-add-key-based-replacements "SPC i" " Indent-Guides")
  (which-key-add-key-based-replacements "SPC t" " Tags, Transrate")
  (which-key-add-key-based-replacements "SPC w" " Windows")
  (which-key-add-key-based-replacements "SPC g" " Git")
  (which-key-add-key-based-replacements ", h" " Help")
  (which-key-add-key-based-replacements "SPC m" " Memo, Message")
  (which-key-add-key-based-replacements "SPC m u" " slack-update")
  (which-key-add-key-based-replacements "SPC c" " Consult")

  (which-key-add-major-mode-key-based-replacements 'emacs-lisp-mode
    ", e" " Eval")
  (which-key-add-major-mode-key-based-replacements 'enh-ruby-mode
    ", b" " Bundler"
    ", r" " Rails"
    ", g" " Goto"
    ", t" " Test, Tags")
  (which-key-add-major-mode-key-based-replacements 'org-mode
    ", i" "Insert"
    ", i t" " Insert Template")
  (which-key-add-major-mode-key-based-replacements 'dired-mode
    ", m" "Mark"
    ", d" "Dired-Do")
  )

(use-package highlight-indent-guides
  :ensure t
  :commands (highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-responsive 'top)
  (setq highlight-indent-guides-method 'character)
  (setq highlight-indent-guides-character ?\|)
  ;; (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
  (add-hook 'yaml-mode-hook 'highlight-indent-guides-mode))

(use-package restclient
  :ensure t
  :mode (("\\.restclient\\'" . restclient-mode))
  :init
  (setq restclient-dir "~/Dropbox/junk/")
  (defun restclient-client-buf-name ()
    (concat (format-time-string "%Y-%m-%d") ".restclient"))
  (defun create-restclient-buffer ()
    (interactive)
    (find-file-other-window
     (concat restclient-dir (restclient-client-buf-name))))
  :config
  (evil-define-key 'normal restclient-mode-map
    ",y"  'restclient-copy-curl-command
    ",ss" 'restclient-http-send-current
    ",sr" 'restclient-http-send-current-raw
    ",sv" 'restclient-http-send-current-stay-in-window
    ",n"  'restclient-jump-next
    ",p"  'restclient-jump-prev
    ",m"  'restclient-mark-current))

(use-package esup
  :ensure t
  :commands (esup))

(use-package auto-save-buffers-enhanced
  :ensure t
  :init
  (setq make-backup-files nil)
  (setq auto-save-list-file-prefix nil)
  (setq create-lockfiles nil)
  (setq auto-save-buffers-enhanced-interval 1)
  (setq auto-save-buffers-enhanced-quiet-save-p t)
  (setq auto-save-buffers-enhanced-exclude-regexps
        '("^/scp:" "^/ssh:" "/sudo:" "/multi:"))
  :config
  (defun auto-save-buffers-enhanced-save-buffers-if-normal-state ()
    ;; (if-let* ((filename (buffer-file-name))
    ;;           (modes (split-string (number-to-string (file-modes filename)) "" t))
    ;;           (modes-symbolic (file-modes-number-to-symbolic (file-modes filename)))
    ;;        )
    ;;   (message "MODES: %s, %s" modes modes-symbolic))
    (if (eq evil-state 'normal)
        (ignore-errors
          (auto-save-buffers-enhanced-save-buffers))))
  (defun auto-save-buffers-enhanced (flag)
    (when flag
      (run-with-idle-timer
       auto-save-buffers-enhanced-interval t
       'auto-save-buffers-enhanced-save-buffers-if-normal-state)))
  (auto-save-buffers-enhanced t))

(use-package server
  :commands (server-start server-running-p)
  :init
  (defun start-server ()
    (unless (server-running-p)
      (server-start)))
  (add-hook 'after-init-hook 'start-server))

(use-package wgrep-ag
  :ensure t
  :commands (wgrep-ag-setup))

(use-package ag
  :ensure t
  :commands (ag)
  :init
  (add-hook 'ag-mode-hook 'wgrep-ag-setup)
  (setq ag-highlight-search t
        ag-reuse-window nil
        ag-reuse-buffers nil)
  :config
  (evil-set-initial-state 'ag-mode 'normal)
  (evil-define-key 'normal ag-mode-map
    "E" 'wgrep-change-to-wgrep-mode))

(use-package tramp
  :defer t
  :config
  (setq tramp-default-method "scp")
  ;; (set-default 'tramp-default-proxies-alist (quote ((".*" "\\`root\\'" "/ssh:%h:"))))
  (add-to-list 'tramp-default-proxies-alist '(nil "\\`root\\'" "/ssh:%h:"))
  (add-to-list 'tramp-default-proxies-alist '("localhost\\'" nil, nil))
  (add-to-list 'tramp-default-proxies-alist '((regexp-quote (system-name)) nil nil))
  ;; (add-to-list 'tramp-default-proxies-alist '("redash" "\\`root\\'" "/ssh:redash:"))
  )

(use-package subword-mode
  :commands (subword-mode)
  :init
  (add-hook 'scala-mode-hook 'subword-mode))

(use-package dired
  :init
  (setq dired-use-ls-dired nil)
  (setq dired-dwim-target t)
  (setq dired-recursive-copies 'always)
  :config
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

(use-package dired-k
  :ensure t
  :commands (dired-k dired-k-no-revert)
  :init
  (add-hook 'dired-after-readin-hook 'dired-k-no-revert)
  (setq dired-k-style 'git)
  (setq dired-k-human-readable t))

(use-package es-mode
  :ensure t
  :mode (("\\.es\\'" . es-mode)))

(use-package sr-speedbar
  :ensure t
  :commands (sr-speedbar-toggle)
  :config
  (evil-initial-state 'speedbar-mode 'normal)
  (evil-declare-key 'normal speedbar-key-map
    "h" 'backward-char
    "j" 'speedbar-next
    "k" 'speedbar-prev
    "l" 'forward-char
    "i" 'speedbar-item-info
    "r" 'speedbar-refresh
    "u" 'speedbar-up-directory
    "o" 'speedbar-toggle-line-expansion
    (kbd "C-h") 'evil-window-left
    (kbd "RET") 'speedbar-edit-line))

(use-package imenu-anywhere
  :ensure t
  :commands (helm-imenu-anywhere))

(use-package imenu
  :defer t
  :init
  (setq imenu-auto-rescan t)
  (add-hook 'imenu-after-jump-hook '(lambda ()
                                      (recenter 10))))

(use-package font-lock-studio
  :ensure t
  :commands (font-lock-studio))

(defun font-at-point ()
  (interactive)
  (message (font-xlfd-name (font-at (point)))))

(defun image-at-point ()
  (interactive)
  (let* ((point (point))
         (display-prop (get-text-property point 'display))
         (type (car-safe display-prop)))
    (when (eq type 'image)
      (let* ((image-plist (cdr display-prop))
             (file (plist-get image-plist :file)))
        (when file
          (helm-find-files-1 file))))))

(use-package string-inflection
  :ensure t
  )

(provide '03-util)
;;; 03-util.el ends here
