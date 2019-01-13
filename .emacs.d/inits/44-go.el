;;; 44-go.el ---                                     -*- lexical-binding: t; -*-

;; Copyright (C) 2018

;; Author:  <yuya373@archlinux>
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
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(require 'el-get)
(require 'use-package)

(el-get-bundle go-mode)
(el-get-bundle go-company)
(el-get-bundle go-eldoc)

(use-package go-mode
  :mode ((".go\\'" . go-mode))
  :init
  (defun init-go-mode ()
    (interactive)
    (setq-local helm-dash-docsets '("Go"))
    (setq-local tab-width 2)
    (setq-local whitespace-style (remq 'tabs
                                       (remq 'tab-mark
                                             whitespace-style)))

    (setq-local whitespace-display-mappings
                '((space-mark ?\u3000 [?\　])
                  (newline-mark ?\n [?\¬ ?\n])))

    (whitespace-mode -1)
    (whitespace-mode 1)
    (go-eldoc-setup)
    (add-hook 'before-save-hook 'gofmt-before-save t t)
    )

  (add-hook 'go-mode-hook 'init-go-mode)

  (setq godoc-and-godef-command "go doc")
  :config
  (use-package company-go
    :init
    (setq company-go-show-annotation t)
    :config
    (add-to-list 'company-backends 'company-go))
  (use-package go-eldoc)
  (defun go-compile ()
    (interactive)
    (let ((compile-command "go build -v && go test -v ./... && go vet ./...")
          (compile-command "go test -v ./... && go vet ./... && go build -v")
          (default-directory (vc-root-dir)))
      (compilation-start compile-command)))
  (defun go-run-file ()
    (interactive)
    (let* ((file-name (buffer-file-name))
           (content (buffer-substring-no-properties (point-min) (point-max)))
           (compile-command (format "go run %s" file-name)))

      (if (and (string-match "package main" content)
               (string-match "func main()" content))
          (compilation-start compile-command)
        (let* ((paths (split-string file-name "/"))
               (dirs (cl-loop for n
                              from (- (length paths) 2)
                              downto 1
                              collect (mapconcat
                                       #'identity
                                       (seq-take paths n)
                                       "/")))
               (dir (cl-find-if #'(lambda (dir)
                                    (file-exists-p
                                     (format "%s/main.go" dir)))
                                dirs)))

          (when dir
            (compilation-start (format "go run %s/main.go" dir)))))))
  (evil-define-key 'visual go-mode-map
    ",p" 'go-play-region)
  (evil-define-key 'normal go-mode-map
    ",ig" 'go-goto-imports
    ",ir" 'go-remove-unused-imports
    ",ia" 'go-import-add
    ",j" 'godef-jump
    ",d" 'godef-describe
    ",p" 'go-play-buffer
    ",h" 'godoc-at-point
    ",c" 'go-compile
    ",r" 'go-run-file
    ))


(provide '44-go)
;;; 44-go.el ends here
