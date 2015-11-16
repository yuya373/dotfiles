;;; 24-toy.el ---                                    -*- lexical-binding: t; -*-

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

(el-get-bundle hackernews)
(use-package hackernews
  :commands (hackernews))

(el-get-bundle twittering-mode)
(use-package twittering-mode
  :commands (twit)
  :init
  (add-hook 'twittering-mode-hook #'(lambda () (twittering-icon-mode 1)))
  (setq twittering-use-master-password nil
        twittering-timer-interval 300)
  :config
  (evil-set-initial-state 'twittering-mode 'normal)
  (evil-define-key 'normal twittering-mode-map
    "q" 'twittering-kill-buffer
    ",T" 'twittering-visit-timeline
    ",tf" 'twittering-friends-timeline
    ",tr" 'twittering-replies-timeline
    ",tu" 'twittering-user-timeline
    ",td" 'twittering-direct-messages-timeline
    ",r" 'twittering-current-timeline
    ",su" 'twittering-view-user-page
    ",sr" 'twittering-toggle-show-replied-statuses
    ",st" 'twittering-other-user-timeline
    ",o" 'twittering-enter
    ",mr" 'twittering-retweet
    ",mn" 'twittering-update-status-interactive
    ",md" 'twittering-direct-message
    ",ta" 'twittering-toggle-activate-buffer
    ",ti" 'twittering-icon-mode
    ",ts" 'twittering-scroll-mode
    ",l" 'twittering-other-user-list-interactive))



(provide '24-toy)
;;; 24-toy.el ends here






