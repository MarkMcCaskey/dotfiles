;; Heavily "inspired" by Russel's Emacs config

(use-package paredit)
(use-package cider)
(use-package company)
(use-package projectile)
(use-package helm)
(use-package helm-projectile)
(use-package counsel)

(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)
(add-hook 'lisp-mode-hook 'paredit-mode)
(add-hook 'cider-mode-hook 'paredit-mode)
(add-hook 'cider-mode-hook #'company-mode)
(add-hook 'cider-mode-hook 'eldoc-mode)
;; (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-repl-mode-hook #'company-mode)
;; (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'cider-repl-mode-hook 'paredit-mode)
(add-hook 'clojure-mode-hook 'subword-mode)
(add-hook 'clojure-mode-hook #'company-mode)
;; (add-hook 'clojure-mode-hook #'cider-company-enable-fuzzy-completion)
(add-hook 'clojurescript-mode-hook 'subword-mode)
(add-hook 'clojurescript-mode-hook #'company-mode)
(add-hook 'clojurescript-mode-hook #'cider-company-enable-fuzzy-completion)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
(helm-projectile-on)
(setq clojure-indent-style :always-indent)

(setq cider-test-infer-test-ns (lambda (x) x))


(defun up-and-refresh ()
  (interactive)
  (up-list-or-out-string)
  (cf--overlay-current-form))

;; the functions in clojure more for cycling collection type annoyingly move the point
;; (probably because they are extracting the text with a regex and reinserting it)
;; (which means regular `save-excursion` can't save us)
(defun reverting-point (funcsym)
 (lexical-let ((funcsym funcsym))
  (lambda ()
    (interactive)
    (let ((orig-pt (point)))
      (funcall funcsym)
      (goto-char orig-pt)))))

(define-key cider-mode-map (kbd "C-c [") (reverting-point 'clojure-convert-collection-to-vector))
(define-key cider-mode-map (kbd "C-c (") (reverting-point 'clojure-convert-collection-to-list))
(define-key cider-mode-map (kbd "C-c {") (reverting-point 'clojure-convert-collection-to-map))

(define-key clojure-mode-map (kbd "C-c [") (reverting-point 'clojure-convert-collection-to-vector))
(define-key clojure-mode-map (kbd "C-c (") (reverting-point 'clojure-convert-collection-to-list))
(define-key clojure-mode-map (kbd "C-c {") (reverting-point 'clojure-convert-collection-to-map))


(defun eval-defun-and-rerun-test ()
  (interactive)
  (cider-eval-defun-at-point)
  (cider-test-rerun-test))

(define-key cider-mode-map (kbd "C-c M-r") 'eval-defun-and-rerun-test)

;; make evil-lispy start in the modes you want
;; (add-hook 'clojure-mode-hook #'lispy-mode)
;; (add-hook 'clojure-mode-hook #'evil-lispy-mode)

(defun adv-load-buffer-revert-file ()
  (revert-buffer nil t))
(advice-add 'cider-load-buffer :after #'adv-load-buffer-revert-file)

(defun cider-auto-connect ()
  (interactive)
  (let ((replbuf (get-buffer "*cider-repl localhost*")))
    (when replbuf
      (kill-buffer replbuf)))
  (cider-mode 1)
  (cider-connect "localhost" "7888" "/Users/mark/ladder")
  (other-window 1)
  (cider-ladder-disable-logging)
  (buffer-disable-undo))

(define-key clojure-mode-map (kbd "C-c C-a") 'cider-auto-connect)

(global-set-key (kbd "C-x C-b") 'helm-mini)

(setq ring-bell-function 'ignore)

(defun defun-not-in-comment (&optional bounds)
  (save-excursion
    (save-match-data
      (end-of-defun)
      (let ((end (point)))
	(clojure-backward-logical-sexp 1)
	(if (looking-at "(comment")
	    nil
	  (funcall (if bounds #'list #'buffer-substring-no-properties) (point) end))))))

(defun my-defun-at-point (&optional bounds)
  (or (defun-not-in-comment bounds)
      (save-excursion (while (not (save-excursion (backward-up-list 1 't) (looking-at "(comment")))
	       (backward-up-list 1 't))
	     (let ((begin (point)))
	       (clojure-forward-logical-sexp)
	       (funcall (if bounds #'list #'buffer-substring-no-properties) begin (point))))))

(fset 'orig-cider-defun-at-point 'cider-defun-at-point)

(defvar cider-last-eval-form nil)
(make-variable-buffer-local 'cider-last-eval-form)

(defun enclosing-sexp-bounds ()
  (save-excursion
    (backward-up-list 1 't)
    (list (point) (progn (clojure-forward-logical-sexp) (point)))))

(defun lispy-active-sexp-bounds ()
  (if-let ((d-point (ignore-errors (save-excursion (lispy-different) (point)))))
      ;; backwards bounds confuse cider
      (if (< (point) d-point)
	  (list (point) d-point)
	(list d-point (point)))))

(defun lispy-sexp-bounds ()
  (if (region-active-p) 		; so lispy-different doesnt hijack our mark
      (enclosing-sexp-bounds)
    (if-let ((active-bounds (lispy-active-sexp-bounds)))
	active-bounds
      (enclosing-sexp-bounds))))

(defun copy-enclosing-sexp (&optional kill)
  (interactive "P")
  (if kill
      (progn
	(apply #'kill-region (enclosing-sexp-bounds))
	(just-one-space))
    (apply #'kill-ring-save (enclosing-sexp-bounds))))

(global-set-key (kbd "M-m") 'copy-enclosing-sexp)
(global-set-key (kbd "M-l") #'paredit-recenter-on-defun)
(global-set-key (kbd "s-l") #'paredit-recenter-on-defun)

(defvar cf--overlay nil)
(make-variable-buffer-local 'cf--overlay)

(defvar cf--enabled t)
(defvar cf--interval 0.299)

(defun cf--get-overlay-bounds (begin end)
  (when (null cf--overlay)
    (let ((o (make-overlay begin end nil nil nil)))
      (overlay-put o 'type 'cf-overlay)
      ;; (overlay-put o 'face '(:background "#2a2a2a"))
      (setq cf--overlay o)))
  (overlay-put cf--overlay 'face
	       (if (or (lispy-right-p) (lispy-left-p))
		   '(:background "#2a4a2a")
		 '(:background "#2a2a2a")))
  (move-overlay cf--overlay begin end))

(defun cf--remove-overlay ()
  (when cf--overlay
      (delete-overlay cf--overlay)
      (setq cf--overlay nil)))

(defun cf--overlay-current-form ()
  (when (not (string-equal "*cider-result*" (buffer-name (current-buffer))))
   (condition-case nil
       (apply #'cf--get-overlay-bounds (lispy-sexp-bounds))	  
     (error nil (cf--remove-overlay)))))

(defun cf--timer-hook ()
  (if (not cf--enabled)
      (cf--remove-overlay)
    (when (memq major-mode '(clojure-mode clojurec-mode emacs-lisp-mode))
      (cf--overlay-current-form))))

(defun cf--enable ()
  (interactive)
  (setq cf--enabled t)
  (add-hook 'post-command-hook (lambda () (run-with-idle-timer cf--interval nil #'cf--timer-hook)) nil :local))


(add-hook 'clojure-mode-hook #'cf--enable)
(setq cider-save-file-on-load t)
(global-set-key (kbd "s-t") #'transpose-sexps)
(global-set-key (kbd "s-f") #'toggle-frame-fullscreen)
(global-set-key (kbd "s-h") nil)

(setq clojure-indent-style :always-indent)

;; refresh current sexp highlighting instantly after lispy movement  
(defun uplist-newline-parens ()
  (interactive)
  ;; (lispy-parens nil)
  (let ((d (save-excursion (my-delimiter))))
    (lispy-out-forward-newline 1)
    (cond
     ((eq d ?\() (paredit-open-round))
     ((eq d ?\[) (paredit-open-square))
     ((eq d ?\{) (paredit-open-curly)))))

(defun lispy-down-and-refresh ()
  (interactive)
  (special-lispy-down)
  (paredit-recenter-on-sexp)
  (cf--overlay-current-form))

(defun lispy-up-and-refresh ()
  (interactive)
  (special-lispy-up)
  (paredit-recenter-on-sexp)
  (cf--overlay-current-form))

(defun lispy-flow-and-refresh ()
  (interactive)
  (special-lispy-flow)
  (cf--overlay-current-form))

(defun lispy-back-and-refresh ()
  (interactive)
  (special-lispy-back)
  (cf--overlay-current-form))

(defun lispy-space-and-refresh ()
  (interactive)
  (lispy-other-space)
  (cf--overlay-current-form))

(defun my-lispy-space ()
  (interactive)
  (cond ((lispy-left-p)
         (insert " ")
         (backward-char 1))
	(t (insert " "))))

(defun lispy-cider-inspect ()
  (interactive)
  (cider-inspect-defun-at-point)
  (shrink-window-if-larger-than-buffer))

(defun my-lispy-clear-repl-and-eval ()
  (interactive)
  (if (memq major-mode '(clojure-mode clojurec-mode))
      (progn
	(cider-find-and-clear-repl-output t)
	(cider-interactive-eval nil nil (lispy-sexp-bounds)))
    (call-interactively 'lispy-eval)))

(defun my-lispy-eval ()
  (interactive)
  (if (memq major-mode '(clojure-mode clojurec-mode))
      (cider-interactive-eval nil nil (lispy-sexp-bounds))
    (call-interactively 'lispy-eval)))

(defun wrap-and-space ()
  (interactive)
  (paredit-wrap-round)
  (lispy-other-space)
  (cf--overlay-current-form))

(defun my-introduce-let ()
  (interactive)
  (wrap-and-space)
  (insert "let []\n")
  (lispy-tab))

(defun lispy-beginning-of-defun-and-refresh ()
  (interactive)
  (lispy-beginning-of-defun)
  (cf--overlay-current-form))

(defun lispy-ace-symbol-ag ()
  (interactive)
  (lispy-ace-symbol 1)
  (helm-ag-project-root))

(defun lispy-ace-symbol-swoop ()
  (interactive)
  (lispy-ace-symbol 1)
  (helm-swoop))

(defmacro refreshing (fn-sym &rest args)
  `(lambda ()
     (interactive)
     (funcall ,fn-sym ,args)
     (cf--overlay-current-form)))

;; just take an arg and ignore it...
(defun cf--overlay-advice (&optional ignored)
  (cf--overlay-current-form))
(advice-add 'lispy-space :after #'cf--overlay-advice)
(advice-add 'indent-for-tab-command :after #'cf--overlay-advice)

(defun my-tab (&optional arg)
  ;; I press tab to get to the code from the line beginning -
  ;; if I want to indent I can just press it again
  (interactive)
  (if (or (> (current-column) 0)
 	  (eq (point) (line-end-position)))
      (indent-for-tab-command arg)
    (re-search-forward "[^ ]")
    (backward-char)))

(defun my-lispy-extract ()
  (interactive)
  (lispy-new-copy)
  (lispy-beginning-of-defun)
  (open-line 1)
  (yank)
  (lispy-different))

;; get the text of the thing in func position in active lispy form
(defun my-lispy-func-text ()
  (let ((start (car (lispy-sexp-bounds))))
    (save-excursion (goto-char start)
		    (forward-char)
		    (forward-sexp)
		    (let ((end (point)))
		      (backward-sexp)
		      (buffer-substring-no-properties (point) end)))))

(defun my-lispy-goto-def ()
  (interactive)
  (cider-find-var nil (my-lispy-func-text))
  (paredit-recenter-on-sexp))

(defun blank-line-p ()
  (save-excursion
    (beginning-of-line)
    (save-match-data
      (looking-at "[[:space:]]*$"))))

(defvar space-only-line-re
  (rx (one-or-more (syntax whitespace))
      (one-or-more (group (or ")" "]" "}")))
      (one-or-more (syntax whitespace))))

;; O(1) line number....
(string-to-number (format-mode-line "%l"))

(defun delete-sexp-and-spaces ()
  (let* ((bounds (lispy-active-sexp-bounds))
         (start (car bounds))
         (end (cadr bounds)))
    (goto-char start)
    (delete-char (- end start)))
  (while (memq (char-after) '(9 32 10))
    (delete-char 1)))

(defun my-lispy-delete (&optional arg)
  (interactive)
  (cond
   ((or (lispy-left-p) (lispy-right-p)) (delete-sexp-and-spaces))
   (t (lispy-delete 1))))

(defun my-indent-defun ()
  (interactive)
  ;; complete garbage
  (lispy--remember)
  (lispy-beginning-of-defun)
  (lispy--normalize-1)
  (lispy-back 1))

(define-key clojure-mode-map (kbd "s-d") #'lispy-beginning-of-defun-and-refresh)
(define-key clojure-mode-map (kbd "[") #'paredit-open-square)

(setq ivy-use-virtual-buffers t)
(setq cider-repl-use-clojure-font-lock nil)

;; (buffer-disable-undo "*cider-repl localhost*")

(defun cider-eval-to-kill-ring ()
  (interactive)
  (let* ((d (cider-nrepl-sync-request:eval (cider-defun-at-point) (cider-current-connection) (cider-current-ns)))
         (e (nrepl-dict-get d "err"))
         (v (nrepl-dict-get d "value")))
    (if e
        (message e)
      (kill-new v))))

(defun clear-repl-properly ()
  (interactive)
  (ignore-errors
    (with-current-buffer (cider-current-repl-buffer)
      (cider-repl-return)
      (cider-repl-clear-buffer)
      (cider-repl-return)
      (end-of-buffer))))

(define-key cider-mode-map (kbd "C-c C-o") 'clear-repl-properly)
