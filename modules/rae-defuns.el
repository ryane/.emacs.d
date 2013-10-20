;; Function definitions
;; lifted from emacs-starter-kit

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

;; replaces set-fill-column
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
