(defconst SPLASH-WIDTH 65)

(switch-to-buffer
 (set-buffer (get-buffer-create "splash")))

(defun recenter-splash ()
  (let ((padding-width (/ (- (window-body-width) SPLASH-WIDTH -1) 2)))
    (if (< (window-body-width) SPLASH-WIDTH)
        (setq padding-width 0)
      (goto-char (point-min))
      (while (search-forward-regexp "^[[:space:]]*" nil t)
        (replace-match (make-string padding-width ? ))))))

(defun splash ()
  (when (string= (buffer-name) "splash")
    (read-only-mode -1)
    (kill-region (point-min) (point-max))
    (insert (f-read-text "~/splash-text"))
    (recenter-splash)
    (whitespace-mode -1)
    (read-only-mode t)))

(defun new-splash ()
  (switch-to-buffer
   (set-buffer (get-buffer-create "splash")))
  (splash))

(add-hook 'after-make-frame-functions (lambda (-) (new-splash)))
(add-hook 'server-after-make-frame-hook (lambda () (new-splash)))
(add-hook 'window-size-change-functions (lambda (-) (splash)))

(splash)

(provide 'splash-screen)
