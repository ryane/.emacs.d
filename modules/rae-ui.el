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
(global-set-key (kbd "C-S-u") 'universal-argument)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "M-l") 'goto-line) ;; formerly ignore downcase-word
(global-set-key (kbd "<f8>") 'org-agenda)

(global-set-key (kbd "<f9> m") 'rae-run-mu4e)
(global-set-key (kbd "<f9> I") 'bh/punch-in)
(global-set-key (kbd "<f9> O") 'bh/punch-out)
(global-set-key (kbd "<f9> g") 'org-clock-goto)
(global-set-key (kbd "<f9> s")
                '(lambda() (interactive)(switch-to-buffer "*scratch*")))
(global-set-key (kbd "<f9> h") 'bh/hide-other)
(global-set-key (kbd "<f9> n") 'bh/toggle-next-task-display)
(global-set-key (kbd "<f9> w") 'widen)
(global-set-key (kbd "<f9> u") 'bh/narrow-up-one-level)
(global-set-key (kbd "<f5>") 'bh/org-todo)
(global-set-key (kbd "<S-f5>") 'bh/widen)

(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Font
(when (memq window-system '(mac ns))
  (set-face-attribute 'default nil :font "Menlo-13"))

(when (memq window-system '(w32))
  (set-face-attribute 'default nil :font "Consolas-10"))

;; shut the hell up
(setq visible-bell t)

;; don't use osx native fullscreen
(setq ns-use-native-fullscreen nil)
(global-set-key (kbd "<f6>") 'toggle-frame-fullscreen)
