
Upgrading from Tripal 3 to Tripal 4
=====================================

The switch from Tripal 3 to Tripal 4 corresponds with the move from Drupal 7 to Drupal 10. Over this period Drupal changed its upgrade approach from (a) non-backwards compatible between major versions requiring a complete rewrite to (b) rolling deprecation notices where old/new implementations can exist alongside for a time. **While this does mean the switch from Tripal 3 to Tripal 4 is a complete rewrite, this should be the last time we need to do such a large overhaul.**

The following documentation is meant to guide you in this upgrade of your extension modules.

.. toctree::
   :maxdepth: 2

   module_dev/overview
   module_dev/db_queries
   module_dev/views
   module_dev/useful_snippets
