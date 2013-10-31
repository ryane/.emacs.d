(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))

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
  (flymake-cursor-mode)
  (rae-ruby-evil-overrides))
(add-hook 'ruby-mode-hook 'rae-ruby-mode-defaults)
(add-hook 'inferior-ruby-mode-hook 'ansi-color-for-comint-on)
