(unless (eq window-system 'w32) ;; this should probably be system-type
  (require 'mu4e)
  (require 'org-mu4e)
  (require 'mu4e-contrib)

  ;; default
  (setq mu4e-maildir "~/Mail/Gmail")

  ;; this might need to be tweaked per os
  (setq mu4e-mu-binary "/usr/local/bin/mu")

  (setq mu4e-drafts-folder "/Drafts")
  (setq mu4e-sent-folder   "/Sent")
  (setq mu4e-trash-folder  "/Trash")
  (setq mu4e-refile-folder  "/Archive")

  ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
  (setq mu4e-sent-messages-behavior 'delete)

  ;; setup some handy shortcuts
  ;; you can quickly switch to your Inbox -- press ``ji''
  ;; then, when you want archive some messages, move them to
  ;; the 'All Mail' folder by pressing ``ma''.

  (setq mu4e-maildir-shortcuts
        '( ("/INBOX"   . ?i)
           ("/Archive" . ?a)
           ("/Sent"    . ?s)
           ("/Flagged" . ?f)
           ("/Trash"   . ?t)))

  (setq mu4e-bookmarks
        '(
          ("(flag:unread AND NOT flag:trashed AND NOT maildir:\"/Spam\") OR maildir:\"/Inbox\""
           "Daily Review" ?d)
          ("flag:unread AND NOT flag:trashed AND NOT list:* AND NOT maildir:\"/Spam\""
           "Unread messages, no lists" ?U)
          ("flag:unread AND NOT flag:trashed AND NOT maildir:\"/Spam\""
           "All unread messages" ?u)
          ("flag:unread AND list:emacs-orgmode.gnu.org"
           "Unread org-mode list" ?o)
          ("flag:unread AND list:30x500-alumni.googlegroups.com"
           "Unread 30x500 list" ?3)
          ("flag:unread AND list:newworkcity.googlegroups.com"
           "Unread NWC list" ?n)
          ("flag:unread AND list:clojure.googlegroups.com"
           "Unread Clojure list" ?c)
          ("flag:unread AND list:discourse.forum.rubyrogues-parley.parley.rubyrogues.com"
           "Unread RubyRogues Parley list" ?r)
          ("from:jira@mamajamas.atlassian.net"
           "Mamajamas JIRA Issues" ?j)
          ("flag:unread AND list:* AND NOT maildir:\"/Spam\""
           "Unread lists" ?l)
          ("date:today..now"                  "Today's messages"     ?t)
          ("date:7d..now"                     "Last 7 days"          ?w)
          ("mime:image/*"                     "Messages with images" ?p)))

  ;; allow for updating mail using 'U' in the main view:
  (setq mu4e-get-mail-command "offlineimap -f INBOX")
  (setq mu4e-update-interval 1200)
  (add-hook 'mu4e-index-updated-hook
            (defun mu4e-index-updated-notifcation ()
              (message "New mail arrived.")))

  ;; something about ourselves
  (setq
   user-mail-address "ryanesc@gmail.com"
   user-full-name  "Ryan Eschinger"
   message-signature
   (concat
    "Ryan Eschinger\n"
    "ryanesc@gmail.com\n"))

  ;; sending mail -- replace USERNAME with your gmail username
  ;; also, make sure the gnutls command line utils are installed
  ;; package 'gnutls-bin' in Debian/Ubuntu
  ;; brew install gnutls in Mac OSX

  ;; can't verify the certificates in osx. no idea about other
  ;; platforms at this point
  ;; workaround: use curl-ca-bundle
  ;; pre-req: brew install curl-ca-bundle
  (if (eq system-type 'darwin)
      (setq ssl-program-name "gnutls-cli" ssl-program-arguments
            '("--port" service
              ;; "--insecure"
              "--x509cafile"
              "/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt" host)))

  (setq send-mail-function 'smtpmail-send-it)
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq smtpmail-smtp-server "smtp.gmail.com")
  (setq smtpmail-smtp-service 587)
  (setq starttls-use-gnutls t)

  ;; don't keep message buffers around
  (setq message-kill-buffer-on-exit t)

  ;; save attachments to Downloads
  (setq mu4e-attachment-dir  "~/Downloads")

  ;; fancy chars, images, and other tweaks
  (setf mu4e-use-fancy-chars nil)
  (setf mu4e-view-show-images t)
  (setf mu4e-headers-skip-duplicates t)
  ;; (setf mu4e-headers-include-related t) ;; i don't like this on by default

  ;; show message id in headers
  (setq mu4e-view-fields '(:from :to :cc :subject :flags
                                 :date :maildir :mailing-list
                                 :tags :attachments :signature
                                 :message-id))

  ;; need this to convert some e-mails properly
  ;; (setq mu4e-html2text-command "html2text -utf8 -width 72")
  (setq mu4e-html2text-command "w3m -dump -cols 80 -T text/html")

  ;; use imagemagick, if available
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  ;;; message view action
  ;;; http://www.brool.com/index.php/using-mu4e
  (defun mu4e-msgv-action-view-in-browser (msg)
    "View the body of the message in a web browser."
    (interactive)
    (let ((html (mu4e-msg-field (mu4e-message-at-point t) :body-html))
          (tmpfile (format "%s/%d.html" temporary-file-directory (random))))
      (unless html (error "No html part for this message"))
      (with-temp-file tmpfile
        (insert
         "<html>"
         "<head><meta http-equiv=\"content-type\""
         "content=\"text/html;charset=UTF-8\">"
         html))
      (browse-url (concat "file://" tmpfile))))

  ;; there may be a built-in way to do this but I can't find it
  ;; ability to switch to the plain text version of a message
  (defconst rae-mu4e-view-plain-text-buffer-name " *mu4e-plain-text-view*"
    "*internal* Name for plain text message view buffer")
  (defun rae-mu4e-view-plain-text-message (msg)
    "Display the plain text contents of message at point in a new buffer."
    (interactive)
    (let ((plain (mu4e-msg-field (mu4e-message-at-point t) :body-txt))
          (buf (get-buffer-create rae-mu4e-view-plain-text-buffer-name)))
      (unless plain (error "No plain text part for this message"))
      (with-current-buffer buf
        (let ((inhibit-read-only t))
          (erase-buffer)
          (insert plain)
          (view-mode)
          (goto-char (point-min))))
      (switch-to-buffer buf)))

  (setq mu4e-view-actions
        '(
          ("capture message"     . mu4e-action-capture-message)
          ("tview as plain text" . rae-mu4e-view-plain-text-message)
          ("bview in browser"    . mu4e-msgv-action-view-in-browser)
          ("pview as pdf"        . mu4e-action-view-as-pdf)))

  (defun rae-run-mu4e ()
    (interactive)
    (make-frame-command)
    (mu4e))

  (defun mu4e-headers-mark-all-delete ()
    "Put a D \(delete) mark on all visible messages."
    (interactive)
    (mu4e-headers-mark-for-each-if
     (cons 'delete nil)
     (lambda (msg param) t)))

  (defun mu4e-headers-delete-all ()
    "Delete all visible messages."
    (interactive)
    (mu4e-headers-mark-all-delete)
    (mu4e-mark-execute-all t))
)
