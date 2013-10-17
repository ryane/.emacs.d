;; Editing tweaks

;; tabs and whitespace
(setq-default indent-tabs-mode nil)
'(tab-width 2)

;; whitespace defaults
(setq whitespace-style
      (quote (face tabs trailing lines space-before-tab
                   indentation empty space-after-tab tab-mark)))

;; programming defaults
(defun rae-prog-mode-defaults ()
  "Default settings for all programming languages"
  (linum-mode)
  (whitespace-mode +1))
(add-hook 'prog-mode-hook 'rae-prog-mode-defaults)

;; text defaults
(defun rae-text-mode-defaults ()
  "Default settings for text modes"
  (whitespace-mode +1))
(add-hook 'text-mode-hook 'rae-text-mode-defaults)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))