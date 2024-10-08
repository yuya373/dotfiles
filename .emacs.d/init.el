;;; init.el --- init.el
;;; Commentary:
;;; Code:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq default-directory "~/")
(setq command-line-default-directory "~/")
(setq gc-cons-threshold (* (* 1 128) 1024 1024)) ;; 100mb
(setq gc-cons-percentage nil)
(setq garbage-collection-messages nil)
(setq read-process-output-max (* 1 (* 1024 1024))) ;; 1mb

(defvar before-gc-elapsed nil)
(defvar before-pure-bytes-used nil)
(defun notify-gc-finished ()
  (when (and before-gc-elapsed
             before-pure-bytes-used)
    (let ((current-gc-elapsed (- gc-elapsed before-gc-elapsed))
          (collected-pure-bytes (- before-pure-bytes-used pure-bytes-used)))
      (message "Garbage collection finished. ELAPSED: %s sec, COLLECTED: %s bytes"
               current-gc-elapsed
               collected-pure-bytes)))
  (setq before-gc-elapsed gc-elapsed)
  (setq before-pure-bytes-used pure-bytes-used)
  )
;; (add-hook 'post-gc-hook #'notify-gc-finished)

(setq native-comp-async-report-warnings-errors 'silent)


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

(el-get-bundle use-package)
(require 'use-package)
(use-package diminish :ensure t)
;; for debug
;; (setq el-get-verbose t)
;; (setq use-package-verbose t)

;; initchart
(el-get-bundle yuttie/initchart)
(use-package initchart
  :ensure t
  :commands (initchart-record-execution-time-of))
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

(defun update-packages ()
  (interactive)
  (let ((packages (collect-packages)))
    (message "Updating Packages: %s" packages)
    (dolist (package packages)
      (ignore-errors (el-get-update package)))))

(defun collect-packages ()
  (interactive)
  (let ((packages))
    (with-current-buffer (current-buffer)
      (let ((regex "\(el-get-bundle \\(.*\\)\)"))
        (goto-char (point-min))
        (while (re-search-forward regex nil t)
          (let ((name (split-string (match-string 1) "/")))
            (if (< 1 (length name))
                (push (cadr name) packages)
              (push (car name) packages))))))
    (cl-remove-duplicates packages :test #'string=)))

(defun el-get-update-all (&optional no-prompt)
  "Performs update of all installed packages."
  (interactive)
  (when (or no-prompt
            (yes-or-no-p
             "Doo you really want to update all installed packages? "))
    (let ((el-get-elpa-do-refresh 'once)
          errors)
      (mapc #'(lambda (p) (condition-case e
                             (el-get-update p)
                           (error (push e errors))))
            (el-get-list-package-names-with-status "installed"))
      (message "Package Updated.")
      (message "Errors: %s" errors))))

;; init-loader
(el-get-bundle init-loader)
(use-package init-loader
  :ensure t
  :commands (init-loader-load)
  :init
  (setq init-loader-show-log-after-init t)
  (setq init-loader-byte-compile nil))
(init-loader-load (expand-file-name "~/.emacs.d/platform-inits"))
(init-loader-load)

;; [[Home] Copy And Paste](https://www.emacswiki.org/emacs/CopyAndPaste)
;; credit: yorickvP on Github
(if (string-match-p "--with-pgtk" system-configuration-options)
    (progn
      (setq wl-copy-process nil)
      (defun wl-copy (text)
        (setq wl-copy-process (make-process :name "wl-copy"
                                            :buffer nil
                                            :command '("wl-copy" "-f" "-n")
                                            :connection-type 'pipe))
        (process-send-string wl-copy-process text)
        (process-send-eof wl-copy-process))
      (defun wl-paste ()
        (if (and wl-copy-process (process-live-p wl-copy-process))
            nil ; should return nil if we're the current paste owner
          (shell-command-to-string "wl-paste -n | tr -d \r")))
      (setq interprogram-cut-function 'wl-copy)
      (setq interprogram-paste-function 'wl-paste))
  (setq x-select-enable-clipboard t)
  (setq x-select-enable-primary t))

;; Font
;; [エディタで等幅日本語フォントを最適に表示させるには、フォントサイズを2か3か5の倍数にするといいよ！ - Qiita](https://qiita.com/suin/items/559d02ea32bd4a6ef08b)
;; [Emacs のフォント設定について - Qiita](https://qiita.com/melito/items/238bdf72237290bc6e42)
(let* ((size (if (file-exists-p "/mnt/c/Windows/System32/cmd.exe") ;; WSL
                 20
               14))
       (height (* 10 size))
       (spec (list :family "HackGen Console"
                   :height height)))

  (apply #'set-face-attribute 'default nil spec)
  (apply #'set-face-attribute 'variable-pitch nil spec))

;; http://xahlee.info/emacs/emacs/emacs_set_font_emoji.html
(progn
  ;; set font for emoji
  ;; if before emacs 28, this should come after setting symbols, because emacs 28 now has 'emoji . before, emoji is part of 'symbol
  (set-fontset-font
   t
   (if (version< emacs-version "28.1")
       '(#x1f300 . #x1fad0)
     'emoji
     )
   (cond
    ((member "Apple Color Emoji" (font-family-list)) "Apple Color Emoji")
    ((member "Noto Color Emoji" (font-family-list)) "Noto Color Emoji")
    ((member "Noto Emoji" (font-family-list)) "Noto Emoji")
    ((member "Segoe UI Emoji" (font-family-list)) "Segoe UI Emoji")
    ((member "Symbola" (font-family-list)) "Symbola"))))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(perspeen-tab--header-line-active ((t (:inherit mode-line :background "#eee8d5" :foreground "#657b83" :weight bold))))
 '(perspeen-tab--powerline-inactive1 ((t (:inherit mode-line)))))
(put 'list-timers 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rustic virtualenvwrapper alert tree-sitter-langs omnisharp ddskk toml-mode elpy sqlformat sql-transform sql-complete sbt-mode solarized-theme solarized rufo slim-mode haml-mode yaml-mode rspec-mode enh-ruby-mode bundler rbenv ruby-block ruby-end projectile-rails gist magit git-messenger git-link git-gutter-fringe+ company-terraform company-restclient editorconfig company-ispell company-emoji org-clock org-agenda flycheck-package flycheck-inline flycheck-aspell flycheck pkg-info lsp-metals dap-mode lsp-treemacs lsp-ui lsp-mode treesit-auto oauth2 lv coverlay)))
