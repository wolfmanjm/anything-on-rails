(defvar anything-c-source-git-project-files
      '((name . "Files from Current GIT Project")
	(init . 
		  (lambda () 
			(setq anything-git-top-dir 
				  (magit-get-top-dir 
				   (if (buffer-file-name)
					   (file-name-directory (buffer-file-name))
					 default-directory)))))
	(candidates . 
				(lambda ()
				  (if anything-git-top-dir
					  (let ((default-directory anything-git-top-dir))
						(mapcar (lambda (file) 
								  (concat default-directory file)) 
								(magit-shell-lines (magit-format-git-command "ls-files" nil)))))))
	(requires-pattern . 4)
	(delayed)
	(type . file)))
