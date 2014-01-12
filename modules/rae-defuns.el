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

(defun transpose-windows (arg)
   "Transpose the buffers shown in two windows."
   (interactive "p")
   (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
     (while (/= arg 0)
       (let ((this-win (window-buffer))
             (next-win (window-buffer (funcall selector))))
         (set-window-buffer (selected-window) next-win)
         (set-window-buffer (funcall selector) this-win)
         (select-window (funcall selector)))
       (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

(define-key ctl-x-4-map (kbd "t") 'transpose-windows)


;; sometimes I like to prune my buffer lists
(defun rae-clean-buffer-list ()
  (interactive)
  (setq ido-virtual-buffers '())
  (setq recentf-list '()))

;; http://emacsredux.com/blog/2013/03/28/google/
(defun rae-google ()
  "Google the selected region if any, display a query prompt otherwise."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (url-hexify-string (if mark-active
         (buffer-substring (region-beginning) (region-end))
       (read-string "Google: "))))))
