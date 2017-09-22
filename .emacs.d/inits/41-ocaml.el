;;; 41-ocaml.el ---                                  -*- lexical-binding: t; -*-

;; Copyright (C) 2017

;; Author:  <yuya373@yuya373>
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


(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    ;; Register Merlin
    ;; (load "/home/yuya373/.opam/4.05.0/share/emacs/site-lisp/tuareg-site-file")
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    ;; (autoload 'merlin-mode "merlin" nil t nil)
    ;; (autoload 'tuareg-mode "tuareg-site-file" nil t nil)
    ;; (add-to-list 'auto-mode-alist '("\\.ml[iylp]?$" . tuareg-mode))
    ;; (setq merlin-command 'ocamlmerlin)
    ;; (with-eval-after-load 'company
    ;;   (add-to-list 'company-backends 'merlin-company-backend))
    ;; (add-hook 'tuareg-mode-hook 'merlin-mode t)

    ;; Automatically start it in OCaml buffers
    ;; (add-hook 'caml-mode-hook 'merlin-mode t)
    (use-package merlin
      :commands (merlin-mode)
      :init
      (add-hook 'tuareg-mode-hook 'merlin-mode)
      (defun enable-merlin-company ()
        (add-to-list 'company-backends 'merlin-company-backend))
      (add-hook 'merlin-mode-hook 'enable-merlin-company)
      )
    (use-package ocamldebug
      :commands (ocamldebug)
      :init
      (defalias 'camldebug 'ocamldebug)
      (if (fboundp 'register-definition-prefixes)
          (register-definition-prefixes "ocamldebug"
                                        '("ocamldebug-" "def-ocamldebug")))
      )

    (use-package tuareg
      :mode (("\\.ml[ip]?\\'" . tuareg-mode)
             ("\\.eliomi?\\'" . tuareg-mode))
      :interpreter (("ocamlrun" . tuareg-mode)
                    ("ocaml" .  tuareg-mode))
      :commands (tuareg-run-ocaml)
      :init
      (defalias 'run-ocaml 'tuareg-run-ocaml)
      (if (fboundp 'register-definition-prefixes)
          (register-definition-prefixes "tuareg" '("tuareg-")))
      (dolist (ext '(".cmo" ".cmx" ".cma" ".cmxa" ".cmi"
                     ".annot" ".cmt" ".cmti"))
        (add-to-list 'completion-ignored-extensions ext))
      :config
      (define-key tuareg-interactive-mode-map (kbd "C-j") nil)
      (evil-define-key 'normal tuareg-interactive-mode-map
        "\C-j" 'evil-window-down)))
  )


(provide '41-ocaml)
;;; 41-ocaml.el ends here
