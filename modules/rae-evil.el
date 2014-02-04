;; (require 'evil-org)

(setq evil-want-C-u-scroll t)

;; Originally C-z but I like to suspend emacs
;; I really want to unbind it but I don't know how
;; to do it without causing problems
;; evil-goto-mark seems to take precedence anyway
(setq evil-toggle-key "C-`")

;; leader mappings
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "e" 'find-file
  "b" 'switch-to-buffer
  "," 'mode-line-other-buffer
  "f" 'ag
  "g" 'magit-status
  "a" 'rspec-toggle-spec-and-target
  "t" 'rspec-rerun
  "v" 'rspec-verify
  "V" 'rspec-verify-single
  "k" 'kill-buffer
  "SPC" 'ace-jump-mode
  "m" 'ace-jump-char-mode
  "/" 'rae-google
  "x" 'helm-etags-select
  "." 'projectile-find-file)

;; commenting
(setq evilnc-hotkey-comment-operator "gc")
(evilnc-default-hotkeys)

;; surround
(require 'surround)
(global-surround-mode 1)

;; turn on evil
(evil-mode 1)

;; evil-matchit
(require 'evil-matchit)
(require 'sgml-mode) ;; requires smgl-mode to be loaded
(global-evil-matchit-mode 1)

;; use jk to exit insert mode
;; this has to be done after evil is turned on
;; (setq key-chord-two-keys-delay 0.2)
;; (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
;; (key-chord-mode 1)

;; Make HJKL keys work in special buffers
(evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
  "K" 'magit-discard-item
  "L" 'magit-key-mode-popup-logging)
(evil-add-hjkl-bindings magit-status-mode-map 'emacs
  "K" 'magit-discard-item
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-toggle-diff-refine-hunk)
(evil-add-hjkl-bindings magit-log-mode-map 'emacs)
(evil-add-hjkl-bindings magit-commit-mode-map 'emacs)
(evil-add-hjkl-bindings occur-mode 'emacs)
(evil-add-hjkl-bindings term-raw-map 'normal
  "p" 'term-paste)

(evil-add-hjkl-bindings org-agenda-mode-map 'emacs
  "Y" 'org-agenda-goto-date
  "Z" 'org-agenda-capture
  "l" 'org-agenda-log-mode)

(evil-add-hjkl-bindings ibuffer-mode-map 'emacs
  "H" 'describe-mode
  "J" 'ibuffer-jump-to-buffer
  "K" 'ibuffer-do-kill-lines
  "L" 'ibuffer-redisplay)

;;; mu4e

(eval-after-load 'mu4e
  '(progn
     ;; use the standard bindings as a base
     (evil-make-overriding-map mu4e-view-mode-map 'normal t)
     (evil-make-overriding-map mu4e-main-mode-map 'normal t)
     (evil-make-overriding-map mu4e-headers-mode-map 'normal t)

     (evil-add-hjkl-bindings mu4e-view-mode-map 'normal
       "J" 'mu4e~headers-jump-to-maildir
       "j" 'evil-next-line
       "C" 'mu4e-compose-new
       "o" 'mu4e-view-message
       "Q" 'mu4e-raw-view-quit-buffer)

     ;; (evil-add-hjkl-bindings mu4e-view-raw-mode-map 'normal
     ;;   "J" 'mu4e-jump-to-maildir
     ;;   "j" 'evil-next-line
     ;;   "C" 'mu4e-compose-new
     ;;   "q" 'mu4e-raw-view-quit-buffer)

     (evil-add-hjkl-bindings mu4e-headers-mode-map 'normal
       "J" 'mu4e~headers-jump-to-maildir
       "j" 'evil-next-line
       "C" 'mu4e-compose-new
       "o" 'mu4e-headers-view-message
       )

     (evil-add-hjkl-bindings mu4e-main-mode-map 'normal
       "J" 'mu4e~headers-jump-to-maildir
       "j" 'evil-next-line
       "RET" 'mu4e-view-message)
     ))

(evil-set-initial-state 'calendar-mode 'emacs)
