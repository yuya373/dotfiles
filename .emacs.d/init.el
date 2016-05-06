;;; init.el --- init.el
;;; Commentary:
;;; Code:

;; self hosting el-get

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)
(setq gc-cons-threshold (* 512 1024 1024))
(setq garbage-collection-messages t)

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; use use-package for config description and lazy loading
(setq el-get-use-autoloads nil)
(setq el-get-is-lazy t)
(setq el-get-notify-type 'message)

;; el-get-lock
(el-get-bundle el-get-lock
  :type github
  :pkgname "tarao/el-get-lock"
  :name el-get-lock)
(require 'el-get-lock)
(el-get-lock)

(el-get-bundle use-package)
(el-get-bundle diminish)
(require 'diminish)
(require 'use-package)
;; for debug
;; (setq el-get-verbose t)
;; (setq use-package-verbose t)

;; initchart
(el-get-bundle yuttie/initchart)
(use-package initchart
  :commands (initchart-record-execution-time-of))
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

;; init-loader
(el-get-bundle init-loader)
(use-package init-loader
  :commands (init-loader-load)
  :init
  (setq init-loader-show-log-after-init 'error-only)
  (setq init-loader-byte-compile t))
(init-loader-load)
(add-hook 'window-setup-hook
          #'(lambda ()
              (set-frame-parameter nil
                                   'fullscreen 'maximized))
          t)

(el-get-bundle persp-mode)
(use-package persp-mode
  :no-require t
  :commands (persp-mode)
  :init
  (add-hook 'evil-mode-hook 'persp-mode)
  ;; (add-hook 'evil-mode-hook 'persp-mode)
  (setq persp-nil-name "Emacs")
  (setq persp-auto-save-opt 2)
  (setq persp-when-kill-switch-to-buffer-in-perspective nil)
  ;; (setq persp-auto-resume-time 0)
  :config
  (require 'helm)
  ;; (defvar after-switch-to-buffer-functions nil)
  ;; (defvar after-display-buffer-functions nil)
  ;; (add-hook 'after-switch-to-buffer-functions
  ;;           #'(lambda (bn) ))
  ;; (if (fboundp 'advice-add)
  ;;     ;;Modern way
  ;;     (setq py-persp-major-mode '(slack-mode slack-info-mode slack-edit))
  ;;     (progn
  ;;       (defun after-switch-to-buffer-adv (buffer-or-name &rest r)
  ;;         (when (and persp-mode
  ;;                    (not persp-temporarily-display-buffer))
  ;;           (with-current-buffer buffer-or-name
  ;;             (if (memq major-mode my-persp-major-mode)
  ;;                 (persp-add-buffer buffer-or-name)))))
  ;;       (defun after-display-buffer-adv (&rest r)
  ;;         (apply #'run-hook-with-args 'after-display-buffer-functions r))
  ;;       ;; (advice-add #'switch-to-buffer :after #'after-switch-to-buffer-adv)
  ;;       ;; (advice-add #'display-buffer   :after #'after-display-buffer-adv)
  ;;       (advice-remove #'switch-to-buffer #'after-switch-to-buffer-adv)
  ;;       (advice-remove #'display-buffer #'after-display-buffer-adv)
  ;;       ))

  (defun persp-helm-mini ()
    (interactive)
    (with-persp-buffer-list ()
                            (helm-mini)))
  (defun helm-perspectives-source ()
    (helm-build-in-buffer-source
        (concat "Current Perspective: " (safe-persp-name (get-frame-persp)))
      :data (persp-names)
      :fuzzy-match t
      :action
      '(("Switch to perspective" . persp-switch)
        ("Close perspective(s)" . (lambda (candidate)
                                    (mapcar
                                     'persp-kill-without-buffers
                                     (helm-marked-candidates))))
        ("Kill perspective(s)" . (lambda (candidate)
                                   (mapcar 'persp-kill
                                           (helm-marked-candidates)))))))

  (defun helm-perspectives ()
    "Control Panel for perspectives. Has many actions.
If match is found
f1: (default) Select perspective
f2: Close Perspective(s) <- mark with C-SPC to close more than one-window
f3: Kill Perspective(s)
If match is not found
<enter> Creates perspective
Closing doesn't kill buffers inside the perspective while killing
perspectives does."
    (interactive)
    (helm
     :buffer "*Helm Perspectives*"
     :sources
     `(,(helm-perspectives-source)
       ,(helm-build-dummy-source "Create new perspective"
          :requires-pattern t
          :action
          '(("Create new perspective" .
             (lambda (name)
               (let ((persp-reset-windows-on-nil-window-conf t))
                 (persp-switch name)
                 (switch-to-buffer "*GNU Emacs*")))))))))

  (define-key evil-normal-state-map (kbd "tt") 'helm-perspectives)
  (define-key evil-normal-state-map (kbd "tR") 'persp-rename)
  (define-key evil-normal-state-map (kbd "tn") 'persp-next)
  (define-key evil-normal-state-map (kbd "tp") 'persp-prev)
  (define-key evil-normal-state-map (kbd "tk") 'persp-kill)
  (define-key evil-normal-state-map (kbd "ti") 'persp-import-buffers)
  (define-key evil-normal-state-map (kbd "ta") 'persp-add-buffer)
  (define-key evil-normal-state-map (kbd "tr") 'persp-remove-buffer)
  (define-key evil-normal-state-map (kbd "tw") 'persp-save-state-to-file)
  (define-key evil-normal-state-map (kbd "tl") 'persp-load-state-from-file)
  (define-key evil-normal-state-map (kbd "tb") 'persp-helm-mini)
  ;; (define-key evil-normal-state-map (kbd "\C-b") 'persp-helm-mini)
  ;; (define-key evil-normal-state-map (kbd "\C-B") 'helm-mini)
  )



;; (global-evil-leader-mode)
;; (evil-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-basic-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
