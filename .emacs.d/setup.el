(add-to-list 'exec-path "/usr/local/bin")
(setenv "PATH" (concat "/usr/local/bin" ":" (getenv "PATH")))

(package-initialize)

(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))

(defun load-user-file (file)
  (interactive "f")
  "Load file in user's configuration directory"
  (load (expand-file-name file user-init-dir)))

;; Global must be loaded first
(load-user-file "global.el")
(load-user-file "company.el")
(load-user-file "c.el")
(load-user-file "commonlisp.el")
(load-user-file "haskell.el")
(load-user-file "cpp.el")
(load-user-file "rust.el")
(load-user-file "org.el")
(load-user-file "zone.el")
(load-user-file "clojure.el")
(load-user-file "magit.el")
(load-user-file "emacslisp.el")
