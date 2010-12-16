(defun ruby-eval-buffer () (interactive)
  "Evaluate the buffer with ruby."
  (shell-command-on-region (point-min) (point-max) "ruby"))

(require 'yari)
(defun my-ruby-mode-hook ()
  (local-set-key [return] 'reindent-then-newline-and-indent)
  (define-key ruby-mode-map "\C-c\C-a" 'ruby-eval-buffer)
  (local-set-key [(control f1)] 'yari-anything)
  (setq indent-tabs-mode nil))

(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)

(require 'flymake-ruby)
(add-hook 'ruby-mode-hook 'flymake-ruby-load)
 
(add-to-list 'load-path "~/.emacs.d/plugins/cucumber-mode")
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))

(require 'rspec-mode)
(add-hook 'rspec-mode-hook
          #'(lambda ()
              (setq yas/mode-symbol 'rspec-mode)))

;;(smart-tabs-advice ruby-indent-line ruby-indent-level)
(require 'haml-mode)
(add-hook 'haml-mode-hook 
		  '(lambda () 
			 (setq indent-tabs-mode nil)
			 (define-key haml-mode-map "\C-m" 'newline-and-indent)))

(require 'sass-mode)

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
		  '(lambda ()
			 (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


;; Rinari
;;(add-to-list 'load-path "/home/morris/Stuff/emacs/rinari")
;;(require 'rinari)

