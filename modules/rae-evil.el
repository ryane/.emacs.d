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
  "k" 'kill-buffer)

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
(setq key-chord-two-keys-delay 0.2)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-mode 1)

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
