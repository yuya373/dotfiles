;;; 18-javascript.el ---                             -*- lexical-binding: t; -*-

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
  (require 'flycheck))

(el-get-bundle js2-mode)

(use-package js2-mode
  :mode (("\\.js\\'" . js2-mode)
         ;; ("\\.jsx\\'" . js2-jsx-mode)
         ;; ("\\.jsx.js\\'" . js2-jsx-mode)
         )
  :init
  (setq js2-highlight-level 3)
  (setq js2-include-browser-externs nil)
  (setq js2-mode-show-parse-errors nil)
  (setq js2-mode-show-strict-warnings nil)
  (setq js2-highlight-external-variables nil)
  (setq js2-include-jslint-globals nil)
  (setq js2-basic-offset 2)
  :config
  (defun my-js2-modify-syntax ()
    (modify-syntax-entry ?_ "w" js2-mode-syntax-table))
  (defun my-js2-jsx-modify-syntax ()
    (modify-syntax-entry ?_ "w" js2-jsx-mode-syntax-table))
  (add-hook 'js2-mode-hook 'my-js2-modify-syntax)
  (add-hook 'js2-jsx-mode-hook 'my-js2-jsx-modify-syntax)
  ;; (use-package flycheck-flow
  ;;   :config
  ;;   ;; (flycheck-add-next-checker 'javascript-eslint 'javascript-flow)
  ;;   )
  (use-package js2-imenu-extras)
  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode))

(el-get-bundle felipeochoa/rjsx-mode)
(use-package rjsx-mode
  :mode (("\\.jsx\\'" . rjsx-mode)
         ("\\.js\\'" . rjsx-mode)
         )
  :init
  (defun my-rjsx-use-buitin-indent ()
    (setq-local indent-line-function 'rjsx-indent-line))
  (add-hook 'rjsx-mode-hook 'my-rjsx-use-buitin-indent)
  :config
  (defun rjsx--indent-line-1 ()
    "Helper for `rjsx-indent-line'."
    (let* ((indent-tabs-mode nil)
           (cur-pos (point))
           (cur-char (char-after cur-pos))
           (node (js2-node-at-point (- cur-pos rjsx--indent-running-offset)))
           (parent (js2-node-parent node)))
      (cond
       ((rjsx-node-p node)
        (cond
         ((eq cur-char ?<)
          (if (rjsx-node-p parent)
              (rjsx--indent-line-to-offset parent sgml-basic-offset)
            ;; Top-level node, indent as JS
            (js-indent-line))
          (when rjsx--node-abs-pos-cache
            (setf (gethash node rjsx--node-abs-pos-cache)
                  (save-excursion (back-to-indentation) (point)))))
         ((memq cur-char '(?/ ?>))
          (rjsx--indent-line-to-offset node sgml-basic-offset))
         ((eq cur-char ?\n)
          (rjsx--indent-line-to-offset node sgml-basic-offset))
         (t (error "Don't know how to indent %s for JSX node" (make-string 1 cur-char)))))
       ((and (rjsx-identifier-p parent)
             (rjsx-member-p (js2-node-parent parent))
             (rjsx-node-p (js2-node-parent (js2-node-parent parent))))
        (rjsx--indent-line-to-offset (js2-node-parent (js2-node-parent parent)) 0))

       ;; JSX children
       ((rjsx-closing-tag-p node)
        (rjsx--indent-line-to-offset parent 0))
       ((rjsx-text-p node)
        (rjsx--indent-line-to-offset parent sgml-basic-offset))
       ((rjsx-wrapped-expr-p node)
        (if (eq cur-char ?})
            (js-indent-line)
          (rjsx--indent-line-to-offset parent sgml-basic-offset)))

       ;; Attribute-like (spreads, attributes, etc.)
       ;; if first attr is on same line as tag, then align
       ;; otherwise indent to parent level + sgml-basic-offset
       ((or (rjsx-identifier-p node)
            (and (rjsx-identifier-p parent)
                 (rjsx-attr-p (js2-node-parent parent)))
            (rjsx-spread-p node))
        (let* ((tag (or (rjsx-ancestor node #'rjsx-node-p)
                        (error "Did not find containing JSX tag for attributes")))
               (name (rjsx-node-name tag))
               column)
          (save-excursion
            (goto-char (rjsx--node-abs-pos tag))
            (setq column (current-column))
            (when name (forward-char (js2-node-end name)) (skip-chars-forward " \t"))
            (if (eolp)
                (setq column (+ column sgml-basic-offset sgml-attribute-offset))
              (setq column (current-column))))
          (indent-line-to column)))

       ;; Everything else indent as javascript
       (t (js-indent-line)))

      (when rjsx--indent-region-p
        (cl-incf rjsx--indent-running-offset
                 (- (save-excursion (back-to-indentation) (point))
                    cur-pos)))))

  (defun rjsx-delete-creates-full-tag-and-escape (n &optional killflag)
    (interactive "p")
    (rjsx-delete-creates-full-tag n killflag)
    (evil-normal-state))

  (eval-after-load "evil"
    (evil-define-key 'insert rjsx-mode-map
      (kbd "C-d") 'rjsx-delete-creates-full-tag-and-escape))
  )

(el-get-bundle coffee-mode)
(use-package coffee-mode
  :mode (("\\.coffee\\'" . coffee-mode))
  :init
  (setq coffee-tab-width 2)
  (setq coffee-indent-tabs-mode nil))

(el-get-bundle company-tern :post-init nil)
(use-package tern
  :commands (tern-mode)
  :init
  (add-hook 'js2-mode-hook 'tern-mode)
  (add-hook 'js2-jsx-mode-hook 'tern-mode)
  :config
  ;; (defun strip-multibyte (str)
  ;;   (replace-regexp-in-string "[[:multibyte:]]*" "" str))
  ;; (defun buffer-string-without-multibyte ()
  ;;   (strip-multibyte (buffer-string)))
  ;; (add-to-list 'tern-command "--no-port-file" t)
  (evil-define-key 'normal tern-mode-keymap
    ",gd" 'tern-find-definition
    ",gD" 'tern-find-definition-by-name
    ",ht" 'tern-get-type
    ",hh" 'tern-get-docs)
  )

(use-package company-tern
  :commands (company-tern)
  :init
  (defun enable-company-tern ()
    (interactive)
    ;; (make-local-variable 'company-backends)
    ;; (make-local-variable 'company-idle-delay)
    ;; (setq company-idle-delay 0)
    ;; (setq company-backends (remq 'company-capf company-backends))
    ;; (setq company-backends (remq 'company-tern company-backends))
    (add-to-list 'company-backends
                 '(company-tern
                   :with
                   company-dabbrev-code
                   )))
  (add-hook 'js2-mode-hook 'enable-company-tern)
  (add-hook 'js2-jsx-mode-hook 'enable-company-tern)
  )

(el-get-bundle flycheck-flow
  :type github
  :pkgname "lbolla/emacs-flycheck-flow")
(use-package flycheck-flow
  :config
  (defun my/use-flow-from-node-modules ()
    (interactive)
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  ".flowconfig"))
           (flow (and root
                      (expand-file-name "node_modules/flow-bin/cli.js"
                                        root))))
      (when (and flow (file-executable-p flow))
        (setq-local flycheck-javascript-flow-executable flow))))
  (add-hook 'flycheck-mode-hook 'my/use-flow-from-node-modules)
  ;;   (flycheck-define-checker javascript-flow
  ;;     "A JavaScript syntax and style checker using Flow.

  ;; See URL `http://flowtype.org/'."
  ;;     :command (
  ;;               "flow"
  ;;               "check-contents"
  ;;               (eval flycheck-javascript-flow-args)
  ;;               "--json"
  ;;               "--from" "emacs"
  ;;               "--color=never"
  ;;               source-original)
  ;;     :standard-input t
  ;;     :predicate flycheck-flow--predicate
  ;;     :error-parser flycheck-flow--parse-json
  ;;     ;; js3-mode doesn't support jsx
  ;;     :modes (js-mode js-jsx-mode js2-mode js2-jsx-mode js3-mode rjsx-mode))
  )

(provide '18-javascript)
;;; 18-javascript.el ends here
