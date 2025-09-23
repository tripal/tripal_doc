
chado_db_select() is deprecated in favour of the Tripal DBX Query API
==============================================================================

- **Deprecated in** tripal 4.0.0-alpha2
- **Removed in** tripal 4.0.0
- **Issue** `#1314 <https://github.com/tripal/tripal/issues/1341>`_
- **PR** `#1296 <https://github.com/tripal/tripal/pull/1926>`_

The `chado_db_select()` extended the `db_* procedural functions of the Database API (since deprecated) <https://www.drupal.org/node/2993033>`_ to support Chado. The Drupal versions of these methods were deprecated in Drupal 8.0.x and removed before Drupal 9.0.0. As mentioned in the linked Drupal Change record these methods were replaced by the modern object-oriented `Drupal Database API <https://www.drupal.org/docs/develop/drupal-apis/database-api>`_. As such, `chado_db_select()` is replaced by `Tripal DBX <>`_ which is Tripal's extension of the Drupal Database API.

chado_db_select()
-------------------

**Before:**

.. code-block:: php

  $query = chado_db_select('feature', 'f');

**After:**

.. code-block:: php

  $query = \Drupal(tripal_chado.database)->select('1:feature', 'f');
