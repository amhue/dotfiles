(menu-bar-mode -1)
(tool-bar-mode -1)
(tab-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode t)

(setq ido-everywhere t)
(ido-mode)

(set-face-attribute 'default nil :font "CaskaydiaCove NFM 11")

(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq display-line-numbers-type 'relative)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; install aspell-en for flyspell
(setq package-selected-packages
      '(lsp-mode lsp-treemacs lsp-java magit
                 hydra flycheck company which-key dap-mode nerd-icons-completion
                 rainbow-delimiters lua-mode modus-themes
                 doom-modeline clang-format prettier-js undo-tree
                 yasnippet flyspell-correct))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(require 'company)
(add-hook 'prog-mode-hook #'company-mode)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'js-mode-hook 'lsp)
(add-hook 'html-mode-hook 'lsp)
(add-hook 'css-mode-hook 'lsp)
(add-hook 'lua-mode-hook 'lsp)
(add-hook 'python-mode-hook 'lsp)
(add-hook 'java-mode-hook 'lsp)
(add-hook 'js-mode-hook 'prettier-js-mode)
(add-hook 'html-mode-hook 'prettier-js-mode)
(add-hook 'css-mode-hook 'prettier-js-mode)
(add-hook 'c-mode-hook 'clang-format-on-save-mode)
(add-hook 'c++-mode-hook 'clang-format-on-save-mode)

;; set icons
(require 'nerd-icons)
;; (nerd-icons-install-fonts)

;; use doom modeline
(doom-modeline-mode)

(require 'flyspell-correct)
(require 'flyspell-correct-ido)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'text-mode-hook 'flyspell-mode)
(global-set-key (kbd "M-$") 'flyspell-correct-wrapper)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools))

(electric-pair-mode 1)

(global-set-key (kbd "C-c C-f") 'clang-format-buffer)
(global-set-key (kbd "C-c C-v") 'whitespace-mode)
(global-set-key (kbd "C-c RET") 'compile)
(global-set-key (kbd "C-c C-j") 'compile)
(global-set-key (kbd "C-c C-p") 'prettier-js)

(global-set-key (kbd "<right>") 'ignore)
(global-set-key (kbd "<left>") 'ignore)
(global-set-key (kbd "<up>") 'ignore)
(global-set-key (kbd "<down>") 'ignore)

(global-set-key (kbd "C-M-f") 'forward-word)
(global-set-key (kbd "C-M-b") 'backward-word)

;; hydra is so damn cool. i know i'm an idiot
(defhydra window-manip (global-map "C-c")
  "window"
  ("w" enlarge-window "up")
  ("s" shrink-window "down")
  ("a" shrink-window-horizontally "left")
  ("d" enlarge-window-horizontally "right"))

(defhydra window-move (global-map "C-c")
  "window"
  ("," switch-to-prev-buffer "left")
  ("." switch-to-next-buffer "right"))

(global-set-key (kbd "C-c t") 'tab-new)
(global-set-key (kbd "C-c e") 'tab-close)

(global-set-key (kbd "C-c C-t") 'tab-bar-mode)
(global-set-key (kbd "C-c f") 'treemacs-add-and-display-current-project-exclusively)

(global-set-key (kbd "C-c g") (lambda ()
                                (interactive)
                                (eww "https://www.google.com")))

(global-set-key (kbd "C-c C-w") 'eww)

(global-set-key (kbd "C-TAB") 'tab-next)
(global-set-key (kbd "S-C-TAB") 'tab-previous)

(global-set-key (kbd "C-x C-z") 'kill-buffer-and-window)

(add-hook 'text-mode-hook 'undo-tree-mode)
(add-hook 'prog-mode-hook 'undo-tree-mode)

(global-set-key (kbd "C-_") 'undo-tree-undo)
(global-set-key (kbd "M-_") 'undo-tree-redo)

(global-set-key (kbd "M-RET") 'lsp-find-definition)

;; god am i terrible at writing elisp
;; this small experiment took like 40 minutes
;; to write somewhat correctly
(global-set-key (kbd "C-c C-<return>")
                (lambda ()
                  (interactive)
                  (if (eq major-mode 'dired-mode)
                      (let ((input-from-user (read-directory-name "Enter directory name: ")))
                        (make-directory input-from-user)
                        (revert-buffer))
                    (ignore))))

(global-set-key (kbd "C-c SPC") 'company-complete)

(add-hook 'prog-mode-hook (lambda ()
                            (setq company-minimum-prefix-length 1)
                            (setq company-idle-delay 0.1)))

(defun set-icon-size ()
  (treemacs-resize-icons 16))
(add-hook 'after-init-hook 'set-icon-size)

(defun enmouse ()
  (interactive)
  (xterm-mouse-mode 1))

(defun dmouse ()
  (interactive)
  (xterm-mouse-mode 0))

(if (not (display-graphic-p))
    (enmouse))

(setq backup-directory-alist `(("." . "~/.emacs_backup")))
(setq undo-tree-history-directory-alist '(("." . "~/.emacs_undo")))

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flyspell-incorrect ((t (:underline (:color "forest green" :style wave :position nil))))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi))
 '(custom-safe-themes
   '("2e7dc2838b7941ab9cabaa3b6793286e5134f583c04bde2fba2f4e20f2617cf7" default))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(magit lsp-mode lsp-treemacs lsp-java hydra flycheck company which-key dap-mode nerd-icons-completion rainbow-delimiters lua-mode modus-themes doom-modeline clang-format prettier-js undo-tree)))
