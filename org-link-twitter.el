;;; org-link-twitter.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Cash Weaver
;;
;; Author: Cash Weaver <cashbweaver@gmail.com>
;; Maintainer: Cash Weaver <cashbweaver@gmail.com>
;; Created: March 13, 2022
;; Modified: March 13, 2022
;; Version: 0.0.1
;; Homepage: https://github.com/cashweaver/org-link-twitter
;; Package-Requires: ((emacs "27.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  This library provides an twitter link in org-mode.
;;
;;; Code:

(require 'ol)
(require 's)

(defcustom org-link-twitter-url-base
  "https://twitter.com"
  "The URL of Twitter."
  :group 'org-link-follow
  :type 'string
  :safe #'stringp)

(defun org-link-twitter--build-uri (path)
  "Return a uri for the provided PATH."
  (url-encode-url
   (s-format
    "${base-url}/${path}"
    'aget
    `(("base-url" . ,org-link-twitter-url-base)
      ("path" . ,path)))))

(defun org-link-twitter-open (path arg)
  "Opens an twitter type link."
  (let ((uri
         (org-link-twitter--build-uri
          path)))
    (browse-url
     uri
     arg)))

(defun org-link-twitter-export (path desc backend info)
  "Export an twitter link.

- PATH: the name.
- DESC: the description of the link, or nil.
- BACKEND: a symbol representing the backend used for export.
- INFO: a a plist containing the export parameters."
  (let ((uri
         (org-link-twitter--build-uri
          path)))
    (pcase backend
      (`md
       (format "[%s](%s)" (or desc uri) uri))
      (`html
       (format "<a href=\"%s\">%s</a>" uri (or desc uri)))
      (`latex
       (if desc (format "\\href{%s}{%s}" uri desc)
         (format "\\url{%s}" uri)))
      (`ascii
       (if (not desc) (format "<%s>" uri)
         (concat (format "[%s]" desc)
                 (and (not (plist-get info :ascii-links-to-notes))
                      (format " (<%s>)" uri)))))
      (`texinfo
       (if (not desc) (format "@uref{%s}" uri)
         (format "@uref{%s, %s}" uri desc)))
      (_ uri))))

(org-link-set-parameters
 "twitter"
 :follow #'org-link-twitter-open
 :export #'org-link-twitter-export)


(provide 'org-link-twitter)
;;; org-link-twitter.el ends here
