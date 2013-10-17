;; Editing tweaks

;; tabs and whitespace
(setq-default indent-tabs-mode nil)
'(tab-width 2)

(delete-selection-mode t)

;; smart pairing for all
(require 'smartparens-config)
(require 'smartparens-ruby)
(show-smartparens-global-mode +1)

;; whitespace defaults
(setq whitespace-style
      (quote (face tabs trailing lines space-before-tab
                   indentation empty space-after-tab tab-mark)))

;; programming defaults
(require 'linum-relative)
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
