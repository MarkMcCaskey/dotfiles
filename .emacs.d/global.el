(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)


;; By default, Emacs only shows the line number on the mode line, in
;; the form `L<number>'. When `column-number-mode' is enabled, it
;; has the column and line number in the form `(<linenum>, <colnum>)'
;; The '1' as the first argument to `column-number-mode' turns the
;; mode on. A non-positive number turns the mode off.
(column-number-mode 1)
 
;; ido-mode gives you completion for `find-file' and `switch-buffer'.
;; If you want completion for M-x as well, grab the package `smex'.
(ido-mode 1)
;; ido-everywhere will let you use ido-mode anywhere you interact
;; with your file system, like with `save-buffer'.
;(ido-everywhere 1)
 
;(global-nlinum-mode 1)

;; Emacs does not highlight a matching paren by default.
;; `show-paren-mode' will highlight the matching paren for the one
;; your point is currently on. By default, it has a slight delay.
;; Setting `show-parent-delay' to 0 turns that delay off.
;; `show-parent-delay' must be set before enabling `show-paren-mode',
;; otherwise it won't work.
(setq show-paren-delay 0)
(show-paren-mode 1)
 
;; Emacs does not indent new lines by default. When
;; `electric-indent-mode' is enabled, the line will re-indent whenever
;; you insert a character from `electric-indent-chars'. It sometimes
;; breaks python-mode, however.
(electric-indent-mode 1)
 
;; By default, Emacs mixes tabs and spaces. This turns off tabs, so
;; Emacs will only use spaces, as Emacs usually handles that well.
;; You should do additional research if you want to only use tabs.
(setq-default indent-tabs-mode nil)
 
;; By default, Emacs will litter auto-save and backup files all over
;; your file system. The following will place all auto-save and backup
;; files in your temp directory (`/tmp' for linux, `C:Temp' for
;; windows).
(setq backup-directory-alist
            `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
            `((".*" ,temporary-file-directory t)))
 
;; By default, Emacs will move half a page when you move past the top
;; of a buffer. Setting the `scroll-margin' to 4 means that it moves
;; the buffer when you are 4 lines from the top or bottom, and
;; `scroll-conservatively' makes Emacs move the buffer one line only.
(setq scroll-margin 4)
(setq scroll-conservatively 1)
 
;; When you try to make a non-reversable change to your system, Emacs
;; will give you a yes-or-no prompt, and you have to type out "yes"
;; or "no". Uncomment the next line to shorten this to "y" or "n".
(defalias 'yes-or-no-p 'y-or-n-p)
 
(package-initialize)
 
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))
(unless package-archive-contents
  (package-refresh-contents))
;(package-install-selected-packages)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


(use-package evil)
(evil-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f15a7ce08b9e13553c1f230678e9ceb5b372f8da26c9fb815eb20df3492253b7" "8f1cedf54f137f71382e3367e1843d10e173add99abe3a5f7d3285f5cc18f1a9" "7b7ef508f9241c01edaaff3e0d6f03588a6f4fddb1407a995a7a333b29e327b5" "a0fdc9976885513b03b000b57ddde04621d94c3a08f3042d1f6e2dbc336d25c7" "e3c90203acbde2cf8016c6ba3f9c5300c97ddc63fcb78d84ca0a144d402eedc6" "2a86b339554590eb681ecf866b64ce4814d58e6d093966b1bf5a184acf78874d" "c537bf460334a1eca099e05a662699415f3971b438972bed499c5efeb821086b" "8022cea21aa4daca569aee5c1b875fbb3f3248a5debc6fc8cf5833f2936fbb22" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(inhibit-startup-screen t)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 
 
(use-package rainbow-delimiters) 
;(use-package linum-relative)
(put 'downcase-region 'disabled nil)
(use-package nlinum)
(global-nlinum-mode 1)

;(defvar my-linum-format-string "%3d")

;(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

;(defun my-linum-get-format-string ()
;  (let* ((width (1+ (length (number-to-string
;                             (count-lines (point-min) (point-max))))))
;         (format (concat "%" (number-to-string width) "d")))
;    (setq my-linum-format-string format)))

;(defvar my-linum-current-line-number 0)

;(setq linum-format 'my-linum-relative-line-numbers)

;(defun my-linum-relative-line-numbers (line-number)
;  (let ((offset (- line-number my-linum-current-line-number)))
;    (propertize (format my-linum-format-string offset) 'face 'linum)))

;(defadvice linum-update (around my-linum-update)
;  (let ((my-linum-current-line-number (line-number-at-pos)))
;    ad-do-it))
;(ad-activate 'linum-update)

;(linum-mode 1)

(load-theme 'tango-dark t)

(use-package nyan-mode)
(nyan-mode 1)

(define-key prog-mode-map (kbd "C-c h m") 'helm-projectile)

(use-package wgrep-ag)
(use-package rg)
(rg-enable-default-bindings (kbd "C-M-s"))
(add-hook 'rg-mode-hook 'wgrep-ag-setup)

(setq gc-cons-threshold (* 1024 1024 1024))
(run-with-idle-timer 28 t (lambda () (garbage-collect)))

(use-package evil-lispy)
(add-hook 'emacs-lisp-mode-hook #'evil-lispy-mode)


;; (defun safely-index (idx xs)
;;   "no point in falling off the end, just go to the last existing window"
;;   (elt xs (min (- (length xs) 1) idx)))

;; (defun ->window (idx)
;;   (lexical-let ((idx idx))
;;     (lambda () (interactive) (aw-switch-to-window (safely-index idx (aw-window-list))))))

;; (global-set-key (kbd "s-'") (->window 0))
;; (global-set-key (kbd "s-,") (->window 1))
;; (global-set-key (kbd "s-.") (->window 2))
;; (global-set-key (kbd "s-p") (->window 3))

;; Because I make this mistake too often
;; C-w C-<x> = C-w <x>
(define-key evil-window-map "C-l" 'evil-window-right)
(define-key evil-window-map "C-h" 'evil-window-left)
(define-key evil-window-map "C-j" 'evil-window-down)
(define-key evil-window-map "C-k" 'evil-window-up)

(use-package ivy)
(setq projectile-completion-system 'ivy)
(use-package counsel)

(use-package command-log-mode)

(setq avy-keys '(?a ?o ?e ?u ?i ?h ?t ?n ?s))


(use-package magit)
(global-set-key (kbd "C-x g") 'magit-status)
(setq projectile-enable-caching t)
(setq projectile-projects-cache (make-hash-table :test 'equal))

;; TODO: make this conditional based on emacs resolution or hack it based on OS
(set-face-attribute 'default nil :height 120)
