(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
(setq company-backends (delete 'company-semantic company-backends))

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(require 'company-irony-c-headers)
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))


(setq company-idle-delay 0)
;(add-hook 'c++-mode-hook 
;          (define-key c++-mode-map [(tab)] 'company-complete))

(add-hook 'c++-mode-hook 'flycheck-mode)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(require 'cmake-ide)

(cmake-ide-setup)

