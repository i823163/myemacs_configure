;;;;---------------------------------------------------------------------------
;; .emacs configuration file
;; author: Brad Settlemyer
;; tested on: XEmacs 20.7
;;            XEmacs 21.1.14
;;            XEmacs 21.4.4
;;            XEmacs 21.4.6
;;            GNU Emacs  20.4
;;            GNU Emacs  21.2
;;
; packages supported:
;;   time, cl, cc-mode, font-lock, ede, eieio, elib, jde, func-menu, 
;;   html-mode, semantic, speedbar, workshop, xml-mode
;;
;; last mod: 2009-06-22
;;;;---------------------------------------------------------------------------
 
;; General setup
(setq inhibit-splash-screen t)
(setq transient-mark-mode t)
(setq-default indent-tabs-mode nil)
(setq delete-key-deletes-forward t)
(setq mouse-yank-at-point t)
(line-number-mode t)
(column-number-mode t)
(setq make-backup-files nil)
;(xterm-mouse-mode t)

;; Font stuff for emacs versions that support it
;;  (this stuff seems to be the least portable, comment this stuff out if it
;;   prevents the config file from loading)
;;(set-default-font "Bitstream Vera Sans Mono-11")
(set-fontset-font (frame-parameter nil 'font)
      'han '("cwTeXHeiBold" . "unicode-bmp"))


;; Color scheme is set in customize section at bottom (dark or light)
;(defconst foreground-color "gray90")
;(defconst background-color "gray10")
;(defconst pointer-color "white")
;(defconst cursor-color "red3")

(defconst foreground-color "white")
(defconst background-color "black")
(defconst pointer-color "white")
(defconst cursor-color "white")


;; Setup save options (auto and backup) -- still buggy need new Replace func
(setq auto-save-timeout 2000)
(setq make-backup-files t)


;; Printing setup
(setq ps-n-up-printing 2)
(setq ps-print-header nil)


;; Global Key Bindings
(define-key global-map "\C-xw" 'what-line)
(define-key global-map "\C-z" 'undo)
(define-key global-map [delete] 'delete-char)
(define-key global-map [backspace] 'delete-backward-char)
(define-key global-map [f1] 'help-command)
(define-key global-map [f2] 'undo)
(define-key global-map [f3] 'isearch-forward)
(define-key global-map [f4] 'other-window)
(define-key global-map [f12] 'revert-buffer)
(define-key global-map [button4] 'previous-line)
(define-key global-map [button5] 'next-line)
(define-key global-map "\M-g" 'goto-line)


;; Isearch keymap bindings
(define-key isearch-mode-map [backspace] 'isearch-delete-char)


;; Setup time mode
(autoload 'display-time "time" "Display Time" t)
(condition-case err
    (display-time)
  (error (message "Unable to load Time package.")))
(setq display-time-24hr-format nil)
(setq display-time-day-and-date t)


;; Setup text mode
(add-hook 'text-mode-hook '(lambda() (auto-fill-mode 1)))
(add-hook 'text-mode-hook '(lambda() (setq fill-column 78)))


;; Setup psgml-mode
(setq sgml-indent-step 2)
(setq sgml-indent-data t)
(setq sgml-warn-about-undefined-entities nil)
(setq sgml-warn-about-undefined-elements nil)
(defun user-mail-address() "kenny.zlee@gmail.com")
(add-to-list 'auto-mode-alist '("\\.xsd$"    . xml-mode))


;; Setup Common Lisp mode
(condition-case err
    (require 'cl)
  (error (message "Unable to load Common Lisp package.")))


;; Setup C mode
(autoload 'c++-mode  "cc-mode" "C++ Editing Mode" t)
(autoload 'c-mode    "cc-mode" "C Editing Mode" t)
(autoload 'c-mode-common-hook "cc-mode" "C Mode Hooks" t)
(autoload 'c-add-style "cc-mode" "Add coding style" t)


;; Associate extensions with modes
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

;; Create my own coding style
;; No space before { and function sig indents 4 if argument overflow
(setq bws-c-style
      '((c-auto-newline                 . nil)
        (c-basic-offset                 . 4)
        (c-comment-only-line-offset     . 0)
        (c-echo-syntactic-information-p . nil)
        (c-hungry-delete-key            . t)
        (c-tab-always-indent            . t)
        (c-toggle-hungry-state          . t)
        (c-hanging-braces-alist         . ((substatement-open after)
                                          (brace-list-open)))
        (c-offsets-alist                . ((arglist-close . c-lineup-arglist)
                                           (case-label . 4)
                                           (substatement-open . 0)
                                           (block-open . 0) ; no space before {
                                           (knr-argdecl-intro . -)))
        (c-hanging-colons-alist         . ((member-init-intro before)
                                           (inher-intro)
                                           (case-label after)
                                           (label after)
                                           (access-label after)))
        (c-cleanup-list                 . (scope-operator
                                           empty-defun-braces
                                           defun-close-semi))))
        


;; Construct a hook to be called when entering C mode
(defun lconfig-c-mode ()
  (progn (define-key c-mode-base-map "\C-m" 'newline-and-indent)
         (define-key c-mode-base-map "\C-z" 'undo)
         (define-key c-mode-base-map [delete] 'c-hungry-delete-forward)
         (define-key c-mode-base-map [backspace] 'c-hungry-delete-backwards)
         (define-key c-mode-base-map [f4] 'speedbar-get-focus)
         (define-key c-mode-base-map [f5] 'next-error)
         (define-key c-mode-base-map [f6] 'run-program)
         (define-key c-mode-base-map [f7] 'compile)
         (define-key c-mode-base-map [f8] 'set-mark-command)
         (define-key c-mode-base-map [f9] 'insert-breakpoint)
         (define-key c-mode-base-map [f10] 'step-over)
         (define-key c-mode-base-map [f11] 'step-into)
         (c-add-style "Brad's Coding Style" bws-c-style t)))
(add-hook 'c-mode-common-hook 'lconfig-c-mode)


;; Setup font-lock syntax coloring package
(autoload 'font-lock-fontify-buffer "font-lock" "Fontify Buffer" t)
(condition-case err
    (progn (add-hook 'c-mode-common-hook 'font-lock-fontify-buffer)
           (add-hook 'emacs-lisp-mode-hook 'font-lock-fontify-buffer)
           (global-font-lock t))
  (error (progn
           (message "Could not customize colors, disabling colored fonts.")
           (setq-default font-lock-auto-fontify t))))


;; Setup Workshop, the Sun C++ ide integration package
(condition-case err
    (progn
      (setq load-path (append load-path '("/opt/SUNWspro/lib")))
      (require 'workshop))
  (error (message "Unable to load Sun Workshop package.")))


;; Setup JDE, the Java Development Environment for Emacs
;; Add load paths to development versions of jde
(defun lconfig-jde-mode-hook ()
  (progn (define-key jde-mode-map "\M-." 'jde-complete-at-point-menu)
         (define-key jde-mode-map "\M-," 'jde-complete-at-point)
         (define-key jde-mode-map [f4] 'speedbar-frame-mode)
         (define-key jde-mode-map [f5] 'next-error)
         (define-key jde-mode-map [f6] 'jde-run)
         (define-key jde-mode-map [f7] 'jde-compile)
         (define-key jde-mode-map [f8] 'set-mark-command)
         (define-key jde-mode-map [f9] 'insert-breakpoint)
         (define-key jde-mode-map [f10] 'step-over)
         (define-key jde-mode-map [f11] 'step-into)
         (setq c-basic-offset 4)))

(autoload 'jde-mode "jde" "JDE mode" t)
(condition-case err
    (progn (add-to-list 'auto-mode-alist '("\\.java$" . jde-mode))
;    (progn (add-to-list 'auto-mode-alist '("\\.java$" . java-mode))
           (setq jde-complete-use-menu nil)
           (add-hook 'jde-entering-java-buffer-hook 'lconfig-jde-mode-hook)
           (add-hook 'jde-mode-hook 'lconfig-jde-mode-hook))
  (error (message "Unable to load JDEE package.")))


;; Setup CPerl mode
(setq cperl-brace-offset -4)
(setq cperl-indent-level 4)


;; Setup Assembler mode
(defun lconfig-asm-mode-hook ()
  (progn (setq comment-column 36)
         (setq tab-stop-list '(4 8 12 16 20 24 28 36 40 44 48))))
(add-hook 'asm-mode-hook 'lconfig-asm-mode-hook)
(add-to-list 'auto-mode-alist '("\\.s$" . asm-mode))
(add-to-list 'auto-mode-alist '("\\.asm$" . asm-mode))


;; Setup imenu
(add-hook 'c-mode-common-hook 'imenu-add-menubar-index)


;; Setup func-menu, the function menu quicklink package (XEmacs only)
(autoload 'function-menu "func-menu" "Load the parsing package" t)
(autoload 'fume-add-menubar-entry "func-menu" "Add function menu" t)
(autoload 'fume-list-functions "func-menu" "List functions in window" t)
(autoload 'fume-prompt-function-goto "func-menu" "Goto function" t)
(setq fume-max-items 35)
(setq fume-fn-window-position 3)
(setq fume-auto-position-popup t)
(setq fume-display-in-modeline-p t)
(setq fume-menubar-menu-location "Info")
(setq fume-buffer-name "Function List*")
(setq fume-no-prompt-on-valid-default nil)
;(global-set-key [f8] 'function-menu)
;(define-key global-map "\C-cl" 'fume-list-functions)
;(define-key global-map "\C-cg" 'fume-prompt-function-goto)
(condition-case err
    (progn (function-menu)
           (add-hook 'c-mode-common-hook 'fume-add-menubar-entry))
  (error (message "Unable to load Function Menu package")))


;; Setup imenu
;(setq imenu-sort-function 'imenu--sort-by-name)
;(setq imenu-max-items 45)
;(define-key global-map "\C-cj" 'imenu)

;; Setup speedbar, an additional frame for viewing source files
(autoload 'speedbar-frame-mode "speedbar" "Popup a speedbar frame" t)
(autoload 'speedbar-get-focus "speedbar" "Jump to speedbar frame" t)
(autoload 'speedbar-toggle-etags "speedbar" "Add argument to etags command" t)
(setq speedbar-frame-plist '(minibuffer nil
                             border-width 0
                             internal-border-width 0
                             menu-bar-lines 0
                             modeline t
                             name "SpeedBar"
                             width 24
                             unsplittable t))
(condition-case err
    (progn (speedbar-toggle-etags "-C"))
  (error (message "Unable to load Speedbar package.")))


;; GNU specific general setup
(if (not (featurep 'xemacs))
  (condition-case err
      (progn (set-scroll-bar-mode 'right)
             (global-font-lock-mode t))
    (error (message "Not running GNU emacs 20.4 or above."))))

;; Setup ned mode
(autoload 'ned-mode "ned" "NED mode" t)
(setq auto-mode-alist (cons '("\\.ned\\'" . ned-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.msg\\'" . ned-mode) auto-mode-alist))

;; Setup my own packages
(add-to-list 'load-path (expand-file-name "~/elisp/"))
(autoload 'cpp-font-lock "cpp-mode" "CPP Font Lock mode" t)

;; Add final message so using C-h l I can see if .emacs failed
(message ".emacs loaded successfully.")

;; setup the frame size of the emacs
(setq initial-frame-alist '((top . 10) (left . 30) (width . 200) (height . 100)))

;;setup the color themes loading to be sunburst
(add-to-list 'load-path "/home/kenny/.emacs.d/color-themes/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-tm)

;;
(load-file "~/.emacs.d/cedet/common/cedet.el")
(add-to-list 'load-path "/home/kenny/.emacs.d/cedet/common/")
(global-ede-mode 1)                      ; Enable the Project management system
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)            ; Enable template insertion menu



;;install elib which is required for other system


(add-to-list 'load-path "/home/kenny/.emacs.d/elib/")
(add-to-list 'load-path "/home/kenny/.emacs.d/jdee/lisp")
(add-to-list 'load-path "/home/kenny/.emacs.d/jdee/etc")
(add-to-list 'load-path "/home/kenny/.emacs.d/jdee/java")

(require 'jde)

;;install ecb file from the folder
(add-to-list 'load-path "/home/kenny/.emacs.d/ecb-snap/")
(load-file "~/.emacs.d/ecb-snap/ecb.el")

(require 'ecb-autoloads)




(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-source-path (quote (("/" "/") ("/home/kenny/applications" "apps")))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
