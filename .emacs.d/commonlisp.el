(require 'paredit)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'lisp-mode-hook 'paredit-mode)

(setq inferior-lisp-program "/usr/bin/sbcl --dynamic-space-size 1500")
(require 'slime-autoloads)
;(require 'slime)
(slime-setup '(slime-fancy slime-repl slime-sbcl-exts slime-autodoc))
