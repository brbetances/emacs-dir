;; Preload Stuff
(eval-when-compile)
(require 'use-package)
;; Package Settings
(add-to-list 'load-path (concat (expand-file-name user-emacs-directory) "user-lisp"))
(add-to-list 'load-path (concat (expand-file-name user-emacs-directory) "custom-modes"))
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")))
(require 'custom-functions)
;; Surpress Custom
(setq custom-file (concat user-emacs-directory "/custom.el"))

;; Appearance Settings
(use-package doom-themes
  :ensure t
  :config
  (if (daemonp)
      (add-hook 'after-make-frame-functions
		(lambda (frame)
		  (select-frame frame)
		  (load-theme 'doom-city-lights t)))
    (load-theme 'doom-city-lights)))

;; TEMP deprecating 2021-02-06 07:03
;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions
;; 	      (lambda (frame)
;; 		(select-frame frame)
;; 		(load-theme 'doom-city-lights t)))
;;   (load-theme 'doom-city-lights t))

(add-to-list 'default-frame-alist '(font . "Noto Sans Mono-11"))
(set-face-attribute 'default t :font "Noto Sans Mono-11")
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)
(fringe-mode '(nil . 1))
(line-number-mode -1)
;;(display-battery-mode t)
(global-hl-line-mode t)
(show-paren-mode t)

(setq x-select-enable-clipboard t
      x-select-enable-primary t
      cursor-in-non-selected-windows nil
      truncate-lines t
      desktop-load-locked-desktop t
      completion-ignore-case t
      auto-compression-mode 1
      message-log-max 1000
      show-trailing-whitespace 1
      scroll-margin 0
      scroll-conservatively 0
      scroll-down-aggressively 0
      scroll-up-aggressively 0
      scroll-preserve-screen-position t
      echo-keystrokes 0.1
      mode-line-percent-position nil
      suggest-key-bindings nil)
(setq inferior-lisp-program "/usr/bin/sbcl")
(setq browser-url-browser-function 'browse-url-generic
      browse-url-generic-program "qutebrowser")

;; Global Keybindings (Deprecating)
;; FIXME I don't know where to put this, so for now, it goes here.
(global-set-key (kbd "C-c c p") 'package-install)
(global-set-key (kbd "C-c =") 'desktop-read)
(global-set-key (kbd "C-c +") 'desktop-save)
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
	       mode-line-in-non-selected-windows nil
	       mode-line-modes
	       mode-line-misc-info
	       mode-line-end-spaces))
(display-time-mode t)
(use-package emojify-mode
  :init
  (defun erc-emoji-mode-hook () (emojify-mode t))
  :hook
  ('erc-mode-hook 'erc-emoji-mode-hook))

;; Diminish Settings
(use-package diminish
  :ensure t)

;; Paredit Settings
(use-package paredit
  :ensure t
  :config
  (setq enable-paredit-mode t))

;; Magit Settings
(use-package magit
  :ensure t
  :bind
  ("C-c g m" . magit-status))
;; (use-package forge
;;   :after magit
;;   :bind
;;   :init
;;   (ghub-request "GET" "/user" nil
;; 		:forge 'github
;; 		:host "api.github.com"
;; 		:username "brbetances"
;; 		:auth 'forge)
;;   :config
;;   )
(use-package gist
  :ensure t
  :bind
  ("C-c g b" . gist-buffer))

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

;; VTerm Settings
(use-package vterm
  :bind
  ("C-c C-v v" . vterm-ror)
  ("C-c C-v c" . vterm-copy-mode)
  )

;; Doom Modeline Settings
(use-package all-the-icons)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(add-hook 'ibuffer-mode-hook 'all-the-icons-ibuffer-mode)
(use-package doom-modeline
  :ensure t
  :bind
  ;; FIXME toggles doom modeline because it sometimes doesn't load properly.
  ("C-c d m" . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25
	doom-modeline-bar-width 3
	doom-modeline-window-width-limit fill-column
	doom-modeline-project-detection 'project
	doom-modeline-buffer-file-name-style 'relative-to-project
	doom-modeline-icon (display-graphic-p)
	doom-modeline-continuous-word-count-modes '(org-mode)
	doom-modeline-buffer-encoding nil
	doom-modeline-workspace-name nil
	doom-modeline-persp-name nil
	doom-modeline-lsp nil)
  :hook (after-init . doom-modeline-mode))

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

;; Yasnippet
(use-package yas
  :bind
  ("C-c C-y t" . yas-tryout-snippet)
  :init
  :config
  )

;; Company Mode
(use-package company
  :ensure t
  :init
  (global-company-mode 1)
  :config
  (diminish 'company-mode "c"))

;; Ivy Mode
(use-package ivy
  :ensure t
  :bind
  :init
  :config
  (ivy-mode t)
  (diminish 'ivy-mode " i")
  )

;; Org Mode
(use-package org
  :bind
  ("C-c a" . org-agenda)
  ("C-c 0" . org-export-dispatch)
  :init
  (setq org-agenda-files '("~/org/agenda.org")))

;; Misc. Mode Settings
(use-package emacs-lisp-mode
  :bind
  (:map emacs-lisp-mode-map
	("C-c C-c" . eval-buffer)))

;; Global Mode Settings
(use-package linum-mode
  :bind
  ("<f12>" . linum-mode))

;; OKAY seems fixed. 2021-02-05 10:03
(use-package hl-todo
  :ensure t
  :bind
  ("C-c i" . hl-todo-insert)
  ("C-c p" . hl-todo-previous)
  ("C-c n" . hl-todo-next)
  ("C-c o" . hl-todo-occur)
  :init
  (setq hl-todo-keyword-faces
	'(("HOLD" . "#EE7788")	  ("TODO" . "#5EC4FF")
	  ("NEXT" . "#5EC4FF")	  ("THEM" . "#EE7788")
	  ("PROG" . "#8BD49C")	  ("OKAY" . "#8BD49C")
	  ("DONT" . "#EEBB88")	  ("FAIL" . "#D95468")
	  ("DONE" . "#A0B3C5")	  ("NOTE" . "#5EC4FF")
	  ("HACK" . "#FFFFFF")	  ("TEMP" . "#FFFFFF")
	  ("FIXME" . "#D95468")))
  :config
  (global-hl-todo-mode t)
  )

;; NOTE Create erc-config.el, and set `erc-password', or comment out the next line.
(use-package erc-config)

 ;; ERC Settings
(use-package erc
  :bind
  ("C-c e" . erc-run-or-raise)
  :init
  (setq erc-hide-list '("QUIT" "PART" "JOIN" "NICK")
	erc-server "irc.freenode.net"
	erc-port 6667
	erc-timestamp-format "[%H:%M] "
;;      erc-track-showcount t
	erc-timestamp-only-if-changed-flag t
	erc-insert-timestamp-function 'erc-insert-timestamp-left
	erc-kill-buffer-on-part t
	erc-kill-queries-on-quit t
	erc-kill-server-buffer-on-quit t
	erc-interpret-mirc-color t
	erc-mode-line-format "%t %a"
	erc-auto-query 'bury
	erc-max-buffer-size 15000
	erc-fill-prefix "    "
	erc-fill-column 90
	erc-fill-mode 0
	erc-truncate-buffer-on-save t
;;	erc-track-position-in-mode-line t
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
  )

;; Custom Functions
(use-package custom-functions
  :bind
  ("C-c r" . er-sudo-edit))
