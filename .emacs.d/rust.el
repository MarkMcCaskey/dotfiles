;; MELPA dependencies - racer, company, cargo, rustfmt, rust-mode
 
;; Setup racer-rust
(setq
racer-rust-src-path "~/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")
 
;; Make it so that saving files while in Rust-mode
;; applies rustfmt and C-c C-c compiles/tests the code
(defun rust-mode-setup ()
  (setq compile-command "cargo test && cargo run")
  (define-key (current-local-map) "\C-c\C-c" 'compile)
  (define-key (current-local-map) "\C-]" 'racer-find-definition)
  (define-key (current-local-map) (kbd "TAB") 'company-indent-or-complete-common)
  (add-hook 'before-save-hook 'rust-format-buffer))
(add-hook 'rust-mode-hook 'rust-mode-setup)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'rust-mode-hook #'eldoc-mode)
(add-hook 'rust-mode-hook #'autopair-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
;(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
 
;; Configure company
(setq company-tooltip-align-annotations t)
(setq company-idle-delay 1)
(setq company-minimum-prefix-length 1)
