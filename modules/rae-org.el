;; alot of this is borrowed from http://doc.norang.ca/org-mode.html

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
      (quote (("TODO" 'org-todo)
              ("NEXT" :foreground "#8abeb7" :weight bold) ;; aqua
              ("PROG" :foreground "#de935f" :weight bold) ;; orange
              ("HOLD" :foreground "#b294bb" :weight bold) ;; comment
              ("WAIT" :foreground "#b294bb" :weight bold) ;; comment
              ("DONE" 'org-done)
              ("QUIT" 'org-done))))

;; todo state triggers
(setq org-todo-state-tags-triggers
      (quote (("QUIT" ("QUIT" . t))
              ("WAIT" ("WAIT" . t))
              ("HOLD" ("WAIT" . t) ("HOLD" . t))
              (done ("WAIT") ("HOLD"))
              ("TODO" ("WAIT") ("QUIT") ("HOLD"))
              ("NEXT" ("WAIT") ("QUIT") ("HOLD"))
              ("DONE" ("WAIT") ("QUIT") ("HOLD")))))
