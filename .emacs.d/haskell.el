(use-package company)
(use-package company-ghc)
(use-package haskell-mode)

(defun haskell-mode-setup ()
  (define-key (current-local-map) (kbd "TAB") 'company-indent-or-complete-common))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'haskell-mode-hook 'structured-haskell-mode)
(add-hook 'haskell-mode-hook 'eldoc-mode)
 
(setenv "PATH" (concat "~/.cabal/bin:" (getenv "PATH")))
(setenv "PATH" (concat "~/.local/bin:" (getenv "PATH")))
(add-to-list 'exec-path "~/.cabal/bin")
(add-to-list 'exec-path "~/.local/bin")
(add-to-list 'load-path "~/.cabal/share/x86_64-linux-ghc-7.10.3/ghc-mod-5.5.0.0/elisp")
(add-to-list 'load-path "/home/mark/Documents/etc/structured-haskell-mode/elisp")
(use-package shm)

(custom-set-variables '(haskell-tags-on-save t))

(use-package ghc)

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))
 

(add-to-list 'company-backends 'company-ghc)
(custom-set-variables '(company-ghc-show-info t))

(add-hook 'haskell-mode-hook 'haskell-mode-setup)
(add-hook 'haskell-mode-hook 'company-mode)

(use-package flycheck)



(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))
; Configure company
(setq company-tooltip-align-annotations t)
(setq company-idle-delay 1)
(setq company-minimum-prefix-length 1)
