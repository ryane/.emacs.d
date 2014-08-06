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
                      magit git-timemachine
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
                      leuven-theme
                      key-chord
                      web-mode scss-mode haml-mode
                      flx-ido
                      ido-vertical-mode
                      projectile
                      project-explorer
                      smartparens
                      helm helm-projectile
                      xml-rpc soap-client jira
                      flymake flymake-cursor flymake-shell
                      clojure-mode clojure-test-mode
                      ruby-mode ruby-tools inf-ruby flymake-ruby rbenv
                      haskell-mode ghc
                      sentence-highlight
                      alert
                      rspec-mode yaml-mode)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(defconst *is-a-mac* (eq system-type 'darwin))
;; load vendor and custom files
(defvar emacs-dir (file-name-directory load-file-name)
  "top level emacs dir")
(defvar vendor-dir (concat emacs-dir "vendor/")
  "Packages not yet available in ELPA")
(defvar module-dir (concat emacs-dir "modules/")
  "Where the real configuration happens")
(defvar save-dir (concat emacs-dir "savefile/")
  "Stores automatically generated save/history files")

;; organizer directory
(if (memq window-system '(w32))
    (setq rae-org-dir "C:/Users/ryan")
  (setq rae-org-dir (expand-file-name "~")))

(unless (file-exists-p save-dir)
  (make-directory save-dir))

;; add to load path
(add-to-list 'load-path (concat vendor-dir "org-mode/lisp/"))
(add-to-list 'load-path (concat vendor-dir "org-mode/contrib/lisp/") t)
(add-to-list 'load-path (concat vendor-dir "org-pomodoro/") t)
(add-to-list 'load-path (concat vendor-dir "org-journal/") t)
(add-to-list 'load-path (concat vendor-dir "wc-mode/") t)
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
  (exec-path-from-shell-initialize)
)

(server-start)

(setq initial-frame-alist '((top . 0) (left . 0) (width . 176) (height . 53)))

(when (eq system-type 'darwin)
  ;; from https://gist.github.com/railwaycat/3498096
  (global-set-key [(hyper a)] 'mark-whole-buffer)
  (global-set-key [(hyper v)] 'yank)
  (global-set-key [(hyper c)] 'kill-ring-save)
  (global-set-key [(hyper s)] 'save-buffer)
  (global-set-key [(hyper l)] 'goto-line)
  (global-set-key [(hyper w)]
                  (lambda () (interactive) (delete-window)))
  (global-set-key [(hyper z)] 'undo)

  ;; mac switch meta key
  (defun mac-switch-meta nil
    "switch meta between Option and Command"
    (interactive)
    (if (eq mac-option-modifier nil)
        (progn
          (setq mac-option-modifier 'meta)
          (setq mac-command-modifier 'hyper)
          )
      (progn
        (setq mac-option-modifier nil)
        (setq mac-command-modifier 'meta)
        )))
  (mac-switch-meta))
