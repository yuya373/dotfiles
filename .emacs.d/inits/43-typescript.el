;;; 43-typescript.el ---                             -*- lexical-binding: t; -*-

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

(eval-when-compile
  (require 'el-get)
  (require 'use-package))

(el-get-bundle typescript-mode)
(el-get-bundle web-mode)
(el-get-bundle f)

(defun file-tsx-p ()
  (string-suffix-p "tsx"
                   (or (buffer-file-name)
                       (buffer-name))))


;; (use-package web-mode
;;   :mode (("\\.tsx\\'" . web-mode))
;;   :init
;;   (setq web-mode-markup-indent-offset 2
;;         web-mode-css-indent-offset 2
;;         web-mode-code-indent-offset 2
;;         web-mode-block-padding 2
;;         web-mode-comment-style 2
;;         web-mode-auto-quote-style 1

;;         web-mode-enable-css-colorization t
;;         web-mode-enable-auto-pairing t
;;         web-mode-enable-comment-keywords t
;;         web-mode-enable-current-element-highlight t
;;         )
;;   (setq web-mode-extra-auto-pairs nil)
;;   (defun setup-tsx ()
;;     (when (and (buffer-file-name)
;;                (string= "tsx" (file-name-extension
;;                                (buffer-file-name))))
;;       (eldoc-mode +1)
;;       (typescript-setup-projectile)))
;;   (add-hook 'web-mode-hook 'setup-tsx))

(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescript-mode))
  :init
  (setq typescript-indent-level 2)
  :config
  (use-package sgml-mode)
  (require 'rjsx-mode)
  (define-key typescript-mode-map (kbd "<") 'rjsx-electric-lt)
  (define-key typescript-mode-map (kbd ">") 'rjsx-electric-gt)
  (evil-define-key 'insert typescript-mode-map
    (kbd "C-d") 'rjsx-delete-creates-full-tag)
  (evil-define-key 'normal typescript-mode-map
    (kbd "gt") 'rjsx-jump-tag
    (kbd ",rt") 'rjsx-rename-tag-at-point
    (kbd ",c") 'rjsx-comment-dwim)
  (use-package projectile
    :config
    (defun typescript-projectile-bundler-cmd ()
      (if (file-exists-p (expand-file-name "yarn.lock" (projectile-project-root)))
          "yarn"
        "npm"))
    (require 'f)
    (defun typescript-projectile-build-consult-source ()
      (let* ((dir (f-traverse-upwards (lambda (path)
                                        (f-exists? (f-expand "package.json" path)))
                                      default-directory))
             (json (with-temp-buffer
                     (goto-char (point-min))
                     (insert-file-contents (expand-file-name "package.json" dir))
                     (goto-char (point-min))
                     (json-parse-buffer)))
             (scripts (gethash "scripts" json))
             (source (make-hash-table :test #'equal)))
        (maphash #'(lambda (key value)
                     (puthash (format "%s - %s" key value)
                              key
                              source))
                 scripts)
        source))

    (use-package consult
      :config
      (define-compilation-mode consult-typescript-compilation-mode "consult-typescript-scripts"
        "Rust compilation mode.

Error matching regexes from compile.el are removed.")
      (require 'ansi-color)
      (defun consult-typescript-scripts ()
        (interactive)
        (let* ((source (typescript-projectile-build-consult-source))
               (script (consult--read
                        source
                        :require-match t
                        :prompt "Select command: "))
               (out-buf (get-buffer-create "*consult-typescript-scripts*")))
          (when script
            (with-current-buffer out-buf
              (setq buffer-read-only nil)
              (erase-buffer)
              (consult-typescript-compilation-mode)
              (setq buffer-read-only t)
              (goto-char (point-min)))
            (let* ((run-cmd (gethash script source))
                   (process (start-file-process "consult-typescript-scripts"
                                                out-buf
                                                (typescript-projectile-bundler-cmd)
                                                "run"
                                                run-cmd)))
              (display-buffer out-buf)
              (set-process-filter process
                                  #'(lambda (process s)
                                      (when (buffer-live-p (process-buffer process))
                                        (with-current-buffer (process-buffer process)
                                          (setq buffer-read-only nil)
                                          (goto-char (process-mark process))
                                          (insert (ansi-color-filter-apply s))
                                          (set-marker (process-mark process) (point))
                                          (setq buffer-read-only t)))))

              (set-process-sentinel process
                                    #'(lambda (process event)
                                        (when (buffer-live-p (process-buffer process))
                                          (with-current-buffer (process-buffer process)
                                            (setq buffer-read-only nil)
                                            (insert (format "\n`%s %s' %s"
                                                            (typescript-projectile-bundler-cmd)
                                                            run-cmd
                                                            event))

                                            (setq buffer-read-only t)))))))))

      (evil-define-key 'normal typescript-mode-map
        (kbd ",s") 'consult-typescript-scripts)
      )))



(provide '43-typescript)
;;; 43-typescript.el ends here
