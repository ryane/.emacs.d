;; alot of this is borrowed from http://doc.norang.ca/org-mode.html

;; additional modules
(setq org-modules '(org-w3m
                    org-bbdb
                    org-bibtex
                    org-docview
                    org-gnus
                    org-info
                    org-irc
                    org-mhe
                    org-rmail
                    org-drill))

(defun rae-org-mode-defaults ()
  "Default settings for org-mode"
  (visual-line-mode -1)
  (auto-fill-mode 1))
(add-hook 'org-mode-hook 'rae-org-mode-defaults)

;; i map these to fix M-<up> and M-<down> in org mode in the terminal
;; i wonder what else is broken. why can't emacs just work consistently
;; in the terminal and the gui. vim seems to do it much better
(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])

;; (add-to-list 'auto-mode-alist '("\\.org\\.txt" . org-mode))
;; org-mode is the default mode for .org, .org_archive, and .txt files
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

;; global bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; make sure a parent task can't be completed if it has active subtasks
(setq org-enforce-todo-dependencies t)

;; add a timestamp when completing a todo
(setq org-log-done 'time)

;; clock settings
(setq org-clock-into-drawer t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-idle-time 10)
(setq org-clock-clocked-in-display 'both)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; agenda setup
(setq org-agenda-file-regexp "\\`[^.].*\\.\\(org\\.txt\\|org\\)\\'")
(setq org-agenda-files (list "~/Dropbox/Documents/Organizer"))
(setq org-agenda-restore-windows-after-quit t)

;; customize some keybindings
;; remove org-agenda file management bindings
(define-key org-mode-map (kbd "C-c [") nil) ;; org-agenda-file-to-front
(define-key org-mode-map (kbd "C-c ]") nil) ;; org-remove-file

;; todo
(setq org-todo-keywords
      (quote (
              (sequence "TODO(t)" "NEXT(n)" "PROG(p)" "WAIT(w@/!)" "HOLD(h)" "|"
                        "DONE(d)" "QUIT(q@/!)" "MEET" "CALL"))))

;; pulled some colors from the tomorrow-night theme
(setq org-todo-keyword-faces
      (quote (("TODO" org-todo)
              ("NEXT" :foreground "#8abeb7" :weight bold) ;; aqua
              ("PROG" :foreground "#de935f" :weight bold) ;; orange
              ("HOLD" :foreground "#b294bb" :weight bold) ;; comment
              ("WAIT" :foreground "#b294bb" :weight bold) ;; comment
              ("DONE" org-done)
              ("QUIT" org-done))))

;; todo state triggers
(setq org-todo-state-tags-triggers
      (quote (("QUIT" ("QUIT" . t))
              ("WAIT" ("WAIT" . t))
              ("HOLD" ("WAIT" . t) ("HOLD" . t))
              (done ("WAIT") ("HOLD"))
              ("TODO" ("WAIT") ("QUIT") ("HOLD"))
              ("NEXT" ("WAIT") ("QUIT") ("HOLD"))
              ("DONE" ("WAIT") ("QUIT") ("HOLD")))))

;; org-capture
(setq org-directory "~/Dropbox/Documents/Organizer")
(setq org-default-notes-file "~/Dropbox/Documents/Organizer/inbox.org.txt")
(setq org-capture-templates
      (quote (("t" "todo" entry
               (file 'org-default-notes-file)
               "* TODO %?\n  %U\n  %a\n" :clock-in t :clock-resume t)

              ("r" "respond" entry
               (file 'org-default-notes-file)
               "* NEXT Respond to email\nSCHEDULED: %t\n  %U\n  %a\n"
               :clock-in t :clock-resume t :immediate-finish t)

              ("n" "note" entry
               (file 'org-default-notes-file)
               "* %? :NOTE:\n  %U\n  %a\n" :clock-in t :clock-resume t)

              ("j" "Journal" entry
               (file+datetree "~/Dropbox/Documents/Organizer/diary.org.txt")
               "* %?\n  %U\n" :clock-in t :clock-resume t)

              ("w" "org-protocol" entry
               (file 'org-default-notes-file)
               "* TODO Review %c\n  %U\n" :immediate-finish t)

              ("m" "Meeting" entry
               (file 'org-default-notes-file)
               "* MEET with %? :MEETING:\n  %U" :clock-in t :clock-resume t)

              ("p" "Phone call" entry
               (file 'org-default-notes-file)
               "* CALL %? :CALL:\n  %U" :clock-in t :clock-resume t)

              ("h" "Habit" entry
               (file 'org-default-notes-file)
               "* NEXT %?\n  %U\n  %a\n  SCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:\n"))))

;;;; Refile settings
;; refiling Targets include this file and any file contributing to the
;; agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

;; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)

; Use IDO
(setq org-completion-use-ido t)

; Exclude DONE state tasks from refile targets
(defun rae/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'rae/verify-refile-target)


;; Remove empty LOGBOOK drawers on clock out
(defun rae/remove-empty-drawer-on-clock-out ()
  (interactive)
  (message "removing empty drawer on clock out")
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at (point))))

(add-hook 'org-clock-out-hook 'rae/remove-empty-drawer-on-clock-out 'append)
