;;; weibo-authorize.el --- authorize

;; Copyright (C) 2011 Austin

;; Author: Austin <austiny.cn@gmail.com>

;; This program is free software: you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation, either version 3 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(require 'url)

(defconst weibo-authorize-cb-url "http://127.0.0.1:42012/")
(defconst weibo-authorize-cb-server "weibo.emacs.cb")
(defconst weibo-authorize-url "https://api.weibo.com/oauth2/authorize?client_id=%s&response_type=code&redirect_uri=%s")
(defconst weibo-authorize-url2 "https://api.weibo.com/oauth2/access_token?client_id=%s&client_secret=%s&grant_type=authorization_code&redirect_uri=%s&code=%s")
(defvar weibo-consumer-key nil)
(defvar weibo-consumer-secret nil)

(defun weibo-authorize-parse-code (string)
  (with-temp-buffer
    (insert string)
    (goto-char (point-min))
    (let ((code-start (search-forward "GET /?code=" nil t))
          (code-end (search-forward " HTTP/1.1" nil t)))
      (message "start %d" code-start)
      (message "end %d" code-end)
      (if (and (numberp code-start)
               (numberp code-end))
          (buffer-substring code-start (- code-end 9))
        nil))))

(defun weibo-authorize-get-token (code)
  (let ((url (format weibo-authorize-url2 weibo-consumer-key weibo-consumer-secret weibo-authorize-cb-url code))
        (url-request-method "POST")
        (url-request-extra-headers
         `(("Content-Type" . "application/x-www-form-urlencoded"))))
    (with-current-buffer
        (url-retrieve-synchronously url)
      (let ((token (weibo-get-body)))
        (if (not (weibo-get-node-text token 'error))
            (progn
              (weibo-parse-token
               (format "%s:%s"
                       (weibo-get-node-text token 'access_token)
                       (weibo-get-node-text token 'expires_in)))
              t)
          (message "Error: %s" token)
          nil)))))

(defun weibo-authorize-cb-filter (proc string)
  (set-process-coding-system proc 'utf-8 'utf-8)

  (let ((authorize-code (weibo-authorize-parse-code string))
        (msg ""))
    (if (stringp authorize-code)
        (if (weibo-authorize-get-token authorize-code)
            (setq msg "授权成功")
          (setq msg "授权失败：获取token失败"))
      (setq msg "授权失败：获取授权码失败"))
    (process-send-string proc "HTTP/1.0 200 OK\nContent-Type: text/html\n\n")
    (process-send-string proc (format "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html\"; charset=\"utf-8\"></head><body>emacs.weibo提示您喔，%s</html>" msg))
    (process-send-eof proc))
  (weibo-authorize-stop-cb-server))

(defun weibo-authorize-start-cb-server ()
  (weibo-authorize-stop-cb-server)
  (make-network-process
   :name weibo-authorize-cb-server
   :service 42012
   :server t
   :family 'ipv4
   :filter 'weibo-authorize-cb-filter))

(defun weibo-authorize-stop-cb-server ()
  (when (process-status weibo-authorize-cb-server)
    (delete-process weibo-authorize-cb-server)))

(defun weibo-authorize-app ()
  (weibo-authorize-start-cb-server)
  (let ((auth-url (format weibo-authorize-url (url-hexify-string weibo-consumer-key) (url-hexify-string weibo-authorize-cb-url))))
    (browse-url auth-url)
    (read-string (format "请等待授权成功(如果浏览器没有自动打开，请访问 %s 以授权)，然后按回车键" auth-url))))

(provide 'weibo-authorize)
;;; weibo-authorize.el ends here

;; Local Variables:
;; indent-tabs-mode: nil
;; End:
