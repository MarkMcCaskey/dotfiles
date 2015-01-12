;;;(global-set-key (kbd "C-c b") 'butterfly)
;; This is a barebones Emacs config
 
;; Uncomment these to remove the tool bar, menu bar, and scroll bar
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
 
(global-linum-mode 1)

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
;;;(setq-default indent-tabs-mode nil)
 
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
;(defalias 'yes-or-no-p 'y-or-n-p)
 
;; Example hook:
 
(defun my-c-mode-hook ()
  ; ;; The default style for C code is "gnu". "linux" is closer to what
  ; ;; people are used to.
   (c-set-style "linux")
   ; ;; The basic offset is how many characters lines are indented.
    (setq-default c-basic-offset 4))
 
(add-hook 'c-mode-hook 'my-c-mode-hook)
 
(package-initialize)
 
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			                          ("marmalade" . "http://marmalade-repo.org/packages/")
						                           ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)


(evil-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
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
 
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(global-set-key (kbd "C-x a r") 'align-regexp)
 
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
 
(add-hook 'haskell-mode-hook 'structured-haskell-mode)
 
(setenv "PATH" (concat "~/.cabal/bin:" (getenv "PATH")))
(add-to-list 'exec-path "~/.cabal/bin")
 
(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))
 
 
(require 'rainbow-delimiters) 
;;(global-rainbow-delimiters-mode)
(put 'downcase-region 'disabled nil)

;;relative line numbers

(defvar my-linum-format-string "%3d")

(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

(defun my-linum-get-format-string ()
  (let* ((width (1+ (length (number-to-string
                             (count-lines (point-min) (point-max))))))
         (format (concat "%" (number-to-string width) "d")))
    (setq my-linum-format-string format)))

(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-relative-line-numbers)

(defun my-linum-relative-line-numbers (line-number)
  (let ((offset (- line-number my-linum-current-line-number)))
    (propertize (format my-linum-format-string offset) 'face 'linum)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

(require 'linum-relative)
(linum-mode 1)

(load-theme 'tango-dark t)
(nyan-mode 1)

