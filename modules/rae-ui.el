;; Chrome
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(if (eq window-system 'ns)
  (menu-bar-mode 1)
  (menu-bar-mode 0))

;; Modeline
(column-number-mode t)

;; Behaviour
(fset 'yes-or-no-p 'y-or-n-p)

;; (require 'flymake-cursor)

;; Global bindings
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "M-l") 'goto-line) ;; formerly ignore downcase-word

;; Font
(when (memq window-system '(mac ns))
  (set-face-attribute 'default nil :font "Menlo-13"))
