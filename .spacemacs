;; -*- mode: dotspacemacs -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration."
  (setq-default
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (ie. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     ;; --------------------------------------------------------
     ;; Example of useful layers you may want to use right away
     ;; Uncomment a layer name and press C-c C-c to install it
     ;; --------------------------------------------------------
     (auto-completion :variables
                      auto-completion-return-key-behavior 'complete
                      auto-completion-tab-key-behavior 'cycle
                      auto-completion-enable-help-tooltip t
                      auto-completion-enable-sort-by-usage t
                      auto-completion-enable-snippets-in-popup t)
     better-defaults
     git
     github
     version-control
     markdown
     ruby
     syntax-checking
     evil-commentary
     (evil-snipe :variables
                 evil-snipe-enable-alternate-f-and-t-behaviors t)
     erlang
     elixir
     emacs-lisp
     emoji
     ;; eyebrowse
     (shell :variables shell-default-shell 'eshell)
     slime
     lisp
     ;; w3m
     helm-dash
     codic
     )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '(company company-quickhelp company-statistics
                                            linum-relative ibuffer ibuffer-projectile
                                            fancy-battery leuven-theme holy-mode paradox)
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'
   dotspacemacs-delete-orphan-packages t
   dotspacemacs-additional-packages '()
   ))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Either `vim' or `emacs'. Evil is always enabled but if the variable
   ;; is `emacs' then the `holy-mode' is enabled at startup.
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progess in `*Messages*' buffer.
   dotspacemacs-verbose-loading t
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to a .PNG file.
   ;; If the value is nil then no banner is displayed.
   dotspacemacs-startup-banner 'official
   ;; dotspacemacs-startup-banner 'official
   ;; t if you always want to see the changelog at startup
   dotspacemacs-always-show-changelog t
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'."
   dotspacemacs-startup-lists '()
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(
                         zenburn
                         solarized-dark
                         solarized-light
                         )
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Ricty for Powerline"
                               :size 17
                               :weight normal
                               :width normal
                               :powerline-scale 1.5)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it.
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil the paste micro-state is enabled. While enabled pressing `p`
   ;; several times cycle between the kill ring content.
   dotspacemacs-enable-paste-micro-state t
   ;; Guide-key delay in seconds. The Guide-key is the popup buffer listing
   ;; the commands bound to the current keystrokes.
   dotspacemacs-guide-key-delay 0.4
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil ;; to boost the loading time.
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up.
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX."
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup t
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-active-transparency 75
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-inactive-transparency 60
   ;; If non nil unicode symbols are displayed in the mode line.
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen.
   dotspacemacs-smooth-scrolling nil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   dotspacemacs-smartparens-strict-mode nil
   ;; If non nil advises quit functions to keep server open when quitting.
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now.
   dotspacemacs-default-package-repository nil
   )
  ;; User initialization goes here
  (setq-default
   ruby-version-manager 'rbenv
   ruby-enable-ruby-on-rails-support t
   ruby-insert-encoding-magic-comment nil
   enh-ruby-add-encoding-comment-on-save nil
   dotspacemacs-auto-save-file-location 'original
   )
  (setq linum-format "%4d ")
  (global-linum-mode t)
  (keyboard-translate ?\C-h ?\C-?)
  (setq ad-redefinition-action 'accept)
  (setq auto-save-timeout 1
        auto-save-interval 1)
  (setq-default tab-width 2
                tab-always-indent t
                indent-tabs-mode nil)
  (add-to-list 'auto-mode-alist '("\\.schema$" . enh-ruby-mode))
  (add-to-list 'auto-mode-alist '("PULLREQ_MSG" . markdown-mode))
  (auto-insert-mode)
  (setq auto-insert-directory "~/dotfiles/vim/template")
  (define-auto-insert "PULLREQ_MSG" "PULLREQ_MSG")
  (setq default-directory "~/dev/")
  )

(defun dotspacemacs/config ()
  "Configuration function.
 This function is called at the very end of Spacemacs initialization after
layers configuration."
  (setq gc-cons-threshold 134217728)
  (setq powerline-default-separator 'contour)
  ;; golden-ratio
  (golden-ratio-mode t)
  (setq golden-ratio-exclude-modes (append
                                    (list "eshell-mode" "slime-repl-mode")
                                    golden-ratio-exclude-modes))
  (setq golden-ratio-auto-scale t)
  ;; magit
  (setq magit-repository-directories '("~/dev/"))
  ;; autocomplete
  (global-auto-complete-mode)
  ;; slime
  (setq inferior-lisp-program
        (executable-find "clisp"))
  (slime-setup '(slime-repl slime-fancy slime-banner slime-fuzzy slime-highlight-edits))
  ;; popwin
  (push "*slime-apropos*" popwin:special-display-config)
  (push "*slime-macroexpansion*" popwin:special-display-config)
  (push "*slime-description*" popwin:special-display-config)
  (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
  (push "*slime-xref*" popwin:special-display-config)
  (push '(sldb-mode :stick t) popwin:special-display-config)
  (push '(slime-repl-mode :noselect t :position bottom :height 0.3) popwin:special-display-config)
  (push 'slime-connection-list-mode popwin:special-display-config)
  (push '("*Codic Result*" :noselect t) popwin:special-display-config)
  (push '("*Google Translate*" :noselect t) popwin:special-display-config)
  (push '(eshell-mode :position bottom :stick t) popwin:special-display-config)
  (push '("*compilation*" :noselect t) popwin:special-display-config)
  (setq eshell-command-aliases-list
        (append (list
                 (list "emacs" "find-file $1")
                 (list "ppr" "find-file PULLREQ_MSG")
                 (list "pr" "~/dotfiles/pullreq.sh")
                 (list "b" "bundle exec $1")
                 (list "rc" "bundle exec rails c")
                 (list "rct" "bundle exec rails c test")
                 (list "ridgepole-test" "bundle exec rake db:ridgepole:apply[test]")
                 (list "ridgepole-dev" "bundle exec rake db:ridgepole:apply[development]"))
                ()))
  (add-hook 'slime-repl-mode-hook (lambda () (linum-mode -1)))
  ;; google transrate
  (setq google-translate-default-source-language "En")
  (setq google-translate-default-target-language "Ja")
  ;; eww
  (setq eww-search-prefix "http://www.google.co.jp/search?q=")
  )


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ahs-case-fold-search nil)
 '(ahs-default-range (quote ahs-range-whole-buffer))
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(magit-use-overlays nil)
 '(package-selected-packages
   (quote
    (yaml-mode smeargle ruby-tools ruby-test-mode ruby-end robe rbenv projectile-rails org-repo-todo org-pomodoro org-bullets markdown-toc magit-svn magit-gitflow magit-gh-pulls haml-mode gitignore-mode github-browse-file gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe gist flycheck-pos-tip feature-mode evil-snipe evil-org evil-commentary enh-ruby-mode elixir-mode edts company-quickhelp bundler alchemist ac-ispell company erlang eproject auto-complete flycheck git-gutter gh logito pcache magit git-rebase-mode git-commit-mode markdown-mode alert log4e gntp rake inflections f inf-ruby zenburn-theme window-numbering volatile-highlights vi-tilde-fringe use-package smooth-scrolling rfringe rainbow-delimiters powerline popup paradox page-break-lines neotree multi-term move-text monokai-theme linum-relative leuven-theme info+ indent-guide ido-vertical-mode hungry-delete hl-anything highlight-numbers highlight-indentation helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flyspell helm-descbinds helm-c-yasnippet helm-ag guide-key-tip google-translate golden-ratio fringe-helper flx-ido fill-column-indicator fancy-battery expand-region exec-path-from-shell evil-visualstar evil-tutor evil-terminal-cursor-changer evil-surround evil-search-highlight-persist evil-numbers evil-matchit evil-lisp-state evil-jumper evil-indent-textobject evil-iedit-state evil-exchange evil-escape evil-args evil-anzu eval-sexp-fu elisp-slime-nav buffer-move base16-theme auto-highlight-symbol auto-dictionary aggressive-indent adaptive-wrap ace-window ace-link ace-jump-mode)))
 '(paradox-github-token t)
 '(ring-bell-function (quote ignore) t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:foreground "#DCDCCC" :background "#3F3F3F"))))
 '(company-tooltip-common ((t (:inherit company-tooltip :weight bold :underline nil))))
 '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :weight bold :underline nil)))))
