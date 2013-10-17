;; Emacs configuration entry point

;; Based on stevendanna's emacs-config
;; https://github.com/stevendanna/emacs-config

(require 'package)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(ido-ubiquitous
                      magit
                      markdown-mode
                      exec-path-from-shell
                      ag
                      auto-complete
                      diminish
                      evil evil-leader evil-nerd-commenter evil-matchit
                      yasnippet
                      color-theme-sanityinc-tomorrow
                      zenburn-theme
                      key-chord
                      web-mode
                      projectile
                      flymake flymake-cursor flymake-shell
                      ruby-mode ruby-end ruby-tools inf-ruby flymake-ruby)
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

;; add to load path
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
