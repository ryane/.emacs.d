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
(if (memq window-system '(w32))
    (setq-default ispell-program-name "aspell")
  (setq-default ispell-program-name "/usr/local/bin/aspell"))
(add-hook 'text-mode-hook 'flyspell-mode)

;; wrapping
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; I use single spacing for my sentences
(setq sentence-end-double-space nil)

;; whitespace defaults
(setq whitespace-line-column 80) ;; limit line length

;; cleanup whitespace
(defcustom rae-clean-whitespace-on-save t
  "Cleanup whitespace from file before it's saved.
Will only occur if prelude-whitespace is also enabled."
  :type 'boolean
  :group 'prelude)
(defun rae-cleanup-maybe ()
  "Invoke `whitespace-cleanup' if `rae-clean-whitespace-on-save' is not nil."
  (when rae-clean-whitespace-on-save
    (whitespace-cleanup)))


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
  (flyspell-prog-mode)
  (setq whitespace-style
        (quote (face tabs trailing lines space-before-tab
                     indentation empty space-after-tab tab-mark)))
  (whitespace-mode +1)
  (add-hook 'before-save-hook 'rae-cleanup-maybe nil t))
(add-hook 'prog-mode-hook 'rae-prog-mode-defaults)
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;; text defaults
(defun rae-text-mode-defaults ()
  "Default settings for text modes"
  (setq whitespace-style
        (quote (face tabs trailing space-before-tab
                     indentation empty space-after-tab tab-mark)))
  (whitespace-mode +1)
  (add-hook 'before-save-hook 'rae-cleanup-maybe nil t))
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
(setq recentf-keep '(file-remote-p file-readable-p))
;; (setq recentf-auto-cleanup 'never)
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

;; project-explorer
(require 'project-explorer)
(setq pe/omit-regex (concat pe/omit-regex "\\|^node_modules$\\|%^\.bundle$"))

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

;; global auto-revert
(global-auto-revert-mode t)

;; writing prose
(require 'wc-mode)
(require 'sentence-highlight)
(defun rae-write-mode ()
  "Enter a distraction free writing environment"
  (interactive)
  (delete-other-windows)
  (if (eq major-mode 'org-mode)
      (org-narrow-to-subtree))
  (auto-fill-mode -1)
  (visual-line-mode +1)
  (writegood-mode +1)
  (wc-mode +1)
  (wc-set-word-goal 500)
  (sentence-highlight-mode +1)
  (writeroom-mode +1))
