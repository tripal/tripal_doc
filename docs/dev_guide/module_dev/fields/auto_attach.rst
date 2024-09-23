Add Fields to Content Types
============================

In order for a field to be used, it needs to be added to a specific content type. This can be done through the "Manage Fields" interface for a given Content Type. More specifically, go to Tripal > Page Structure and then choose "Manage Fields" for the Content Type you want to add a field to.

This can also be done programmatically, however documentation for this is still being developed.

.. warning::

  This documentation is still being developed. In the meantime there are
  examples for programmatically adding TripalFields in the Tripal core codebase.
  Specifically, look in the Chado Preparer class in
  `tripal_chado/src/Task/ChadoPreparer.php`.
