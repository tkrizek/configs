;; -*-no-byte-compile: t; -*-
(setq load-prefer-newer t)


;; === Packages ===
;; Add MELPA repository.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Use helm for completion.
(require 'helm-config)


;; === Keyboard macros ===

(fset 'rgrep-next
   [?\C-x ?o tab return])
(put 'rgrep-next 'kmacro t)

(fset 'rgrep-prev
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 111 S-iso-lefttab return] 0 "%d")) arg)))
(put 'rgrep-prev 'kmacro t)


;; === Key bindings ===
;; custom keybindings
(global-set-key (kbd "<f3>") 'rgrep)
(global-set-key (kbd "C-x M-f") 'helm-projectile)
(global-set-key (kbd "<next>") 'scroll-up-command)
(global-set-key (kbd "<prior>") 'scroll-down-command)
(global-set-key (kbd "<f5>") 'rgrep-next)
(global-set-key (kbd "<f6>") 'rgrep-prev)

;; --- custom functions ---
;; match all lines beginning with class or def
(global-set-key (kbd "M-\\")
		(lambda (&optional nlines)
		  (interactive "P")
		  (occur "^[[:space:]]*\\(class\\|def\\) " nlines)))


;; === Editor behaviour ===
;; Set the paragraph width for M-q to 79 characters.
(setq-default fill-column 79)

;; Keep more context when scrolling
(setq next-screen-context-lines 10)

;; Never show startup screen.
(setq inhibit-startup-screen t)

;; Show line numbers
(global-linum-mode t)

;; Reload open buffers when changed.
(global-auto-revert-mode t)


;; === Elpy ===
;; Load elpy environment for Python editing.
(elpy-enable)

;; elpy enhance goto-definition
(defun goto-def-or-rgrep ()
  "Go to definition of thing at point or do an rgrep in project if that fails"
  (interactive)
  (condition-case nil (elpy-goto-definition)
    (error (elpy-rgrep-symbol (thing-at-point 'symbol)))))
(define-key elpy-mode-map (kbd "M-.") 'goto-def-or-rgrep)


;; === TRAMP ===
;; Set TRAMP to use SSH as default
(setq tramp-default-method "ssh")

;; Vagrant TRAMP plugin
;; to edit files in vagrant boxes remotely
;; https://github.com/dougm/vagrant-tramp
;;(add-to-list 'load-path "~/.emacs.d/vagrant-tramp/")
;;(load "vagrant-tramp")

;; Ignore Version control for remote files
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))


;; === Autosave ===
;; Place all auto-save files in temp directory.
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; === Color Theme ===
;; Some autogenerated mumbo jumbo for color theme
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (sanityinc-solarized-light)))
 '(custom-safe-themes
   (quote
    ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(package-selected-packages
   (quote
    (persistent-soft ergoemacs-mode ldap-mode helm-projectile helm yaml-mode vagrant-tramp haskell-mode elpy color-theme-sanityinc-solarized)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(menu-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
)
