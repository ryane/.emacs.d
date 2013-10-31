(eval-after-load 'shell-script-mode
  '(progn
     (defun rae-shell-script-mode-defaults ()
       (setq sh-basic-offset 2
             sh-indentation 2))
     (setq rae-shell-script-mode-hook 'rae-shell-script-mode-defaults)
     (add-hook 'shell-script-mode-hook
               (lambda ()
                 (run-hooks 'rae-shell-script-mode-hook)))))
