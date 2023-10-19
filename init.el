(eval-when-compile
  (require 'use-package))

;; Package Settings
(setq package-list '(ivy company magit doom-themes use-package))
(add-to-list 'load-path (concat (expand-file-name user-emacs-directory) "user-lisp"))
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
;; Surpress Custom
(setq custom-file (concat user-emacs-directory "/custom.el"))

;; Appearance Settings
(use-package doom-city-lights-theme)
(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(select-frame frame)
		(load-theme 'doom-city-lights t)))
  (load-theme 'doom-city-lights t))
(add-to-list 'default-frame-alist '(font . "Noto Sans Mono-11"))
(set-face-attribute 'default t :font "Noto Sans Mono-11")
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(fringe-mode '(nil . 1))
(show-paren-mode t)
(setq x-select-enable-clipboard t
      x-select-enable-primary t
      cursor-in-non-selected-windows nil
      truncate-lines t
      completion-ignore-case t
      inhibit-startup-message t
      auto-compression-mode 1
      message-log-max 1000
      show-trailing-whitespace 1
      scroll-margin 0
      scroll-conservatively 0
      scroll-down-aggressively 0
      scroll-up-aggressively 0
      scroll-preserve-screen-position t
      echo-keystrokes 0.1
      suggest-key-bindings nil)
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq browser-url-browser-function 'browse-url-generic
      browse-url-generic-program "qutebrowser")

;; Global Keybindings

;; Modeline Settings
(setq display-time-string-forms
      `((propertize (concat (format-time-string " %d %b ")
			    (substring year -2) " " 24-hours ":" minutes " ")
		    `face 'custom-time-display)))
(setq-default mode-line-format
	      (list
	       mode-line-front-space
	       mode-line-modified
	       mode-line-buffer-identification
	       " "
	       mode-line-misc-info
	       mode-line-end-spaces))
(display-time-mode t)
;; (global-emojify-mode t)

;; Diminish Settings
(use-package diminish)

;; Magit Settings
(use-package magit
  :bind
  ("C-<f5>" . magit-status))

;; Ido Settings
(use-package ido
  :init
  (setq ido-enable-flex-matching 1
	ido-use-virtual-buffers 1
	ido-create-new-buffer 'always
	ido-show-dot-for-dired 1)
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  )

;;IBuffer Settings
(use-package ibuffer
  :init
  (setq ibuffer-show-empty-filter-groups nil
	ibuffer-default-sorting-mode 'major-mode
	ibuffer-expert 1
	ibuffer-shrink-to-minimum-size 1
	ibuffer-use-header-line 1)
  :bind
  ("C-x C-b" . ibuffer)
  :config
  (setq ibuffer-saved-filter-groups
      `(("default"
	 ("Dired" ;; dired related buffers
	  (or (mode . dired-mode)
	      (name . "^\\*Dired log\\*$")))
	 ("LISP" ;; lisp related buffers
	  (or (mode . lisp-mode)
	      (mode . common-lisp-mode)
	      (mode . emacs-lisp-mode)
	      (mode . inferior-lisp-mode)
	      (mode . slime-mode)
	      (mode . inferior-slime-mode)
	      (mode . slime-repl-mode)
	      (mode . scheme-mode)
	      (mode . inferior-scheme-mode)
	      (mode . comint-mode)
	      (name . "^\\*slime-events\\*$")))
	 ("Programming" ;; programming related buffers
	  (or (mode . c-mode)
	      (mode . clojure-mode)
	      (mode . ruby-mode)
	      (mode . c++-mode)
	      (mode . haskell-mode)
	      (mode . inferior-haskell-mode)
	      (mode . python-mode)
	      (mode . inferior-python-mode)
      	      (mode . maxima-mode)
	      (mode . inferior-maxima-mode)))
	 ("Web Dev/JavaScript" ;; webdev related buffers
	  (or (mode . css-mode)
	      (mode . js2-mode)
	      (mode . js-mode)
	      (mode . html-mode)))
	 ("Configs/Shell Scripts" ;; config related buffers
	  (or (mode . shell-script-mode)
	      (mode . conf-xdefaults-mode)
	      (mode . sh-mode)
	      (mode . fundamental-mode)
	      (mode . conf-mode)))
	 ("ERC" ;; erc related buffers
	  (mode . erc-mode))
  	 ("Writing/Org" ;; org-mode related buffers
	  (or (mode . org-mode)
	      (mode . org-agenda-mode)
	      (mode . markdown-mode)
	      (mode . text-mode)
	      (mode . calendar-mode)))
	 ("Version Control" ;; version control related buffers
	  (or (mode . diff-mode)
	      (mode . magit-status-mode)
	      (mode . magit-diff-mode)
	      (mode . magit-process-mode)
	      (mode . magit-revision-mode)
	      (mode . magit-key-mode)
	      (mode . magit-log-edit-mode)
	      (mode . vc-mode)
	      (mode . vc-dir-mode)
	      (mode . vc-log-entry-mode)
	      (name . "^\\*magit-process\\*$")
	      (name . "^\\*magit-log-edit\\*$")))
         ("Web Browsers" ;; w3m related buffers
	  (or (mode . w3m-mode)))
	 ("Mail and News" ;; mail (and news) related buffers
	  (or (mode . gnus-group-mode)
	      (mode . gnus-topic-mode)
	      (mode . gnus-browse-mode)
	      (mode . gnus-summary-mode)
	      (mode . gnus-article-mode)))
	 ("Shell" ;; shell related buffers
	  (or (mode . eshell-mode)
	      (mode . shell-mode)
	      (mode . term-mode)
	      (mode . locate-mode)))
	 ("Emacs Lisp Package Archiver" ;; elpa related buffers
	  (or (mode . package-menu-mode)
	      (name . "^\\*Package Info\\*$")))
	 ("Miscellaneous" ;; miscellaneous special buffers
	  (or (mode . Info-mode)
	      (mode . apropos-mode)
	      (mode . Help-Mode)
	      (mode . help-mode)
	      (mode . Man-mode)
	      (mode . woman-mode)
	      (mode . occur-mode)
	      (mode . customize-mode)
	      (mode . Custom-mode)
	      (mode . completion-list-mode)
	      (name . "\\*scratch\\*$")
	      (name . "\\*Messages\\*$")
	      (name . "\\*Keys\\*$")
	      (name . "\\*Disabled Command\\*$")
	      (name . "\\*Org PDF LaTeX Output\\*$"))))))
  (add-hook 'ibuffer-mode-hook (lambda ()
			       (ibuffer-auto-mode 1)
			       (ibuffer-switch-format)
			       (ibuffer-switch-to-saved-filter-groups "default")))

  )

;; Company Mode
(use-package company
  :init
  (global-company-mode 1))

(use-package ivy
  :bind
  :init
  :config
  (ivy-mode t))

;; Org Mode
(use-package org
  :bind
  ("C-c a" . org-agenda)
  :init
  (setq org-agenda-files '("~/org/agenda.org")))

;; Major Mode Settings
(use-package emacs-lisp-mode
  :bind
  (:map emacs-lisp-mode-map
	("C-c C-c" . eval-buffer)))

;; Minor Mode Settings
(use-package display-line-numbers-mode
  :bind
  ("<f12>" . display-line-numbers-mode))

;; Make erc-config.el and set erc-password, or comment out this line.
;;(use-package erc-config)
;; ERC Settings
(use-package erc
  :bind
  ("C-<f3>" . erc-run-or-raise)
  :init
  (setq erc-hide-list '("QUIT" "PART" "JOIN" "NICK")
	erc-server "irc.freenode.net"
	erc-port 6667
	erc-timestamp-format "[%H:%M] "
        erc-track-showcount t
	erc-timestamp-only-if-changed-flag t
	erc-insert-timestamp-function 'erc-insert-timestamp-left
	erc-kill-buffer-on-part t
	erc-kill-queries-on-quit t
	erc-kill-server-buffer-on-quit t
	erc-interpret-mirc-color t
	erc-mode-line-format "%t %a"
	erc-auto-query 'bury
	erc-max-buffer-size 15000
	erc-truncate-buffer-on-save t
	erc-track-position-in-mode-line t
	erc-header-line-format nil
	erc-input-line-position -2)
  :config
  ;; custom prompt
  (setq erc-prompt
	(lambda () (if (and (boundp 'erc-default-recipients) (erc-default-target))
		       (erc-propertize (concat (erc-default-target) ">")
				       'read-only t 'rear-nonsticky
				       t 'front-nonsticky t)
				       (erc-propertize (concat "ERC>") 'read-only t
						       'rear-nonsticky t
						       'front-nonsticky t)))
	erc-join-buffer 'bury)
  ;; run or raise function
  (defun erc-run-or-raise (&rest junk)
    "run-or-raise erc."
    (interactive)
    (if (get-buffer "irc.freenode.net:6667")
	(erc-track-switch-buffer 1)
      (erc :server erc-server :port erc-port :nick erc-nick :password erc-password)))
  )

;; Custom Functions
(use-package custom-functions
  :bind
  ("C-c r" . er-sudo-edit))

;; EOF
