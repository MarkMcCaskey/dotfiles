;; Example hook:
 
(defun my-c-mode-hook ()
  ; ;; The default style for C code is "gnu". "linux" is closer to what
  ; ;; people are used to.
   (c-set-style "linux")
   ; ;; The basic offset is how many characters lines are indented.
    (setq-default c-basic-offset 4))
 
(add-hook 'c-mode-hook 'my-c-mode-hook)
