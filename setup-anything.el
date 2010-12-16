(require 'anything)
(require 'anything-config)
(require 'anything-match-plugin)
(require 'anything-etags)
(require 'anything-rails)
(load "anything-in-git")

(global-set-key [f11] 'my-anything)
(global-set-key [(meta f11)] 'anything-resume)
(global-set-key (kbd "M-.") 'anything-etags-select-from-here)

(defun my-anything ()
  "My Anything command"
  (interactive)
  (anything-other-buffer
   '(anything-c-source-fixme 
	 anything-c-source-buffers+ 
	 anything-c-source-rails-project-files 
	 anything-c-source-files-in-current-dir+ 
	 anything-c-source-git-project-files
	 anything-c-source-bookmarks )
   "*my-anything*"))

(defun anyman ()
  "anything man"
  (interactive)
  (anything-man-woman))


