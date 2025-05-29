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

;; (use-package gptel
;;   :ensure t
;;   :init
;;   (setq gptel-log-level 'debug)
;;   (defun gptel-default-directive-from-auth-source ()
;;     (let ((secret (plist-get (car (auth-source-search
;;                                    :host "gptel.directive"
;;                                    :user "default"
;;                                    :require '(:secret)))
;;                              :secret)))
;;       (if (functionp secret)
;;           (funcall secret)
;;         secret)))
;;   (setq gptel-directives
;;         (list (cons 'default (gptel-default-directive-from-auth-source))))
;;   :config
;;   (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)
;;   (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
;;   (defun gptel--api-key-anthropic ()
;;     (gptel-api-key-from-auth-source "api.anthropic.com" "apiKey"))
;;   (defun gptel--api-key-gemini ()
;;     (gptel-api-key-from-auth-source "generativelanguage.googleapis.com" "apiKey"))


;;   (defvar claude-3-7-sonnet (gptel-make-anthropic "Claude-sonnet-3-7"
;;                               :stream t
;;                               :models '(claude-3-7-sonnet-20250219)
;;                               :key #'gptel--api-key-anthropic
;;                               :header (lambda () (when-let* ((key (gptel--api-key-anthropic)))
;;                                                    `(("x-api-key" . ,key)
;;                                                      ("anthropic-version" . "2023-06-01")
;;                                                      ("anthropic-beta" . "pdfs-2024-09-25")
;;                                                      ("anthropic-beta" . "output-128k-2025-02-19")
;;                                                      ("anthropic-beta" . "prompt-caching-2024-07-31"))))
;;                               :request-params '(:thinking (:type "enabled" :budget_tokens 2048) :max_tokens 4096)))
;;   (defvar calude-3-5-sonnet (gptel-make-anthropic "Claude-sonnet-3-5"
;;                               :stream t
;;                               :models '(claude-3-5-sonnet-20241022)
;;                               :key #'gptel--api-key-anthropic))

;;   (defvar gemini-2-5-pro (gptel-make-gemini "Gemini"
;;                            :stream t
;;                            :models '(gemini-2.5-pro-exp-03-25)
;;                            :key #'gptel--api-key-gemini))


;;   (setq gptel-backend gemini-2-5-pro)
;;   (setq gptel-model 'gemini-2.5-pro-exp-03-25)
;;   ;; (setq gptel-api-key #'gptel-api-key-from-auth-source)
;;   (setq gptel-use-header-line nil)
;;   (setq gptel-include-reasoning t)

;;   (gptel-make-tool
;;    :name "read_buffer"
;;    :function (lambda (buffer)
;;                (unless (buffer-live-p (get-buffer buffer))
;;                  (error "error: buffer %s is not live." buffer))
;;                (with-current-buffer  buffer
;;                  (buffer-substring-no-properties (point-min) (point-max))))
;;    :description "return the contents of an emacs buffer"
;;    :args (list '(:name "buffer"
;;                        :type string
;;                        :description "the name of the buffer whose contents are to be retrieved"))
;;    :category "emacs")
;;   (gptel-make-tool
;;    :name "list_directory"
;;    :function (lambda (path)
;;                (let ((full-path (expand-file-name path)))
;;                  (if (file-directory-p full-path)
;;                      (directory-files full-path t)
;;                    (error "error: %s is not a directory." path))))
;;    :description "return a list of files in a directory"
;;    :args (list '(:name "path"
;;                        :type string
;;                        :description "the directory whose contents are to be listed"))
;;    :category "filesystem")
;;   (gptel-make-tool
;;    :name "read_file"
;;    :function (lambda (path)
;;                (let ((full-path (expand-file-name path)))
;;                  (if (file-exists-p full-path)
;;                      (with-temp-buffer
;;                        (insert-file-contents full-path)
;;                        (buffer-string))
;;                    (error "error: %s does not exist." path))))
;;    :description "return the contents of a file"
;;    :args (list '(:name "path"
;;                        :type string
;;                        :description "the file whose contents are to be retrieved"))
;;    :category "filesystem")
;;   (gptel-make-tool
;;    :name "create_directory"
;;    :function (lambda (path)
;;                (let ((full-path (expand-file-name path)))
;;                  (make-directory full-path)
;;                  (format "Created directory %s" full-path)))
;;    :description "create a new directory"
;;    :args (list '(:name "path"
;;                        :type string
;;                        :description "the directory to be created"))
;;    :category "filesystem")
;;   (gptel-make-tool
;;    :name "create_file"
;;    :function (lambda (path filename content)
;;                (let ((full-path (expand-file-name filename path)))
;;                  (with-temp-buffer
;;                    (insert content)
;;                    (write-file full-path))
;;                  (format "Created file %s in %s" filename path)))
;;    :description "Create a new file with the specified content"
;;    :args (list '(:name "path"
;;                        :type string
;;                        :description "The directory where to create the file")
;;                '(:name "filename"
;;                        :type string
;;                        :description "The name of the file to create")
;;                '(:name "content"
;;                        :type string
;;                        :description "The content to write to the file"))
;;    :category "filesystem")

;;   (with-eval-after-load 'which-key
;;     (which-key-add-key-based-replacements "SPC a i" "AI")
;;     (which-key-add-key-based-replacements "SPC a i a" "Add To Context"))
;;   (with-eval-after-load 'evil
;;     (defun gptel-send-with-arg ()
;;       (interactive)
;;       (gptel-send 4))
;;     (defun gptel-open-log-buffer ()
;;       (interactive)
;;       (let ((bufname gptel--log-buffer-name))
;;         (switch-to-buffer-other-window bufname)))

;;     (evil-leader/set-key
;;       "ais" 'gptel-send-with-arg
;;       "aii" 'gptel
;;       "aiaa" 'gptel-add
;;       "aiaf" 'gptel-add-file
;;       "air" 'gptel-rewrite
;;       "ait" 'gptel-tools
;;       "aib" 'gptel-open-log-buffer
;;       ))
;;   (with-eval-after-load 'evil-collection
;;     (evil-collection-define-key 'normal 'gptel-context-buffer-mode-map
;;       (kbd "C-n") 'gptel-context-next
;;       (kbd "C-p") 'gptel-context-previous
;;       (kbd "RET") 'gptel-context-visit
;;       ",r" 'gptel-context-flag-deletion
;;       ",R" 'gptel-context-remove-all
;;       ",c" 'gptel-context-confirm
;;       ",q" 'gptel-context-quit
;;       )
;;     (evil-collection-define-key 'normal 'gptel-mode-map
;;       ",c" 'gptel-send
;;       ",r" 'gptel--regenerate
;;       ",m" 'gptel-menu
;;       ",t" 'gptel-tools
;;       ",q" 'gptel-abort))
;;   )

;; (use-package posframe
;;   :ensure t
;;   :after (gptel))
;; (unless (package-installed-p 'gptel-quick)
;;   (package-vc-install "https://github.com/karthink/gptel-quick"))
;; (use-package gptel-quick
;;   :after (gptel)
;;   :config
;;   (setq gptel-quick-timeout nil)
;;   (setq gptel-quick-word-count 24)
;;   (defun gptel-quick-directive-from-auth-source ()
;;     (let ((secret (plist-get (car (auth-source-search
;;                                    :host "gptel-quick.directive"
;;                                    :user "default"
;;                                    :require '(:secret)))
;;                              :secret)))
;;       (if (functionp secret)
;;           (funcall secret)
;;         secret)))
;;   (setq gptel-quick-system-message
;;         (lambda (count)
;;           (format (gptel-quick-directive-from-auth-source) count)))
;;   (defun gptel-quick--callback-around (org-fun &rest args)
;;     (let ((response (car args)))
;;       (unless (and (consp response) (eq (car response) 'reasoning))
;;         (apply org-fun args))))
;;   (advice-add 'gptel-quick--callback-posframe :around 'gptel-quick--callback-around)
;;   (with-eval-after-load 'evil
;;     (evil-leader/set-key
;;       "aih" 'gptel-quick
;;       ))
;;   )

;; (use-package evedel
;;   :ensure t
;;   :after (gptel)
;;   :config
;;   (defun evedel--directive-llm-system-message (_directive)
;;     (gptel-default-directive-from-auth-source))
;;   (defun evedel--process-directive-llm-response-around (org-fun &rest args)
;;     (let ((response (car args)))
;;       (unless (and (consp response) (eq (car response) 'reasoning))
;;         (apply org-fun args))))
;;   (advice-add 'evedel--process-directive-llm-response :around 'evedel--process-directive-llm-response-around)

;;   (with-eval-after-load 'which-key
;;     (which-key-add-key-based-replacements "SPC a i e" "Evedel")
;;     (which-key-add-key-based-replacements "SPC a i e r" "References")
;;     (which-key-add-key-based-replacements "SPC a i e d" "Directives")
;;     (which-key-add-key-based-replacements "SPC a i e t" "Tags")
;;     (which-key-add-key-based-replacements "SPC a i e i" "Instructions"))

;;   (with-eval-after-load 'evil
;;     (evil-leader/set-key
;;       "aiee" 'evedel-process-directives
;;       "aieE" 'evedel-preview-directive-prompt

;;       "aierc" 'evedel-create-reference
;;       "aiere" 'evedel-modify-reference-commentary
;;       "aiern" 'evedel-next-reference
;;       "aierp" 'evedel-previous-reference

;;       "aiedc" 'evedel-create-directive
;;       "aiede" 'evedel-modify-directive
;;       "aiedn" 'evedel-next-directive
;;       "aiedp" 'evedel-previous-directive

;;       "aietc" 'evedel-add-tags
;;       "aietd" 'evedel-remove-tags

;;       "aiec" 'evedel-convert-instructions

;;       "aiex" 'evedel-delete-instructions
;;       "aieX" 'evedel-delete-all-instructions

;;       "aiein" 'evedel-next-instruction
;;       "aieip" 'evedel-previous-instruction)))


;; Install directly from GitHub
;; (unless (package-installed-p 'claude-code)
;;   (package-vc-install "https://github.com/stevemolitor/claude-code.el"))

;; (use-package claude-code
;;   :init
;;   (setq claude-code-startup-delay 2)
;;   (setq eat-input-chunk-size (/ 1024 8))
;;   :config
;;   (with-eval-after-load 'which-key
;;     (which-key-add-key-based-replacements "SPC c c" "Claude"))

;;   (with-eval-after-load 'evil
;;     (evil-leader/set-key
;;       "ccc" 'claude-code
;;       "ccb" 'claude-code-switch-to-buffer
;;       "cck" 'claude-code-kill
;;       "ccs" 'claude-code-send-command
;;       "ccS" 'claude-code-send-command-with-context
;;       "ccr" 'claude-code-send-region
;;       "cc/" 'claude-code-slash-commands
;;       "ccm" 'claude-code-transient
;;       "ccy" 'claude-code-send-return
;;       "ccn" 'claude-code-send-escape
;;       ))
;;   )

(use-package vterm
  :ensure t
  :config
  (defun vterm-project-buffer-name ()
    (if (projectile-project-p)
        (format "*vterm-%s*" (projectile-project-root))))
  (defun vterm-current-project ()
    (interactive)
    (if-let* ((buf-name (vterm-project-buffer-name))
              (project-root (projectile-project-root))
              (default-directory project-root))
        (vterm buf-name)
      (vterm)))
  (defun vterm-toggle ()
    (interactive)
    (if-let* ((bufname (vterm-project-buffer-name))
              (buf (get-buffer bufname))
              (livep (buffer-live-p buf)))
        (if-let* ((win (get-buffer-window buf))
                  (livep (window-live-p win)))
            (delete-window win)
          (display-buffer buf))
      (vterm-current-project)))
  (with-eval-after-load 'evil
    (evil-leader/set-key
      "tt" 'vterm-toggle
      ))
  (define-key vterm-mode-map (kbd "C-h") 'vterm-send-backspace)
  (with-eval-after-load 'evil-collection
    (evil-collection-define-key 'insert 'vterm-mode-map
      (kbd "C-n") 'vterm-send-down
      (kbd "C-p") 'vterm-send-up
      (kbd "C-h") 'vterm-send-backspace
      ))

  ;;; vterm claude integration
  (progn
    (with-eval-after-load 'evil
      (evil-leader/set-key
        "cc" nil
        "ccc" 'vterm-claude-toggle
        "ccr" 'vterm-claude-send-region
        "ccb" 'vterm-claude-text-buffer
        ))

    (defun vterm-claude-project-buffer-name ()
      (if (projectile-project-p)
          (format "*vterm-claude-%s*" (projectile-project-root))))
    (defun vterm-claude-get-current-buffer ()
      (if-let* ((bufname (vterm-claude-project-buffer-name))
                (buf (get-buffer bufname))
                (livep (buffer-live-p buf)))
          buf))
    (defun vterm-claude-current-project ()
      (interactive)
      (if-let* ((buf-name (vterm-claude-project-buffer-name))
                (project-root (projectile-project-root))
                (default-directory project-root))
          (progn
            (vterm buf-name)
            (vterm-send-string "claude")
            (vterm-send-return))
        (error "No project found.")))
    (defun vterm-claude-toggle ()
      (interactive)
      (if-let* ((buf (vterm-claude-get-current-buffer)))
          (if-let* ((win (get-buffer-window buf))
                    (livep (window-live-p win)))
              (delete-window win)
            (display-buffer buf))
        (vterm-claude-current-project)))

    (defun chunk-string (str chunk-size)
      (if (<= chunk-size 0)
          (error "chunk-size must be greater than 0")
        (let ((len (length str))
              (result '())
              (start 0))
          (while (< start len)
            (let ((end (min (+ start chunk-size) len)))
              (push (substring str start end) result)
              (setq start end)))
          (nreverse result))))

    (defun vterm-claude-send-string (string &optional paste-p)
      (if-let ((buf (vterm-claude-get-current-buffer))
               (strings (chunk-string string 50)))
          (with-current-buffer buf
            (mapc (lambda (str)
                    (vterm-send-string str paste-p))
                  strings)
            (vterm-send-return))
        (error "No vterm-claude buffer found.")))

    (defun vterm-claude-send-region ()
      (interactive)
      (let ((text (if (use-region-p)
                      (buffer-substring-no-properties (region-beginning) (region-end))
                    (buffer-substring-no-properties (point-min) (point-max)))))
        (vterm-claude-send-string text t)))

    (defun vterm-claude-text-buffer ()
      (interactive)
      (let* ((buf-name (format "%s-text-buffer" (vterm-claude-project-buffer-name)))
             (buf (get-buffer-create buf-name)))
        (with-current-buffer buf
          (markdown-mode)
          (vterm-claude-mode))
        (display-buffer buf)))

    (define-minor-mode vterm-claude-mode
      "VTerm Claude"
      :lighter " VTerm-C"
      :keymap (let ((map (make-sparse-keymap)))
                (define-key map (kbd "C-c C-c") 'vterm-claude-send-region)
                map)
      :group 'vterm-claude
      :global t)
    )
  )

(use-package aider
  :ensure t
  :config
  (setq aider-auto-trigger-prompt t)

  (with-eval-after-load 'which-key
    (which-key-add-key-based-replacements "SPC a i" "Aider")
    (which-key-add-key-based-replacements "SPC a i a" nil))

  (with-eval-after-load 'evil
    (evil-leader/set-key
      "aic" 'aider-run-aider
      "aii" 'aider-transient-menu
      "aib" 'aider-switch-to-buffer
      "aiA" 'aider-add-files-in-current-window
      "aia" 'aider-add-current-file-or-dired-marked-files
      "aim" 'aider-add-module
      "air" 'aider-function-or-region-refactor
      "aiR" 'aider-refactor-book-method
      "aiI" 'aider-implement-todo
      "ait" 'aider-write-unit-test
      "aih" 'aider-ask-question
      "aiy" 'aider-go-ahead
      "aip" 'aider-open-prompt-file
      ))
  (with-eval-after-load 'evil-collection
    (evil-collection-define-key 'visual 'aider-prompt-mode-map
      (kbd ",c") 'aider-send-block-or-region
      (kbd ",n") 'aider-send-line-or-region
      )
    (evil-collection-define-key 'normal 'aider-prompt-mode-map
      (kbd ",c") 'aider-send-block-or-region
      (kbd ",n") 'aider-send-line-or-region
      (kbd ",b") 'aider-switch-to-buffer
      (kbd ",f") 'aider-prompt-insert-file-path
      (kbd ",i") 'aider-core-insert-prompt
      (kbd ",y") 'aider-prompt-cycle-file-command
      )
    )
  )

(use-package minuet
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'minuet-auto-suggestion-mode)
  :config

  (define-key minuet-active-mode-map (kbd "TAB") 'minuet-next-suggestion)
  (define-key minuet-active-mode-map [backtab] 'minuet-previous-suggestion)
  (define-key minuet-active-mode-map (kbd "C-<tab>") 'minuet-accept-suggestion)
  (define-key minuet-active-mode-map (kbd "C-c l") 'minuet-accept-suggestion-line)
  (define-key minuet-active-mode-map (kbd "C-c q") 'minuet-dismiss-suggestion)
  (setq minuet-provider 'gemini)

  (defun minuet-gemini-api-key-from-auth-source ()
    (let ((secret (plist-get (car (auth-source-search
                                   :host "generativelanguage.googleapis.com"
                                   :user "apiKey"
                                   :require '(:secret)))
                             :secret)))
      (if (functionp secret)
          (funcall secret)
        secret)))
  (plist-put minuet-gemini-options :api-key '(lambda () (minuet-gemini-api-key-from-auth-source)))
  (plist-put minuet-gemini-options :model "gemini-2.5-flash-preview-04-17")
  (minuet-set-optional-options
   minuet-gemini-options :generationConfig
   '(:maxOutputTokens 256
                      :topP 0.9
                      ;; When using `gemini-2.5-flash`, it is recommended to entirely
                      ;; disable thinking for faster completion retrieval.
                      :thinkingConfig (:thinkingBudget 0)))
  (minuet-set-optional-options
   minuet-gemini-options :safetySettings
   [(:category "HARM_CATEGORY_DANGEROUS_CONTENT"
               :threshold "BLOCK_NONE")
    (:category "HARM_CATEGORY_HATE_SPEECH"
               :threshold "BLOCK_NONE")
    (:category "HARM_CATEGORY_HARASSMENT"
               :threshold "BLOCK_NONE")
    (:category "HARM_CATEGORY_SEXUALLY_EXPLICIT"
               :threshold "BLOCK_NONE")])
  )

(provide '47-llm)
;;; 47-llm.el ends here
