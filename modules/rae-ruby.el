(remove-hook 'enh-ruby-mode-hook 'erm-define-faces)

(add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.cap$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.jbuilder$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . enh-ruby-mode))

(unless (eq system-type 'windows-nt)
  (global-rbenv-mode))
;; adapted from
;; http://ck.kennt-wayne.de/2013/may/emacs%3A-jump-to-matching-paren-beginning-of-block
(defun goto-matching-ruby-block (arg)
  (interactive "p")
  (cond
   ;; are we at an end keyword?
   ((equal (current-word) "end")
    (ruby-beginning-of-block))

   ;; or are we at a keyword itself?
   ((string-match
     (current-word)
     "\\(for\\|while\\|until\\|if\\|class\\|module\\|case\\|unless\\|def\\|begin\\|do\\)")
    (ruby-end-of-block))))

(defun rae-ruby-evil-overrides ()
  (define-key evil-normal-state-local-map "%" 'goto-matching-ruby-block))

(defun rae-ruby-mode-defaults ()
  (inf-ruby-minor-mode +1)
  (ruby-tools-mode +1)
  (flymake-ruby-load)
  (rae-ruby-evil-overrides))
(add-hook 'enh-ruby-mode-hook 'rae-ruby-mode-defaults)
(add-hook 'inferior-ruby-mode-hook 'ansi-color-for-comint-on)

;; rspec-mode
(setq rspec-use-rake-when-possible nil)

(defadvice rspec-compile
  (before rspec-save-before-compile ())
  "Save current buffer before running rspec"
  (save-buffer))
(ad-activate 'rspec-compile)
