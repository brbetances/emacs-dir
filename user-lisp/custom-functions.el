;; Author: brb <brbetances@gmail.com>
;; File: custom-functions.el

;; Reload file as root
(defun er-sudo-edit (&optional arg)
  "edit currently visited file as root."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
			 (ido-read-file-name "find file (as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; Get current buffer major mode
(defun which-major-buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil, return the current buffer's mode."
  (buffer-local-value 'major-mode
    (if buffer-or-name (get-buffer buffer-or-name) (current-buffer))))

;; Insert custom datetime
(defun insert-datetime ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M")))
(global-set-key (kbd "C-c t") 'insert-datetime)

;; VTerm run-or-raise
(defun vterm-ror (&rest junk)
  "run-or-raise vterm."
  (interactive)
  (if (get-buffer "vterm")
      (switch-to-buffer "vterm")
    (vterm)))

;; ERC run-or-raise
(defun erc-run-or-raise (&rest junk)
  "run-or-raise erc."
  (interactive)
  (if (get-buffer "irc.freenode.net:6667")
      (erc-track-switch-buffer 1)
    (erc :server erc-server :port erc-port :nick erc-nick :password erc-password)))

(provide 'custom-functions)
