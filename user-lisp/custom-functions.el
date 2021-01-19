(defun er-sudo-edit (&optional arg)
  "edit currently visited file as root."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
			 (ido-read-file-name "find file (as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun which-major-buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil, return the current buffer's mode."
  (buffer-local-value 'major-mode
    (if buffer-or-name (get-buffer buffer-or-name) (current-buffer))))

(provide 'custom-functions)
