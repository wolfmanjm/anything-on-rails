;;; anything-rails.el --- 

;; Copyright (C) 2010 Jim Morris

;; Author: Jim Morris <morris@wolfman.com>
;; Version: 0.1
;; URL: http://blog.wolfman.com

;; This file is not currently part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program ; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.
;;
;;; depends on
;; find-cmd
;; anything
;; anything-config
;;
;;; Commentary:
;;
;; An anything source that shows major files in a rails project
;;


(require 'find-cmd)
(require 'ruby-compilation)

(eval-when-compile
  (defvar anything-project-root))

;;
;; Handle anything integration with rails project view
;;

(defvar rails-directories
  (list "app" "spec" "config" "lib")
  "List of directories in rails root to search for files")

(defun rails-make-displayable-name (path)
  "makes path into a displayable name. eg view(post): file, model: file, controller: name"
  (let ((dir (file-name-directory path))
		(name (file-name-nondirectory path)))
	(let
		((type (cond 
			   ((string-match "/app/views/\\([a-zA-Z0-9_]+\\)/" dir)
				(concat "view(" (match-string 1 dir) ")"))
			   ((string-match "/app/controllers/.*/\\([a-zA-Z0-9_]+\\)Controller" dir) "controller")
			   ((string-match "/app/models/" dir) "model")
			   ((string-match "/config/\\([a-zA-Z0-9_]+\\)/" dir)
				(concat "config(" (match-string 1 dir) ")"))
			   ((string-match "/config/" dir) "config(root)")
			   ((string-match "/spec/\\([a-zA-Z0-9_]+\\)/" dir)
				(concat "spec(" (match-string 1 dir) ")"))
			   ((string-match "/spec/" dir) "spec(root)")
			   ((string-match "/app/helpers/" dir) "helper")
			   ((string-match "/app/mailers/" dir) "mailer")
			   ((string-match "/app/\\([a-zA-Z0-9_]+\\)/" dir) (match-string 1 dir))
			   (t "misc file"))))
	
	  (concat type ": " name))))

(defun rails-dirs (root)
  "Returns list of directories to search in rails, skips ones that do not exist" 
  (mapconcat (lambda (x) (if (file-directory-p x) x "" ))
			 (mapcar (lambda (x) (concat root x)) rails-directories )
			 " "))
  

(defun rails-list-project-files ()
  "Returns a list of all files found under the rails project."

  ;; find root of project return empty list if not a rails project
  ;; checks for Gemfile in the RAILS_ROOT and for config/application.rb (Rails3)
  (let ((rails-project-root (locate-dominating-file default-directory "Gemfile")))
	(when (and rails-project-root
			   (file-exists-p (concat rails-project-root "config/application.rb")))
	  ;; get a list of all the relevant files
	  (let ((rails-project-files-list (split-string 
									   (shell-command-to-string 
										(concat "find " (rails-dirs rails-project-root) 
												" "
												(find-to-string 
												 '(prune (name ".svn" ".git"))) 
												" "
												(find-to-string 
												 `(or (name "*.rb" "*.haml" "*.erb" "*.yml"))))))))

		;; convert the list into cons pair of (display . filepath) where
		;; display is a friendly name
		(mapcar
		 (lambda (f)
		   (cons (rails-make-displayable-name f) f)) rails-project-files-list)))))


;; anything source for showing all rails project files
(defvar anything-c-source-rails-project-files
  '((name . "Files in Rails Project")
	(candidates . (lambda () (rails-list-project-files)))
	(match anything-c-match-on-file-name)
    (type . file)))

;;
;; Rake task modified to run in a ruby-compile window 
;; original by http://www.emacswiki.org/emacs/rubikitch
;;
(defvar anything-current-buffer nil)
(defadvice anything (before get-current-buffer activate)
  (setq anything-current-buffer (current-buffer)))

(defvar anything-c-source-rake-task
	  '((name . "Rake Task")
		(candidates . (lambda ()
						(cons '("rake" . "default")
							  (mapcar (lambda (line)
										(cons line (second (split-string line " +"))))
									  (with-current-buffer anything-current-buffer
										(split-string (shell-command-to-string "rake -s -T") "\n" t))))))
	
		(action ("Rake" .(lambda (c) (ruby-compilation-rake c)))
				("Rake with command-line edit" . (lambda (c) (ruby-compilation-rake t (concat c " ")))))))


(defun rake ()
  "Uses Anything to show and execute rake tasks"
  (interactive)
  (let* ((anything-execute-action-at-once-if-one nil)
		 (anything-quit-if-no-candidate nil))
	(if (locate-dominating-file default-directory "Rakefile")
		(anything '(anything-c-source-rake-task))
	  (message "No Rakefile available"))))
  

(provide 'anything-rails)
