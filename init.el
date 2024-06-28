(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-spell smartparens company-flx company-auctex company pdf-tools auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flyspell-incorrect ((t (:underline (:color "red" :style wave))))))

;; ;; AUCTEX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;; Enable RefTeX
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; Enable PDF mode by default
(setq TeX-PDF-mode t)

;; ;; PDF TOOLS
(pdf-tools-install)

;; Automatically annotate highlights
(setq pdf-annot-activate-created-annotations t)

;; Use midnight mode to switch pages at 12 PM and 12 AM
(setq pdf-view-midnight-colors '("#ffffff" . "#000000"))

;; Set the default page scaling
(setq pdf-view-display-size 'fit-page)

;; Automatically revert PDF buffers when the document changes
(add-hook 'pdf-view-mode-hook 'pdf-view-auto-slice-minor-mode)

;; Keybindings for PDF tools
(define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)

;; ;; AUCTEX with PDF-TOOLS
;; Add pdf-tools to the list of TeX viewers
(setq TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))

;; Select PDF Tools as the default PDF viewer
(setq TeX-view-program-selection '((output-pdf "PDF Tools")))

;; Enable synctex correlation
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method 'synctex)

;; Set the viewer function
(setq TeX-view-program-selection '((output-pdf "PDF Tools")))

;; Update PDF buffer after successful compilation
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; ;; COMPANY-AUCTEX
;; Enable company-mode globally
(add-hook 'after-init-hook 'global-company-mode)

;; Enable company-auctex
(require 'company-auctex)
(company-auctex-init)

;; Enable company-mode in LaTeX mode
(add-to-list 'auto-mode-alist '("\\.tex\\'" . LaTeX-mode))
(add-hook 'LaTeX-mode-hook 'company-mode)

;; Enable company-ispell for better English autocompletion
(require 'company-ispell)
;;(setq ispell-complete-word-dict "/usr/share/dict/words")
(setq ispell-complete-word-dict "/home/pc/dictionary")
(add-to-list 'company-backends 'company-ispell)


(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0.0)
(setq company-dabbrev-downcase 0)
(setq company-dabbrev-ignore-case t)
;;(add-to-list 'company-backends 'company-dabbrev)

(add-hook 'TeX-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '((company-auctex-labels company-auctex-bibs company-auctex-macros company-auctex-symbols company-auctex-environments)
                   company-ispell
                   (company-files company-keywords)
                   company-capf))))


;;(setq company-backends '((company-auctex :separate company-ispell )))
;;(setq company-backends '((:separate company-auctex company-ispell))


;; Require smartparens and enable smartparens globally
(require 'smartparens-config)
(smartparens-global-mode t)

;; Enable smartparens in LaTeX mode specifically
(add-hook 'LaTeX-mode-hook #'smartparens-mode)

;; Optional: Customize smartparens behavior for LaTeX
(sp-with-modes '(tex-mode plain-tex-mode latex-mode)
  (sp-local-pair "\\(" "\\)")
  (sp-local-pair "\\[" "\\]")
  (sp-local-pair "\\{" "\\}")
  ;; Add other LaTeX specific pairs if needed
  )

;; Enable Flyspell for text modes
(add-hook 'text-mode-hook
          (lambda ()
            (flyspell-mode 1)
            (flyspell-buffer)))

;; Enable Flyspell for comments and strings in programming modes
(add-hook 'prog-mode-hook
          (lambda ()
            (flyspell-prog-mode)
            (flyspell-buffer)))

;; Enable Flyspell for LaTeX mode
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (flyspell-mode 1)
            (flyspell-buffer)))

;; Set the spell-checking program and dictionary
(setq ispell-program-name "aspell") ;; or "hunspell"
(setq ispell-dictionary "english")  ;; specify your language

;; Customize the appearance of misspelled words


;; Optionally, enable Flyspell for plain TeX mode (if needed)
(add-hook 'TeX-mode-hook
          (lambda ()
            (flyspell-mode 1)
            (flyspell-buffer)))

;; Function to switch dictionary
(defun set-dictionary-to-english ()
  (interactive)
  (ispell-change-dictionary "english")
  (flyspell-buffer))

(defun set-dictionary-to-french ()
  (interactive)
  (ispell-change-dictionary "french")
  (flyspell-buffer))

;; Keybindings to switch dictionaries quickly
(global-set-key (kbd "C-c d e") 'set-dictionary-to-english)
(global-set-key (kbd "C-c d f") 'set-dictionary-to-french)


(defun my/package-list-to-file (file)
  "Write a list of installed packages to FILE."
  (interactive "FWrite package list to file: ")
  (with-temp-buffer
    (dolist (package package-activated-list)
      (insert (format "%s\n" package)))
    (write-region (point-min) (point-max) file)))

;; Example usage: M-x my/package-list-to-file RET ~/emacs-packages.txt RET

(defun my/install-packages-from-file (file)
  "Install packages listed in FILE."
  (interactive "fInstall packages from file: ")
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (while (not (eobp))
      (let ((package (intern (buffer-substring-no-properties
                              (line-beginning-position)
                              (line-end-position)))))
        (unless (package-installed-p package)
          (package-install package)))
      (forward-line 1))))


;; Function to setup company-mode in eshell
(defun my/eshell-setup-company ()
  ;; Enable company-mode
  (company-mode 1)
  ;; Remove company-ispell from backends in eshell
  (setq-local company-backends (remove 'company-ispell company-backends)))

;; Add the setup function to eshell-mode-hook
(add-hook 'eshell-mode-hook 'my/eshell-setup-company)
