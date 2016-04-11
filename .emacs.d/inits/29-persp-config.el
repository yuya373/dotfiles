;;; 29-persp-config.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2016  南優也

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

(el-get-bundle Bad-ptr/persp-mode.el)
(use-package persp-mode
  :commands (persp-mode)
  :init
  (add-hook 'after-init-hook 'persp-mode)
  ;; (add-hook 'evil-mode-hook 'persp-mode)
  (setq persp-nil-name "Emacs")
  (setq persp-auto-save-opt 2)
  (setq persp-when-kill-switch-to-buffer-in-perspective nil)
  ;; (setq persp-auto-resume-time 0)
  :config
  (require 'helm)
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
  (define-key evil-normal-state-map (kbd "\C-b") 'persp-helm-mini)
  )



(provide '29-persp-config)
;;; 29-persp-config.el ends here
