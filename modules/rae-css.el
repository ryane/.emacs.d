(eval-after-load 'css-mode
  '(progn
     (add-to-list 'auto-mode-alist '("\\.css\\.erb" . css-mode))
     (defun rae-css-mode-defaults ()
       ;; (rainbow-mode +1)
       (linum-mode)
       (setq css-indent-offset 2))
     (setq rae-css-mode-hook 'rae-css-mode-defaults)
     (add-hook 'css-mode-hook (lambda ()
                                (run-hooks 'rae-css-mode-hook)))))

(eval-after-load 'scss-mode
  '(progn
     (setq scss-compile-at-save nil)))
