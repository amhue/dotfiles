(menu-bar-mode -1)
(tool-bar-mode -1)
(tab-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode t)

(ido-mode t)
(setq ido-everywhere t)

(set-face-attribute 'default nil :font "RecMonoLinear Nerd Font 11")
(setq default-frame-alist '((font . "RecMonoLinear Nerd Font 11")))
(set-fontset-font t 'bengali (font-spec :family "Akaash"))

(add-hook 'text-mode-hook 'display-line-numbers-mode)
(add-hook 'conf-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq display-line-numbers-type 'relative)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(put 'narrow-to-region 'disabled nil)

;; install aspell-en for flyspell
(setq package-selected-packages
      '(lsp-mode lsp-treemacs lsp-java magit
                 hydra flycheck company which-key dap-mode nerd-icons-completion
                 rainbow-delimiters lua-mode modus-themes java-snippets
                 doom-modeline clang-format prettier-js undo-tree
                 yasnippet flyspell-correct python-black nasm-mode
                 pyvenv lsp-pyright pdf-tools nov))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq lsp-file-watch-threshold nil)

(require 'company)
(add-hook 'prog-mode-hook #'company-mode)

(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-auto-guess-root t))

(add-to-list 'load-path "/home/aritr/.emacs.d/lisp/")
(require 'projects)
(require 'splash-screen)
;; (add-hook 'after-make-frame-functions (lambda (frame) (splash)))
(add-hook 'window-size-change-functions (lambda (-) (splash)))

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1))

(setenv "PATH" (concat (getenv "PATH") ":/home/aritr/opt/bin"))

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'js-mode-hook 'lsp)
(add-hook 'html-mode-hook 'lsp)
(add-hook 'css-mode-hook 'lsp)
(add-hook 'lua-mode-hook (lambda ()
                           (lsp)
                           (add-hook 'before-save-hook (lambda ()
                                                         (lsp-format-buffer)))))
(add-hook 'python-mode-hook 'lsp)
(add-hook 'python-mode-hook 'python-black-on-save-mode)

(defun java-setup ()
  (add-hook 'before-save-hook (lambda ()
                                (lsp-java-organize-imports)))
  (clang-format-on-save-mode)
  (lsp)
  (setq lsp-java-java-path "/usr/lib/jvm/java-24-openjdk/bin/java")

  (setq lsp-java-configuration-runtimes
        '(
          :name "JavaSE-25"
          :path "/usr/lib/jvm/java-25-openjdk"
          :default t)))

(with-eval-after-load 'lsp-java
  (defun lsp-java--ls-command ()
    '("/sbin/jdtls")))

(add-hook 'java-mode-hook 'java-setup)
(add-hook 'js-mode-hook (lambda ()
                          (prettier-js-mode)))
;; (setq lsp-javascript-preferences-import-module-specifier "relative")))
(add-hook 'html-mode-hook 'prettier-js-mode)
(add-hook 'css-mode-hook 'prettier-js-mode)
(add-hook 'c-mode-hook 'clang-format-on-save-mode)
(add-hook 'c++-mode-hook 'clang-format-on-save-mode)

(defalias 'yes-or-no-p 'y-or-n-p)

(add-to-list 'auto-mode-alist '("\\.asm\\'" . nasm-mode))

(require 'pdf-tools)
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode))

;; set icons
(require 'nerd-icons)
;; (nerd-icons-install-fonts)

;; use doom modeline
(doom-modeline-mode)
(setq word-wrap t)

(require 'flyspell-correct)
(require 'flyspell-correct-ido)
;; (add-hook 'prog-mode-hook 'flyspell-prog-mode)
(add-hook 'text-mode-hook 'flyspell-mode)
(global-set-key (kbd "M-$") 'flyspell-correct-wrapper)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-hook 'lsp-mode-hook #'yas-minor-mode)
  (require 'dap-cpptools))

(electric-pair-mode 1)

(global-set-key (kbd "C-c C-f") #'clang-format-buffer)
(global-set-key (kbd "C-c C-v") #'whitespace-mode)
(global-set-key (kbd "C-c RET") #'compile)
(global-set-key (kbd "C-c C-j") #'project-compile)
(global-set-key (kbd "C-c C-p") #'prettier-js)

(global-set-key (kbd "<right>") #'ignore)
(global-set-key (kbd "<left>") #'ignore)
(global-set-key (kbd "<up>") #'ignore)
(global-set-key (kbd "<down>") #'ignore)

(global-set-key (kbd "C-M-f") #'forward-word)
(global-set-key (kbd "C-M-b") #'backward-word)

(global-hl-line-mode 1)

(add-hook 'buffer-list-update-hook (lambda ()
                                     (if (string= (buffer-name) "splash")
                                         (progn
                                           (whitespace-mode -1)
                                           (goto-char (point-max)))
                                       (whitespace-mode t))))

(setq-default whitespace-style
              '(face spaces empty tabs space-mark tab-mark))

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

(global-undo-tree-mode)

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

;; (setq lsp-workspace-root "~/Documents/Projects/c/")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flyspell-incorrect ((t (:underline (:color "forest green" :style wave :position nil)))))
 '(hl-line ((t (:extend t :background "#141114")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi))
 '(custom-safe-themes
   '("5c9d44822a24dd257aa68635498a032134e0535578142eb4e294cd9c16af0db5"
     "01be51d3a575f5f565aca6485b135e39ad5662d071326bc38855154fd062fc32"
     "74ba8278e74fbd0826b137f3589500a830b91eb8911a8873f10a2857fc406eda"
     "6178b07d4098353ebccc6b2ae66368265dd9867e7119560f02cb79dbb96149e3"
     "292a7482026054ebf039036f5f0a8cb670dea0c76bb8d34b6c9d74e19db8a9bc"
     "fbf73690320aa26f8daffdd1210ef234ed1b0c59f3d001f342b9c0bbf49f531c"
     "2e7dc2838b7941ab9cabaa3b6793286e5134f583c04bde2fba2f4e20f2617cf7"
     default))
 '(highlight-indent-guides-method 'character)
 '(inhibit-startup-screen t)
 '(lsp-java-server-install-dir "/usr/share/java/jdtls")
 '(package-selected-packages
   '(clang-format company dap-mode doom-modeline flycheck
                  flyspell-correct hydra java-snippets lsp-java
                  lsp-mode lsp-treemacs lua-mode magit modus-themes
                  nasm-mode nerd-icons-completion nov prettier-js
                  python-black rainbow-delimiters undo-tree which-key
                  yasnippet))
 '(prettier-js-args
   '("--config" "/home/aritr/Documents/Projects/web/.prettierrc"))
 '(prettier-js-command "prettier")
 '(python-black-command "black"))
