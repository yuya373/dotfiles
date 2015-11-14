;;; 16-elixir.el ---                                 -*- lexical-binding: t; -*-

;; Copyright (C) 2015  南優也

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

(eval-when-compile
  (require 'evil))

(el-get-bundle elixir)
(use-package elixir-mode
  :mode (("\\.ex\\'" . elixir-mode)
         ("\\.exs\\'" . elixir-mode)
         ("\\.elixir\\'" . elixir-mode)))

(el-get-bundle company-mode)
(el-get-bundle alchemist)
(use-package alchemist
  :commands (alchemist-mode)
  :init
  (add-hook 'elixir-mode-hook 'alchemist-mode)
  :config
  (use-package alchemist-compile
    :commands (alchemist-compile-this-buffer alchemist-compile-file))
  (evil-define-key 'normal alchemist-mode-map
    (kbd ",x") 'alchemist-mix
    (kbd ",mc") 'alchemist-mix-compile
    (kbd ",mr") 'alchemist-mix-run
    (kbd ",tt") 'alchemist-mix-test-at-point
    (kbd ",tb") 'alchemist-mix-test-this-buffer
    (kbd ",tr") 'alchemist-mix-test-rerun-last-test
    (kbd ",rb") 'alchemist-execute-this-buffer
    (kbd ",rf") 'alchemist-execute-file
    (kbd ",ee") 'alchemist-eval-current-line
    (kbd ",eE") 'alchemist-eval-print-current-line
    (kbd ",eb") 'alchemist-eval-buffer
    (kbd ",eB") 'alchemist-eval-print-buffer
    (kbd ",ft") 'alchemist-project-find-test
    (kbd ",fT") 'alchemist-project-toggle-file-and-tests-other-window
    (kbd ",hh") 'alchemist-help
    (kbd ",ht") 'alchemist-help-search-at-point
    (kbd ",ii") 'alchemist-iex-run
    (kbd ",ip") 'alchemist-iex-project-run
    (kbd ",ic") 'alchemist-iex-compile-this-buffer
    (kbd ",ie") 'alchemist-iex-send-current-line
    (kbd ",iE") 'alchemist-iex-send-current-line-and-go
    (kbd ",gd") 'alchemist-goto-definition-at-point
    (kbd ",cc") 'alchemist-compile-this-buffer
    (kbd ",cf") 'alchemist-compile-file)
  (evil-define-key 'visual alchemist-mode-map
    (kbd ",ee") 'alchemist-eval-region
    (kbd ",eE") 'alchemist-eval-print-region
    (kbd ",ir") 'alchemist-iex-send-region
    (kbd ",iR") 'alchemist-iex-send-region-and-go)
  (use-package company))

(el-get-bundle syohex/emacs-ac-alchemist)
(use-package ac-alchemist
  :commands (ac-alchemist-setup)
  :init
  (add-hook 'elixir-mode-hook 'ac-alchemist-setup))

(provide '16-elixir)
;;; 16-elixir.el ends here
