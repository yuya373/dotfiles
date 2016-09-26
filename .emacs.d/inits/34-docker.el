;;; 34-docker.el ---                                 -*- lexical-binding: t; -*-

;; Copyright (C) 2016  南優也

;; Author: 南優也 <yuyaminami@minamiyuuya-no-MacBook.local>
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
(el-get-bundle dockerfile-mode)

;; You can specify the image name in the file itself by adding a line like this at the top of your Dockerfile.
;; ## -*- docker-image-name: "your-image-name-here" -*-
(use-package dockerfile-mode
  :mode (("Dockerfile\\'" . dockerfile-mode)))



(provide '34-docker)
;;; 34-docker.el ends here
