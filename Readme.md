Anything On Rails
==========

I like the various rails plugins on emacs, but for what I want they
are too heavy.

I use [Anything](http://www.emacswiki.org/emacs/Anything) in Emacs a
lot, and for things like quick navigation I think it is all I need.

So here is a very lightweight Anything Source that shows all the major
files in a rails project, so navigation is pretty easy. It is called
anything-rails and can be bound to any key you like, or added to
your default set of sources. It does nothing if it does not detect it
is in a rails directory structure.

Basically you invoke anything-rails, and if it is in a rails
directory it gathers all the major rails files from app, config, specs
and groups them for display. Using the anything-match-plugin you can
very quickly find what you want.

For instance to find a model called pet.rb you type `mod pet`, the mod will
match all models and pet will hone in on the pet.rb model. You can do
the same with views, type `vie pets show` it will first filter all the
views, then the pets views then the show view. This makes navigation
pretty easy, not quite as nice as going directly to the view from the
controller but ok. The navigation in most of the rails major modes
seems pretty flaky anyway.

I also modified [RubyKitchs](http://www.emacswiki.org/emacs/rubikitch)
anything Rake source so you can run rake tasks pretty easily too, I
modified it to run the rake task in a ruby-compilation window though
so errors can be clicked on properly.

I'll be adding stuff to this as needed, but I want to keep it small,
and not compete with Rinari or rails-mode-reloaded.

The vendor directory has recent copies of the third party libs I use,
like the anything.el etc.

If you use TAGS then 
`(global-set-key (kbd "M-.") 'anything-etags-select-from-here)` and you can lookup anything that is
in the TAGS file.

Also included is a setup-ruby.el and setup-anything.el that I call from my
`init.el` to setup the various things I use for ruby/rails development.

There is a dependency on magit if you use the anything-git.
