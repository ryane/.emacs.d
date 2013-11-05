;; Editing tweaks

;; tabs and whitespace
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

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
(setq whitespace-line-column 80) ;; limit line length

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
  (setq whitespace-style
        (quote (face tabs trailing lines space-before-tab
                     indentation empty space-after-tab tab-mark)))
  (whitespace-mode +1))
(add-hook 'prog-mode-hook 'rae-prog-mode-defaults)
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;; text defaults
(defun rae-text-mode-defaults ()
  "Default settings for text modes"
  (setq whitespace-style
        (quote (face tabs trailing space-before-tab
                     indentation empty space-after-tab tab-mark)))
  (whitespace-mode +1))
(add-hook 'text-mode-hook 'rae-text-mode-defaults)

;; uniq buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-ignore-buffers-re "^\\*")

;; saveplace remembers your location in a file when saving files
(require 'saveplace)
(setq save-place-file (expand-file-name "saveplace" save-dir))
;; activate it for all buffers
(setq-default save-place t)

;; save recent files
(require 'recentf)
(setq recentf-save-file (expand-file-name "recentf" save-dir)
      recentf-max-saved-items 500
      recentf-max-menu-items 15)
(recentf-mode +1)

;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings)

;; window numbers
(require 'window-number)
(window-number-meta-mode)

;; winner mode
(winner-mode 1)

;; highlight the current line
(global-hl-line-mode +1)

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

;;;; auto save files
;; borrowed from emacs prelude https://github.com/bbatsov/prelude
(defcustom rae-auto-save t
  "Non-nil values enable auto save."
  :type 'boolean
  :group 'rae)

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defun rae-auto-save-command ()
  "Save the current buffer if `rae-auto-save' is not nil."
  (when (and rae-auto-save
             buffer-file-name
             (buffer-modified-p (current-buffer))
             (file-writable-p buffer-file-name))
    (save-buffer)))

(defmacro advise-commands (advice-name commands &rest body)
  "Apply advice named ADVICE-NAME to multiple COMMANDS.

The body of the advice is in BODY."
  `(progn
     ,@(mapcar (lambda (command)
                 `(defadvice ,command (before ,(intern (concat (symbol-name command) "-" advice-name)) activate)
                    ,@body))
               commands)))

;; advise all window switching functions
(advise-commands "auto-save"
                 (switch-to-buffer other-window windmove-up windmove-down windmove-left windmove-right window-number-select)
                 (rae-auto-save-command))
(add-hook 'mouse-leave-buffer-hook 'rae-auto-save-command)
