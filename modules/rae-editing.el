;; Editing tweaks

;; tabs and whitespace
(setq-default indent-tabs-mode nil)
'(tab-width 2)
(delete-selection-mode t)

;; spell-checking
(setq-default ispell-program-name "aspell")
(add-hook 'text-mode-hook 'flyspell-mode)

;; auto-fill
;; not sure I want auto-fill yet, I might want a soft-wrap mode
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

;; smart pairing for all
(require 'smartparens-config)
(require 'smartparens-ruby)
(show-smartparens-global-mode +1)

;; whitespace defaults
(setq whitespace-style
      (quote (face tabs trailing lines space-before-tab
                   indentation empty space-after-tab tab-mark)))

;; expand-region
(require 'expand-region)
(require 'ruby-mode-expansions)
(global-set-key (kbd "C-=") 'er/expand-region)

;; programming defaults
(require 'linum-relative)
(setq linum-relative-format "%3s ")
(defun rae-prog-mode-defaults ()
  "Default settings for all programming languages"
  (linum-mode)
  (smartparens-mode +1)
  (whitespace-mode +1))
(add-hook 'prog-mode-hook 'rae-prog-mode-defaults)
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;; text defaults
(defun rae-text-mode-defaults ()
  "Default settings for text modes"
  (whitespace-mode +1))
(add-hook 'text-mode-hook 'rae-text-mode-defaults)

;; uniq buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-ignore-buffers-re "^\\*")

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Autocompletion/snippets
(global-set-key (kbd "M-'") 'hippie-expand)
(require 'yasnippet)
(yas-global-mode 1)
(yas/load-directory (concat emacs-dir "snippets"))

;; projectile is a project management mode
(require 'projectile)
(projectile-global-mode t)
(diminish 'projectile-mode "Prjl")

;; Integrate hippie-expand with ya-snippet
(add-to-list 'hippie-expand-try-functions-list
             'yas/hippie-try-expand)
