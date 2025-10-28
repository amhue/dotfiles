(defun getdirs (directory)
  "Get directories in a directory"
  (setq files (directory-files directory t nil nil nil))
  (setq directories nil)

  (while files
    (setq file (car files))
    (setq files (cdr files))
    (when (and
           (file-directory-p file)
           (not (or (equal file (concat directory "."))
                    (equal file (concat directory "..")))))
      (setq directories (cons (list file) directories))))
  directories)

(setq tmp-buf (get-buffer-create "tmp-buf"))

(prin1 (append (getdirs "/home/aritr/Documents/Projects/c/")
               (getdirs "/home/aritr/Documents/Projects/cpp/")
               (getdirs "/home/aritr/Documents/Projects/java/")
               (getdirs "/home/aritr/Documents/Projects/lua/")
               (getdirs "/home/aritr/Documents/Projects/python/")
               (getdirs "/home/aritr/Documents/Projects/web/")) tmp-buf)

(save-current-buffer
  (set-buffer tmp-buf)
  (save-excursion
    (write-region (point-min) (point-max) "/home/aritr/.emacs.d/projects")))

(kill-buffer tmp-buf)

(provide 'projects)
