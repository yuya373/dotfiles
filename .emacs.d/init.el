;;; init.el --- init.el
;;; Commentary:
;;; Code:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.
;; See `package-archive-priorities` and `package-pinned-packages`.
;; Most users will not need or want to do this.
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

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

(require 'use-package)
(use-package diminish :ensure t)
;; for debug
;; (setq use-package-verbose t)

;; initchart
(unless (package-installed-p 'initchart)
  (package-vc-install "https://github.com/yuttie/initchart"))
(use-package initchart
  :commands (initchart-record-execution-time-of))
(initchart-record-execution-time-of load file)
(initchart-record-execution-time-of require feature)

;; init-loader
(unless (package-installed-p 'init-loader)
  (package-vc-install "https://github.com/emacs-jp/init-loader"))
(use-package init-loader
  :commands (init-loader-load)
  :init
  (setq init-loader-show-log-after-init t)
  (setq init-loader-byte-compile nil))
(init-loader-load (expand-file-name "~/.emacs.d/platform-inits"))
(init-loader-load)
;; (load (expand-file-name "~/.emacs.d/inits/00-config.el"))
;; (load (expand-file-name "~/.emacs.d/inits/01-evil.el"))
;; (load (expand-file-name "~/.emacs.d/inits/02-prog-mode.el"))
;; (load (expand-file-name "~/.emacs.d/inits/03-util.el"))
;; (load (expand-file-name "~/.emacs.d/inits/04-helm.el"))


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
 )
(put 'list-timers 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(command-log-mode elpy company-terraform terraform-mode tree-sitter tree-sitter-langs omnisharp ddskk rustic logview sqlformat rjsx-mode flycheck-package pkg-info yasnippet-snippets yaml-mode xterm-color which-key wgrep-ag web-mode volatile-highlights virtualenvwrapper vertico undo-tree tsc toml-mode term-run string-inflection sr-speedbar sql-indent spaceline solarized-theme slim-mode shackle scss-mode sbt-mode rufo ruby-end rspec-mode reformatter rbenv rainbow-delimiters quickrun python-mode projectile-rails perspeen package-lint orderless open-junk-file nlinum nginx-mode marginalia magit lua-mode lsp-ui lsp-metals log4j-mode json-mode js2-mode initchart init-loader imenu-anywhere highlight-indent-guides hcl-mode haml-mode google-translate golden-ratio go-mode git-messenger git-link gist font-lock-studio flycheck-inline flycheck-aspell extmap expand-region exec-path-from-shell evil-visualstar evil-surround evil-numbers evil-nerd-commenter evil-matchit evil-leader evil-indent-textobject evil-exchange evil-collection evil-args evil-anzu esup eshell-prompt-extras es-mode epl enh-ruby-mode emojify embark-consult electric-operator editorconfig easy-hugo dockerfile-mode direnv dired-k diminish csv-mode csharp-mode consult-projectile consult-lsp consult-flycheck consult-dir company-statistics company-restclient company-quickhelp company-emoji coffee-mode codic cdb bundler avy-migemo auto-save-buffers-enhanced all-the-icons-completion ag adoc-mode))
 '(package-vc-selected-packages
   '((font-lock-studio :vc-backend Git :url "https://github.com/Lindydancer/font-lock-studio")
     (init-loader :vc-backend Git :url "https://github.com/emacs-jp/init-loader")
     (initchart :vc-backend Git :url "https://github.com/yuttie/initchart"))))
