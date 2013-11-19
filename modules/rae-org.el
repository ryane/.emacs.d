;; alot of this is borrowed from http://doc.norang.ca/org-mode.html
(require 'rae-org-gtd)

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
                    org-habit
                    org-drill
                    org-timer
                    org-checklist))

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

;; a warning of 14d is too much for me
(setq org-deadline-warning-days 7)

;; add a timestamp when completing a todo
(setq org-log-done 'time)
;; log into drawers
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)

;; clock settings

;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;; Show lot of clocking history
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes
;; clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs,
;; load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)
;; idle time is 10 minutes
(setq org-clock-idle-time 10)
;; display the clock in the mode line and frame title
(setq org-clock-clocked-in-display 'both)

;; use the norang clocking system
(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

;; agenda setup
(setq org-agenda-file-regexp "\\`[^.].*\\.\\(org\\.txt\\|org\\)\\'")
(setq org-agenda-files (list "~/Dropbox/Documents/Organizer"))
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-window-setup 'current-window)

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
(setq org-agenda-diary-file "~/Dropbox/Documents/Organizer/diary.org.txt")
(setq org-capture-templates
      (quote (("t" "todo" entry
               (file 'org-default-notes-file)
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)

              ("r" "respond" entry
               (file 'org-default-notes-file)
               "* NEXT Respond to email\nSCHEDULED: %t\n%U\n%a\n"
               :clock-in t :clock-resume t :immediate-finish t)

              ("n" "note" entry
               (file 'org-default-notes-file)
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)

              ("j" "Journal" entry
               (file+datetree "~/Dropbox/Documents/Organizer/diary.org.txt")
               "* %?\n%U\n%a\n" :clock-in t :clock-resume t)

              ("w" "org-protocol" entry
               (file 'org-default-notes-file)
               "* TODO Review %c\n%U\n" :immediate-finish t)

              ("m" "Meeting" entry
               (file 'org-default-notes-file)
               "* MEET with %? :MEETING:\n%U" :clock-in t :clock-resume t)

              ("p" "Phone call" entry
               (file 'org-default-notes-file)
               "* CALL %? :CALL:\n%U" :clock-in t :clock-resume t)

              ("h" "Habit" entry
               (file 'org-default-notes-file)
               "* NEXT %?\n%U\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;;;; Tag settings
;; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
                            ("@errand" . ?e)
                            ("@office" . ?o)
                            ("@home" . ?h)
                            ("@computer" . ?c)
                            ("@anywhere" . ?a)
                            (:endgroup)
                            ("WAIT" . ?W)
                            ("HOLD" . ?H)
                            ("PERSONAL" . ?p)
                            ("WORK" . ?w)
                            ("ORG" . ?O)
                            ("NOTE" . ?n)
                            ("QUIT" . ?q)
                            ("FLAGGED" . ??)
                            (:startgroup)
                            ("MAMAJAMAS" . nil)
                            ("BRITESPOKES" . nil)
                            ("KUONI" . nil)
                            (:endgroup)
                            ("READING" . nil)
                            (:startgroup)
                            ("TOREAD" . nil)
                            ("READ" . nil)
                            (:endgroup)
                            ("FOOD" . nil)
                            (:startgroup)
                            ("BREAKFAST" . nil)
                            ("LUNCH" . nil)
                            ("DINNER" . nil)
                            ("SNACK" . nil)
                            (:endgroup)
                            )))

;; Allow setting single tags without the menu
;; (setq org-fast-tag-selection-single-key (quote expert))

;; For tag searches ignore tasks with scheduled and deadline dates
;; (setq org-agenda-tags-todo-honor-ignore-options t)

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

;;;; effort estimation
;; Set default column view headings: Task Effort Clock_Summary
; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties
      (quote (
              ("Effort_ALL" . "0:15 0:25 0:30 0:45 1:00 2:00 3:00 4:00 0:00")
              ("STYLE_ALL" . "habit"))))
(setq org-columns-default-format
      "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

;;;; Custom Agenda

;; Agenda log mode items to display (closed and state changes by default)
(setq org-agenda-log-mode-items (quote (closed state)))

;; dim blocked tasks
(setq org-agenda-dim-blocked-tasks t)

;; don't compact the block agenda view
(setq org-agenda-compact-blocks nil)

;; just show me today by default
(setq org-agenda-span 'day)

;; Keep tasks with dates on the global todo lists
(setq org-agenda-todo-ignore-with-date nil)

;; Keep tasks with deadlines on the global todo lists
(setq org-agenda-todo-ignore-deadlines nil)

;; Keep tasks with scheduled dates on the global todo lists
(setq org-agenda-todo-ignore-scheduled nil)

;; Keep tasks with timestamps on the global todo lists
(setq org-agenda-todo-ignore-timestamp nil)

;; Remove completed deadline tasks from the agenda view
(setq org-agenda-skip-deadline-if-done t)

;; Remove completed scheduled tasks from the agenda view
(setq org-agenda-skip-scheduled-if-done t)

;; Remove completed items from search results
(setq org-agenda-skip-timestamp-if-done t)

;; diary settings
(setq org-agenda-include-diary nil)
(setq org-agenda-insert-diary-extract-time t)

;; Include agenda archive files when searching for things
(setq org-agenda-text-search-extra-files (quote (agenda-archives)))

;; Show all future entries for repeating tasks
(setq org-agenda-repeating-timestamp-show-all t)

;; Show all agenda dates - even if they are empty
(setq org-agenda-show-all-dates t)

;; Use sticky agenda's so they persist
(setq org-agenda-sticky t)
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (define-key org-agenda-mode-map "q" 'bury-buffer))
          'append)

;; Sorting order for tasks on the agenda
(setq org-agenda-sorting-strategy
      (quote ((agenda habit-down time-up user-defined-up priority-down effort-up category-keep)
              (todo category-up priority-down effort-up)
              (tags category-up priority-down effort-up)
              (search category-up))))

;; Start the weekly agenda on Monday
(setq org-agenda-start-on-weekday 1)

;; Enable display of the time grid so we can see the marker for the current time
;; (setq org-agenda-time-grid (quote ((daily today remove-match)
;;                                    #("----------------" 0 16 (org-heading t))
;;                                    (0900 1100 1300 1500 1700))))

;; Display tags farther right
;; (setq org-agenda-tags-column -102)

;; disable default stuck tasks view
(setq org-stuck-projects (quote ("" nil nil "")))

;; customize the clock report in the agenda
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 2 :fileskip0 t :stepskip0 t)))

;;;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
               ((org-agenda-overriding-header "Notes")
                (org-tags-match-list-sublevels t)))
              ("h" "Habits" tags-todo "STYLE=\"habit\""
               ((org-agenda-overriding-header "Habits")
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              (" " "Agenda"
               ((agenda "" nil)
                (tags "REFILE"
                      ((org-agenda-overriding-header "Tasks to Refile")
                       (org-tags-match-list-sublevels nil)))
                (tags-todo "-QUIT/!"
                           ((org-agenda-overriding-header "Stuck Projects")
                            (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                            (org-agenda-sorting-strategy
                             '(priority-down category-keep))))
                (tags-todo "-HOLD-QUIT/!"
                           ((org-agenda-overriding-header "Projects")
                            (org-agenda-skip-function 'bh/skip-non-projects)
                            (org-agenda-sorting-strategy
                             '(priority-down category-keep))))
                (tags-todo "-QUIT/!NEXT"
                           ((org-agenda-overriding-header "Project Next Tasks")
                            (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                            (org-tags-match-list-sublevels t)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(priority-down todo-state-down effort-up category-keep))))
                (tags-todo "-REFILE-QUIT-WAIT/!"
                           ((org-agenda-overriding-header (if (marker-buffer org-agenda-restrict-begin) "Project Subtasks" "Standalone Tasks"))
                            (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
                            (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                            (org-agenda-sorting-strategy
                             '(category-keep))))
                (tags-todo "-QUIT+WAIT/!"
                           ((org-agenda-overriding-header "Waiting and Postponed Tasks")
                            (org-agenda-skip-function 'bh/skip-stuck-projects)
                            (org-tags-match-list-sublevels nil)
                            (org-agenda-todo-ignore-scheduled 'future)
                            (org-agenda-todo-ignore-deadlines 'future)))
                (tags "-REFILE/"
                      ((org-agenda-overriding-header "Tasks to Archive")
                       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                       (org-tags-match-list-sublevels nil))))
               nil)
              ("r" "Tasks to Refile" tags "REFILE"
               ((org-agenda-overriding-header "Tasks to Refile")
                (org-tags-match-list-sublevels nil)))
              ("#" "Stuck Projects" tags-todo "-QUIT/!"
               ((org-agenda-overriding-header "Stuck Projects")
                (org-agenda-skip-function 'bh/skip-non-stuck-projects)))
              ("n" "Next Tasks" tags-todo "-WAIT-QUIT/!NEXT"
               ((org-agenda-overriding-header "Next Tasks")
                (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                (org-tags-match-list-sublevels t)
                (org-agenda-sorting-strategy
                 '(todo-state-down effort-up category-keep))))
              ("R" "Tasks" tags-todo "-REFILE-QUIT/!-HOLD-WAIT"
               ((org-agenda-overriding-header "Tasks")
                (org-agenda-skip-function 'bh/skip-project-tasks-maybe)
                (org-agenda-sorting-strategy
                 '(category-keep))))
              ("p" "Projects" tags-todo "-HOLD-QUIT/!"
               ((org-agenda-overriding-header "Projects")
                (org-agenda-skip-function 'bh/skip-non-projects)
                (org-agenda-sorting-strategy
                 '(category-keep))))
              ("w" "Waiting Tasks" tags-todo "-QUIT+WAIT/!"
               ((org-agenda-overriding-header "Waiting and Postponed tasks"))
               (org-tags-match-list-sublevels nil))
              ("A" "Tasks to Archive" tags "-REFILE/"
               ((org-agenda-overriding-header "Tasks to Archive")
                (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                (org-tags-match-list-sublevels nil))))))

;;;; drilling
(setq org-drill-scope 'agenda)

;;;; exporting
(setq org-export-backends '(ascii html icalendar latex md))

;;;; Archive settings
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

;;;; Reminders

;; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt 'append)

;; This is at the end of my .emacs - so appointments are set up when
;; Emacs starts
(bh/org-agenda-to-appt)

;; Activate appointments so we get notifications
(appt-activate t)

;; If we leave Emacs running overnight - reset the appointments one
;; minute after midnight
(run-at-time "24:01" nil 'bh/org-agenda-to-appt)

;; integrate with osx notification center
;; http://thread.gmane.org/gmane.emacs.orgmode/5664/focus=5806
(when (eq system-type 'darwin)
  (defun rae/appt-disp-window (min-to-app new-time msg)
    (or (listp min-to-app)
        (setq msg (list msg)))
    (save-window-excursion
      (dotimes (i (length msg))
        (shell-command
         (concat
          "/usr/bin/automator -D Title=\"Appointment Reminder\" -D Message=\""
          (nth i msg)
          "\" "
          "~/Scripts/DisplayNotification.workflow"
          ) nil nil))))

  (defun rae/appt-delete-window ()
    (if appt-audible
        (beep 1)))

  (setq appt-disp-window-function (function rae/appt-disp-window)))
  (setq appt-delete-window-function (function rae/appt-delete-window))

;;;; focusing on current work
(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (org-defkey org-agenda-mode-map "W" 'bh/widen))
          'append)
(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (org-defkey org-agenda-mode-map "F"
                         'bh/restrict-to-file-or-follow))
          'append)
(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (org-defkey org-agenda-mode-map "N" 'bh/narrow-to-subtree))
          'append)
(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (org-defkey org-agenda-mode-map "U" 'bh/narrow-up-one-level))
          'append)
(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (org-defkey org-agenda-mode-map "P" 'bh/narrow-to-project))
          'append)
(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (org-defkey org-agenda-mode-map "V" 'bh/view-next-project))
          'append)
(add-hook 'org-agenda-mode-hook
          '(lambda ()
             (org-defkey org-agenda-mode-map "\C-c\C-x<"
                         'bh/set-agenda-restriction-lock))
          'append)

(setq org-hide-leading-stars nil)

(setq org-startup-indented t)

(setq org-cycle-separator-lines 0)

(setq org-blank-before-new-entry (quote ((heading)
                                         (plain-list-item . auto))))

(setq org-insert-heading-respect-content nil)

(setq org-reverse-note-order nil)

(setq org-show-following-heading t)
(setq org-show-hierarchy-above t)
(setq org-show-siblings (quote ((default))))

(setq org-special-ctrl-a/e t)
(setq org-special-ctrl-k t)
(setq org-yank-adjusted-subtrees t)

; position the habit graph on the agenda to the right of the default
(setq org-habit-graph-column 50)

(run-at-time "06:00" 86400 '(lambda () (setq org-habit-show-habits t)))

;;;; pomodoro setup
(require 'org-pomodoro)

(setq org-pomodoro-format "~%s")
(setq org-pomodoro-clock-out-when-finished nil)
(defun rae/org-pomodoro-start-maybe ()
  (if (equal org-pomodoro-state :none)
      (org-pomodoro)))

;; capture a note when the pomodoro is finished
(add-hook 'org-pomodoro-finished-hook '(lambda ()
                                         (org-capture nil "j")))

;; restart the pomodoro when breaks are finished or you clock in a task
(add-hook 'org-clock-in-hook 'rae/org-pomodoro-start-maybe)
(add-hook 'org-pomodoro-short-break-finished-hook 'rae/org-pomodoro-start-maybe)
(add-hook 'org-pomodoro-long-break-finished-hook 'rae/org-pomodoro-start-maybe)
