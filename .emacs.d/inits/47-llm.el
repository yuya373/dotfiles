;;; 47-llm.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2025  DESKTOP2

;; Author: DESKTOP2 <yuya373@DESKTOP2>
;; Keywords: lisp

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

(use-package gptel
  :ensure t
  :config
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
  (defun gptel--api-key-anthropic ()
    (gptel-api-key-from-auth-source "api.anthropic.com" "apiKey"))
  (setq gptel-backend (gptel-make-anthropic "Claude-thinking"
                        :stream t
                        :models '(claude-3-7-sonnet-20250219)
                        :key #'gptel--api-key-anthropic
                        :header (lambda () (when-let* ((key (gptel--api-key-anthropic)))
                                             `(("x-api-key" . ,key)
                                               ("anthropic-version" . "2023-06-01")
                                               ("anthropic-beta" . "pdfs-2024-09-25")
                                               ("anthropic-beta" . "output-128k-2025-02-19")
                                               ("anthropic-beta" . "prompt-caching-2024-07-31"))))
                        :request-params '(:thinking (:type "enabled" :budget_tokens 2048)
                                                    :max_tokens 4096)))
  (setq gptel-model 'claude-3-7-sonnet-20250219)
  (setq gptel-api-key #'gptel-api-key-from-auth-source)
  (setq gptel-use-header-line nil)

  (with-eval-after-load 'which-key
    (which-key-add-key-based-replacements "SPC a i" "AI")
    (which-key-add-key-based-replacements "SPC a i a" "Add To Context"))
  (with-eval-after-load 'evil
    (evil-leader/set-key
      "aii" 'gptel
      "aiaa" 'gptel-context-add
      "aiaf" 'gptel-context-add-file
      "air" 'gptel-rewrite
      "ait" 'gptel-tools
      ))
  (with-eval-after-load 'evil-collection
    (evil-collection-define-key 'normal 'gptel-context-buffer-mode-map
      (kbd "C-n") 'gptel-context-next
      (kbd "C-p") 'gptel-context-previous
      (kbd "RET") 'gptel-context-visit
      ",r" 'gptel-context-flag-deletion
      ",R" 'gptel-context-remove-all
      ",c" 'gptel-context-confirm
      ",q" 'gptel-context-quit
      )
    (evil-collection-define-key 'normal 'gptel-mode-map
      ",c" 'gptel-send
      ",m" 'gptel-menu
      ",t" 'gptel-tools
      ",q" 'gptel-abort)
    )
  )

(use-package posframe
  :ensure t
  :after (gptel))
(unless (package-installed-p 'gptel-quick)
  (package-vc-install "https://github.com/karthink/gptel-quick"))
(use-package gptel-quick
  :after (gptel)
  :config
  (defun gptel-quick--callback-around (org-fun &rest args)
    (let ((response (car args)))
      (unless (and (consp response) (eq (car response) 'reasoning))
        (apply org-fun args))))
  (advice-add 'gptel-quick--callback-posframe :around 'gptel-quick--callback-around)
  (with-eval-after-load 'evil
    (evil-leader/set-key
      "aih" 'gptel-quick
      ))
  )


(provide '47-llm)
;;; 47-llm.el ends here
