;;; 40-cpp.el ---                                    -*- lexical-binding: t; -*-

;; Copyright (C) 2017

;; Author:  <yuya373@yuya373>
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
;; [チュートリアル1：ウィンドウを開く](http://www.opengl-tutorial.org/jp/beginners-tutorials/tutorial-1-opening-a-window/)
;; yaourt cmake
;; yaourt g++
;; yaourt -S g++
;; yaourt libx11-dev
;; yaourt libclang
;; yaourt clang
;; yaourt llvm
;; yaourt rtags
;; yaourt glew
;; yaourt mesa
;; yaourt glfw
;; yaourt glm

;; [C++11時代のEmacs C++コーディング環境 - Qiita](http://qiita.com/alpha22jp/items/90f7f2ad4f8b1fa089f4)
(el-get-bundle cmake-mode)
(el-get-lock-unlock 'cmake-mode)
(el-get-bundle irony-mode)
(el-get-bundle irony-eldoc)
(el-get-bundle company-irony)
(el-get-bundle flycheck-irony)
(el-get-bundle cmake-ide)
(el-get-bundle clang-format)

(use-package irony-mode
  :commands (irony-mode)
  :init
  (add-hook 'c-mode-common-hook 'irony-mode)
  (setq irony-additional-clang-options '("-std=c++11")))

(use-package flycheck-irony
  :commands (flycheck-irony-setup)
  :init
  (add-hook 'flycheck-mode-hook 'flycheck-irony-setup))

(use-package company-irony
  :commands (company-irony)
  :init
  (defun add-irony-to-company-backends ()
    (add-to-list 'company-backends 'company-irony))
  (add-hook 'irony-mode-hook 'add-irony-to-company-backends))

(use-package cmake-ide)
(use-package clang-format
  :init
  ;; - Coding style, currently supports:
  ;; LLVM, Google, Chromium, Mozilla, WebKit.
  (setq clang-format-style "LLVM")
  (defun clang-format-if-need ()
    (interactive)
    (let ((modes '(c-mode)))
      (when (cl-find major-mode modes)
        (with-current-buffer (buffer-name)
          (clang-format-buffer)))))
  (evil-define-key 'normal c-mode-map ",f" 'clang-format-buffer)
  )

(provide '40-cpp)
;;; 40-cpp.el ends here
