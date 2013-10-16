;; Colours
(require 'color-theme-sanityinc-tomorrow)
'(color-theme-sanitynyc-tomorrow-night)
;; (require 'color-theme-solarized)
;; '(color-theme-solarized-light)

;; Chrome
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(unless (eq system-type 'darwin)
  (menu-bar-mode -1))

;; Modeline
(column-number-mode t)

;; Behaviour
(fset 'yes-or-no-p 'y-or-n-p)

;; (require 'flymake-cursor)

;; Global bindings
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "M-l") 'goto-line) ;; formerly ignore downcase-word