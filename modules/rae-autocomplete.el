;; Start with the default configuration
(require 'auto-complete-config)

;; Add extra dictionaries
(add-to-list 'ac-dictionary-directories (concat emacs-dir "auto-complete/dict"))

;; Use dictionaries by default
(setq-default ac-sources (add-to-list 'ac-sources 'ac-source-dictionary))
(global-auto-complete-mode t)

;; Start auto-completion after 2 characters of a word
(setq ac-auto-start 2)

;; I like using C-n and C-p for selecting completions
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;; Be case-sensitive
(setq ac-ignore-case nil)
