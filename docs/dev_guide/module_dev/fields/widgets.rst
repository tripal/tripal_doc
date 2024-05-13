Field Widgets
===============

Implementing a ChadoWidgetBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When creating a new Tripal field, the class responsible for allowing
entry or editing of content by a site administrator is the "Widget" class.
This class extends the `ChadoWidgetBase` class.

Class Setup
`````````````
To create a new field, we will extend the `ChadoWidgetBase` class.
For a new field named `MyField` we would create a new file in our module here:
`src/Plugin/Field/FieldWidget/MyfieldWidget.php`
The following is a simple class example:

.. code-block:: php

  <?php

.. note::

  A good way to learn about fields is to look at examples of fields in the Tripal
  core codebase. Specifically, look in the
  `tripal_chado/src/Plugin/Field/FieldWidget` directory.

