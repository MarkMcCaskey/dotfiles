(use-package paredit)
(use-package company)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'lisp-mode-hook 'company-mode)

(define-key emacs-lisp-mode-map (kbd "s-d") #'lispy-beginning-of-defun-and-refresh)
