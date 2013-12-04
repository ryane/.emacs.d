(require 'helm-misc)
(require 'helm-projectile)

(defun helm-rae ()
  "Preconfigured `helm'."
  (interactive)
  (condition-case nil
      (if (projectile-project-root)
          (helm-projectile)
        ;; otherwise fallback to `helm-mini'
        (helm-mini))
    ;; fall back to helm mini if an error occurs (usually in `projectile-project-root')
    (error (helm-mini))))

(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "C-c f") 'helm-projectile)
;; (helm-mode 1)
