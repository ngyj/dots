;;; user.el --- personnal config, called by init.el

;; windows specific things
(if (string-equal (getenv "OS") "Windows_NT")
    (progn (require 'server)
           (unless (server-running-p)
             (server-start))
           (setq visible-bell 1)))

;; nix-shell
(defun in-nix-shell ()
  (let (x (getenv "IN_NIX_SHELL"))
    (or (string-equal x "impure")
        (string-equal x "pure"))))

;; *scratch*
(setq initial-major-mode 'org-mode)

;; pretty
(set-frame-font "Fira Code")

(defun buffer-go ()
  (with-current-buffer (get-buffer "*scratch*")
    (let* ((wh (window-body-height))
           (h (if wh (/ wh 2) 1)))
      (end-of-buffer)
      (delete-region 1 (point))
      (insert (make-string h ?\n))))
  t)
(when window-system
  (setq initial-buffer-choice 'buffer-go))

;; ignore this infuriating at-point file search
;; https://emacs.stackexchange.com/a/5331
(setq ido-use-filename-at-point nil)
(setq ido-use-url-at-point nil)

(use-package doom-themes
  :ensure t
  :init
  (load-theme 'doom-solarized-light t)
  :config
  (doom-themes-org-config))

(use-package sublimity
  :ensure t
  :config
  (require 'sublimity-scroll)
  (require 'sublimity-attractive)
  (global-linum-mode -1)
  (sublimity-mode 1))

;;;;;;;;;;;;;; PL ;;;;;;;;;;;;;;
;; lisps
(global-prettify-symbols-mode 1)
(defun pretty-lambda-fun ()
  "make mostly for lisps"
  (setq prettify-symbols-alist
      '(("lambda" . 955)  ;; λ
        ;; ("->"     . 8594) ;; →
        ;; ("=>"     . 8658) ;; ⇒
        )))
(add-hook 'racket-mode-hook 'pretty-lambda-fun)
(add-hook 'elisp-mode-hook 'pretty-lambda-fun)
(add-hook 'scheme-mode-hook 'pretty-lambda-fun)

;; C
(defun my-flycheck-c-setup ()
  (setq flycheck-gcc-language-standard "c11"))
(add-hook 'c-mode-hook #'my-flycheck-c-setup)
(setq c-default-style "linux" c-basic-offset 2)

;(use-package clang-format
;  :ensure t
;  :init
;  (add-hook 'c++-mode-hook 'flycheck-mode)
;  :config
;  (add-hook 'c++-mode-hook
;            (function (lambda ()
;                        (add-hook 'before-save-hook
;                                 'clang-format-buffer nil t)))))
; (setq-default flycheck-disabled-checkers '(haskell-ghc haskell-stack-ghc haskell-hlint))
; ;; haskell
; (use-package yasnippet
;   :ensure t)
; (use-package lsp-mode
;   :ensure t
;   :hook (haskell-mode . lsp)
;   :commands lsp)
; (use-package lsp-ui
;   :ensure t
;   :commands lsp-ui-mode)
; (use-package lsp-haskell
;  :ensure t
;  :config
;  (setq lsp-haskell-server-path "haskell-language-server-wrapper")
;  (setq lsp-haskell-server-args'("-d"))
;  ;; Comment/uncomment this line to see interactions between lsp client/server.
;  ;;(setq lsp-log-io t)
; )

;; rust
(use-package rustic
  :ensure t
  :init
  :bind (:map rustic-mode-map
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  (setq lsp-eldoc-hook nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-signature-auto-activate nil)

  ; (setq rustic-format-on-save nil)
  ; (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)
  )
(defun rk/rustic-mode-hook ()
  (setq-local buffer-save-without-query t))


;; ocaml
(setq ngyj/merlin-site-elisp (getenv "MERLIN_SITE_LISP"))
(setq ngyj/utop-site-elisp (getenv "UTOP_SITE_LISP"))
(setq ngyj/ocp-site-elisp (getenv "OCP_INDENT_SITE_LISP"))

(use-package merlin
  :if (and ngyj/merlin-site-elisp
           (in-nix-shell))
  :load-path ngyj/merlin-site-elisp
  :hook
  (tuareg-mode . merlin-mode)
  (merlin-mode . company-mode)
  :custom
  (merlin-command "ocamlmerlin"))
(use-package utop
  :if (and ngyj/utop-site-elisp
           (in-nix-shell))
  :load-path ngyj/utop-site-elisp
  :hook
  (tuareg-mode . utop-minor-mode))
(use-package ocp-indent
  :if (and ngyj/ocp-site-elisp
           (in-nix-shell))
  :load-path ngyj/ocp-site-elisp)

;; nix
(use-package nix-mode
  :mode "\\.nix\\'")

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width 2)
            (setq python-indent 8)))
(add-hook 'css-mode-hook
          (lambda ()
            (setq css-indent-offset 2)))

;; agda
; (load-file (let ((coding-system-for-read 'utf-8))
;                (shell-command-to-string "agda-mode locate")))


(setq flymake-no-changes-timeout nil)
(setq flymake-start-syntax-check-on-newline nil)
; (setq flycheck-check-syntax-automatically '(save mode-enabled))

;; keybinds
(use-package evil
  :ensure t
  :config
  (evil-mode 1))
(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (call-process "xdg-open" nil 0 nil file)))

(define-key dired-mode-map (kbd "C-c o") 'dired-open-file)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(global-set-key "\C-c\C-k" 'describe-char)

; saving sessions
(defun load-desktop-default ()
  (interactive)
  (desktop-change-dir "~/.emacs.d/.#desktop#"))
(defun save-desktop-default ()
  (interactive)
  (desktop-save "~/.emacs.d/.#desktop#"))
(global-set-key (kbd "C-c r l") 'load-desktop-default)
(global-set-key (kbd "C-c r s") 'save-desktop-default)
