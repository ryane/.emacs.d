(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist
'("/\\(views\\|html\\|theme\\|templates\\)/.*\\.php\\'" . web-mode))

(eval-after-load 'web-mode
  '(progn
     (defun rae-web-mode-defaults ()
       "Default settings for web mode"
       (linum-mode)
       ;; whitespace-mode breaks syntax highlighting
       (whitespace-mode -1))
     (setq rae-web-mode-hook 'rae-web-mode-defaults)
     (add-hook 'web-mode-hook ( lambda ()
                                (run-hooks 'rae-web-mode-hook)))))
