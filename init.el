;; Emacs configuration entry point

;; Based on stevendanna's emacs-config
;; https://github.com/stevendanna/emacs-config

(require 'package)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(ido-ubiquitous
                      magit
                      markdown-mode
                      ace-jump-mode
                      multi-term
                      exec-path-from-shell
                      window-number
                      winner
                      ag
                      auto-complete
                      diminish
                      expand-region
                      evil evil-leader evil-nerd-commenter evil-matchit
                      yasnippet
                      color-theme-sanityinc-solarized
                      color-theme-sanityinc-tomorrow
                      zenburn-theme
                      key-chord
                      web-mode scss-mode
                      flx-ido
                      projectile
                      smartparens
                      soap-client jira
                      flymake flymake-cursor flymake-shell
                      ruby-mode ruby-tools inf-ruby flymake-ruby rbenv
                      rspec-mode)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; load vendor and custom files
(defvar emacs-dir (file-name-directory load-file-name)
  "top level emacs dir")
(defvar vendor-dir (concat emacs-dir "vendor/")
  "Packages not yet available in ELPA")
(defvar module-dir (concat emacs-dir "modules/")
  "Where the real configuration happens")
(defvar save-dir (concat emacs-dir "savefile/")
  "Stores automatically generated save/history files")

(unless (file-exists-p save-dir)
  (make-directory save-dir))

;; add to load path
(add-to-list 'load-path (concat vendor-dir "org-mode/lisp/"))
(add-to-list 'load-path (concat vendor-dir "org-mode/contrib/lisp/") t)
(add-to-list 'load-path (concat vendor-dir "org-pomodoro/") t)
(add-to-list 'load-path vendor-dir)
(add-to-list 'load-path module-dir)

;; require packages in modules/
(mapc 'load (directory-files module-dir nil "^[^#].*el$"))

;; custom file
(setq custom-file (concat emacs-dir "modules/rae-custom.el"))
(load custom-file)

;; On OS X Emacs doesn't use the shell PATH if it's not started from
;; the shell. Let's fix that:
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(server-start)
