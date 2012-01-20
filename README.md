# A brain-dead replacement for svn:externals (and soon Git submodules)

Mainly, <tt>xtrn</tt> doesn't depend on the revision control system. This means that you can pull in code from heterogeneous systems with a single command.

Just create an <tt>Externals</tt> file in the root of your project, require the <tt>xtrn</tt> gem and run <tt>xtrn</tt> (again, in the root of
your project).

The format of the <tt>Externals</tt> file is as follows, note that the username and password will not be cached:

    ---
    - url: svn://svnhost/dir/to/external/codebase
      path: checkout/to/here
      type: svn
      username: optional_username
      password: optional_password
    - url: svn://svnhost2/another/thing
      path: this/one/goes/here
      type: svn
