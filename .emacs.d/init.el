;; Turn off GC during init

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(let ((gc-cons-threshold most-positive-fixnum))
  (load "$HOME/.emacs.d/setup.el"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cider-enlighten-mode nil)
 '(cider-known-endpoints (quote (("dev" "localhost" "7888"))))
 '(cider-repl-history-size 1000)
 '(cider-repl-use-pretty-printing t)
 '(company-ghc-show-info t)
 '(company-global-modes nil)
 '(custom-safe-themes
   (quote
    ("f15a7ce08b9e13553c1f230678e9ceb5b372f8da26c9fb815eb20df3492253b7" "8f1cedf54f137f71382e3367e1843d10e173add99abe3a5f7d3285f5cc18f1a9" "7b7ef508f9241c01edaaff3e0d6f03588a6f4fddb1407a995a7a333b29e327b5" "a0fdc9976885513b03b000b57ddde04621d94c3a08f3042d1f6e2dbc336d25c7" "e3c90203acbde2cf8016c6ba3f9c5300c97ddc63fcb78d84ca0a144d402eedc6" "2a86b339554590eb681ecf866b64ce4814d58e6d093966b1bf5a184acf78874d" "c537bf460334a1eca099e05a662699415f3971b438972bed499c5efeb821086b" "8022cea21aa4daca569aee5c1b875fbb3f3248a5debc6fc8cf5833f2936fbb22" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(haskell-tags-on-save t)
 '(inhibit-startup-screen t)
 '(max-lisp-eval-depth 60000)
 '(max-specpdl-size 166000)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("marmalade" . "http://marmalade-repo.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(package-selected-packages
   (quote
    (xkcd batch-mode cider-decompile javap-mode javap powerline-evil web emojify ## eww-lnum clj-refactor evil-lispy peg mldonkey snoopy counsel markdown-mode rg wgrep-ag clojure-mode-extra-font-locking aggressive-indent helm-projectile helm projectile yaml-mode company-irony use-package slime shm rainbow-identifiers rainbow-delimiters racer paredit nyan-mode nlinum magit flycheck evil company-irony-c-headers company-ghc command-log-mode cmake-ide cider autopair)))
 '(parens-require-spaces nil)
 '(safe-local-variable-values
   (quote
    ((cider-known-endpoints
      ("ladder" "localhost" "7888"))
     (hamlet/basic-offset . 4)
     (haskell-process-use-ghci)
     (haskell-indent-spaces . 4)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'erase-buffer 'disabled nil)
