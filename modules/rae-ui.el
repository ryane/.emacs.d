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

(global-set-key (kbd "<f8>") 'org-agenda)
(global-set-key (kbd "<f9> m") 'rae-run-mu4e)

;; Font
(when (memq window-system '(mac ns))
  (set-face-attribute 'default nil :font "Menlo-13"))

(when (memq window-system '(w32))
  (set-face-attribute 'default nil :font "Consolas-14"))

;; shut the hell up
(setq visible-bell t)
