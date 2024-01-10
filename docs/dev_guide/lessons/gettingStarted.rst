
Upgrading a Module
==================

Upgrading a module from Drupal 7 to Drupal 10 and beyond can be accomplished by following the following instructions.

The initial building of a module template can be performed using `drush generate`. Some notes below will indicate certain options you can use, depending on your module.

Github Recommendation
---------------------

The Tripal team recommends creating a new empty branch in your Github or Gitlab repository, generating the template, and then moving over functionality. Rather than creating a new branch and deleting all of your old code, the `--orphan` argument can be used to create a fresh branch free of all files and history:

  .. code:: 

    git switch --orphan <new branch>


More text