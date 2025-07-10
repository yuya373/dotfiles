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

(setq menu-bar-mode t)

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
               16))
       (height (* 10 size))
       (spec (list :family "HackGen Console NF"
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
 '(corfu-current ((t (:inherit corfu-default :extend t :inverse-video nil :weight bold))))
 '(orderless-match-face-0 ((t (:foreground "#2aa198")))))
(put 'list-timers 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(add-node-modules-path adoc-mode ag aider alert
                           all-the-icons-completion
                           auto-save-buffers-enhanced avy-migemo
                           bundler cape claude-code codic coffee-mode
                           command-log-mode consult-dir
                           consult-flycheck consult-lsp
                           consult-projectile copilot corfu csv-mode
                           ddskk-posframe diminish dired-k direnv
                           dockerfile-mode easy-hugo electric-operator
                           elpy embark-consult emojify enh-ruby-mode
                           es-mode eshell-prompt-extras esup evedel
                           evil-anzu evil-args evil-collection
                           evil-exchange evil-indent-textobject
                           evil-leader evil-matchit
                           evil-nerd-commenter evil-numbers
                           evil-surround evil-visualstar
                           exec-path-from-shell expand-region
                           flycheck-aspell flycheck-inline
                           flycheck-package font-lock-studio
                           frame-local gist git-link git-messenger
                           go-mode golden-ratio google-translate
                           gptel-quick graphql-mode haml-mode
                           highlight-indent-guides imenu-anywhere
                           init-loader initchart ivy-posframe
                           json-mode know-your-http-well log4j-mode
                           logview lsp-metals lsp-ui lua-mode
                           marginalia minuet nerd-icons-corfu
                           nginx-mode omnisharp open-junk-file
                           orderless perspeen pkg-info pos-tip
                           projectile-rails python-mode
                           quelpa-use-package quickrun
                           rainbow-delimiters rbenv restclient
                           rjsx-mode rspec-mode ruby-end rufo rustic
                           sbt-mode scss-mode shackle slim-mode
                           solarized-theme spaceline sql-indent
                           sqlformat sr-speedbar string-inflection
                           svg-lib term-run toml-mode
                           transient-posframe tree-sitter-langs
                           treesit-auto undo-tree vertico-posframe
                           virtualenvwrapper volatile-highlights vterm
                           web-mode websocket wgrep-ag
                           which-key-posframe yaml-mode
                           yasnippet-snippets))
 '(package-vc-selected-packages
   '((vertico-posframe :vc-backend Git :url
                       "https://github.com/tumashu/vertico-posframe")
     (claude-code :vc-backend Git :url
                  "https://github.com/stevemolitor/claude-code.el")
     (gptel-quick :vc-backend Git :url
                  "https://github.com/karthink/gptel-quick")
     (copilot :vc-backend Git :url
              "https://github.com/copilot-emacs/copilot.el")
     (font-lock-studio :vc-backend Git :url
                       "https://github.com/Lindydancer/font-lock-studio")
     (init-loader :vc-backend Git :url
                  "https://github.com/emacs-jp/init-loader")
     (initchart :vc-backend Git :url
                "https://github.com/yuttie/initchart"))))
