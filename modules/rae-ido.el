;; ido mode settings
(require 'ido)
(require 'ido-ubiquitous)
(require 'flx-ido)
(ido-mode t)
(ido-ubiquitous t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      confirm-nonexistent-file-or-buffer nil
      ido-auto-merge-work-directories-length nil
      ido-create-new-buffer 'always
      ido-use-virtual-buffers t
      ido-handle-duplicate-virtual-buffers 2
      ido-max-prospects 10)
;; smarter fuzzy matching for ido
(flx-ido-mode +1)
;; disable ido faces to see flx highlights
(setq ido-use-faces nil)
