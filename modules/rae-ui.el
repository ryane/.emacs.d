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

;; better scrolling
;; (setq mouse-wheel-scroll-amount (quote (0.01)))

;; Global bindings
(global-set-key (kbd "C-S-u") 'universal-argument)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "M-l") 'goto-line) ;; formerly ignore downcase-word
(global-set-key (kbd "<f8>") 'org-agenda)

(global-set-key (kbd "<f9> m") 'rae-run-mu4e)
(global-set-key (kbd "<f9> I") 'bh/punch-in)
(global-set-key (kbd "<f9> O") 'bh/punch-out)
(global-set-key (kbd "<f9> g") 'org-clock-goto)
(global-set-key (kbd "<f9> p") 'rae/org-pomodoro-start)
(global-set-key (kbd "<f9> s")
                '(lambda() (interactive)(switch-to-buffer "*scratch*")))
(global-set-key (kbd "<f9> h") 'bh/hide-other)
(global-set-key (kbd "<f9> n") 'bh/toggle-next-task-display)
(global-set-key (kbd "<f9> w") 'widen)
(global-set-key (kbd "<f9> u") 'bh/narrow-up-one-level)
(global-set-key (kbd "<f5>") 'bh/org-todo)
(global-set-key (kbd "<S-f5>") 'bh/widen)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; Font
(when (memq window-system '(mac ns))
  (set-face-attribute 'default nil :font "Menlo-13"))

(when (memq window-system '(w32))
  (set-face-attribute 'default nil :font "Consolas-10"))

(when (memq window-system '(x))
  (set-face-attribute 'default nil :font "Inconsolata-12"))

;; shut the hell up
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; ace window
(global-set-key (kbd "M-p") 'ace-window)

;; hack to handle remapped return key in linux
(when (memq system-type '(gnu/linux))
  (global-set-key [key-4660] 'do-nothing)
  (defun do-nothing()
    "does nothing"
    (interactive)))

;; don't use osx native fullscreen
;; obsolete
;; (setq ns-use-native-fullscreen nil)
;; (global-set-key (kbd "<f6>") 'toggle-frame-fullscreen)
;; http://stackoverflow.com/questions/9248996/how-to-toggle-fullscreen-with-emacs-as-default
;; if you want to use native osx fullscreen, change it to
(defun toggle-fullscreen() "toggle-fullscreen, same as clicking the
 corresponding titlebar icon in the right hand corner of Mac app windows"
  (interactive)
  (set-frame-parameter
   nil 'fullscreen
   (pcase (frame-parameter nil 'fullscreen)
     (`fullboth nil)
     (`fullscreen nil)
     (_ 'fullboth))))
(global-set-key (kbd "H-f") 'toggle-fullscreen)

;; handle display of special buffers based on my preferences
;; i like frames sometimes
;; show rspec tests in a dedicated frame
(add-to-list
 'display-buffer-alist
 '("\\*rspec-compilation\\*" (display-buffer-reuse-window display-buffer-pop-up-frame)
   (reusable-frames . t)))

;; show magit in a dedicated frame
(add-to-list
 'display-buffer-alist
 '("\\*magit: .*\\*" (display-buffer-reuse-window display-buffer-pop-up-frame)
   (reusable-frames . t)))
;; (define-key magit-status-mode-map (kbd "Q") 'magit-mode-quit-window)
;; (define-key magit-status-mode-map (kbd "q") 'suspend-frame)

;; show *cider-error* in dedicated frame
(add-to-list
 'display-buffer-alist
 '("\\*cider-error\\*" (display-buffer-reuse-window display-buffer-pop-up-frame)
   (reusable-frames . t)))
