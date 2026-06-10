Field Formatters
==================

Implementing a ChadoFormatterBase Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
When creating a new Tripal field, the class responsible for displaying
information to the site users is the "Formatter" class.
This class extends the `ChadoFormatterBase` class.

To illustrate with a simple example, we will create a simple field to display the
organism's scientific name on a germplasm page.
We earlier created a property to store this, ``organism_scientific_name``,
so the formatter will use the value from that property.

Formatter Class Setup
```````````````````````
To create a new field, we will extend the `ChadoFormatterBase` class.
For a new field named `MyField` we would create a new file in our module here:
`src/Plugin/Field/FieldFormatter/MyfieldFormatter.php`
The following is a simple class example:

.. code-block:: php

  <?php
  namespace Drupal\tripal_chado\Plugin\Field\FieldFormatter;

  use Drupal\Core\Field\FieldItemListInterface;
  use Drupal\Core\StringTranslation\TranslatableMarkup;
  use Drupal\tripal\TripalField\Attribute\TripalFieldFormatter;
  use Drupal\tripal_chado\TripalField\ChadoFormatterBase;

  /**
   * Plugin implementation of an organism scientific name formatter.
   */
  #[TripalFieldFormatter(
    id: 'my_field_formatter',
    label: new TranslatableMarkup('Organism scientific name formatter'),
    description: new TranslatableMarkup('A chado organism scientific name formatter'),
    field_types: [
      'my_field',
    ],
    valid_tokens: [
      '[genus]',
      '[species]',
    ],
  )]
  class MyFieldFormatter extends ChadoFormatterBase {

    /**
     * {@inheritdoc}
     */
    public static function defaultSettings() {
      $settings = parent::defaultSettings();
      return $settings;
    }

    /**
     * {@inheritdoc}
     */
    public function viewElements(FieldItemListInterface $items, $langcode) {
      $elements = [];
      $list = [];
      $lookup_manager = \Drupal::service('tripal.tripal_entity.lookup');

      foreach ($items as $delta => $item) {
        $values = [
          'entity_id' => $item->get('entity_id')->getString(),
          'scientific_name' => $item->get('organism_scientific_name')->getString(),
        ];

        // Create a clickable link to the corresponding entity when one exists.
        $renderable_item = $lookup_manager->getRenderableItem($values['scientific_name'], $values['entity_id']);

        $list[$delta] = $renderable_item;
      }

      // If only one element has been found, don't make into a list.
      if (count($list) == 1) {
        $elements = $list;
      }
      // If more than one value has been found, display all values in an
      // unordered list.
      elseif (count($list) > 1) {
        $elements[0] = [
          '#theme' => 'item_list',
          '#list_type' => 'ul',
          '#items' => $list,
          '#wrapper_attributes' => ['class' => 'container'],
        ];
      }

      return $elements;
    }

  }

Below is a line-by-line explanation of each section of the code snippet above.

Formatter Namespace and Use Statements
````````````````````````````````````````

The following should always be present and specifies the namespace for this
field.

.. code-block:: php

  namespace Drupal\mymodule\Plugin\Field\FieldFormatter;


.. note::

  Be sure to change `mymodule` in the `namespace` to the name of your module.

.. warning::

  If you misspell the `namespace` your field will not work properly.

The following "use" statements are required for all Chado fields.

.. code-block:: php

  use Drupal\Core\StringTranslation\TranslatableMarkup;
  use Drupal\tripal\TripalField\Attribute\TripalFieldFormatter;
  use Drupal\tripal_chado\TripalField\ChadoFormatterBase;

Unless you are sure that your field will only handle a single value in all
cases, you will likely want the following use statement to allow the
formatter to handle a list of multiple items.

.. code-block:: php

  use Drupal\Core\Field\FieldItemListInterface;

Formatter Attribute Section
`````````````````````````````
The attribute section in the class file is the set of lines wrapped inside ``#[ ]``.
The attribute section is required.
This section is similar to the attribute section in the previous Type class.
Note the ``field_types`` attribute, which specifies what field types this formatter can be used
for. This should match the ``id`` attribute in the Type class.

.. code-block:: php

  /**
   * Plugin implementation of an organism scientific name formatter.
   */
  #[TripalFieldFormatter(
    id: 'my_field_formatter',
    label: new TranslatableMarkup('Organism scientific name formatter'),
    description: new TranslatableMarkup('A chado organism scientific name formatter'),
    field_types: [
      'my_field',
    ],
    valid_tokens: [
      '[genus]',
      '[species]',
    ],
  )]

.. note::

   Multiple formatters can exist for a given field, and the site
   administrator can select which formatter is appropriate for a
   particular content type.

.. warning::

   If the attribute section is not present, has misspellings, or is not
   complete, the field will not be recognized by Drupal.

Formatter Class Definition
````````````````````````````

Next, the class definition line must extend the `ChadoFormatterBase` class. You
must name your class the same as the filename in which it is contained (minus
the `.php` extension).

.. code-block:: php

  class MyFieldFormatter extends ChadoFormatterBase {

.. warning::

    If you misspell the class name such that it is not the same as the filename
    of the file in which it is contained, then the field will not be recognized by
    Drupal.

The defaultSettings() Function
````````````````````````````````
This is an optional function. If your field requires some additional settings
for content display. An example might be how many decimal places to display
for a real number. This example does not add any settings.

.. code-block:: php

  public static function defaultSettings() {
    $settings = parent::defaultSettings();
    return $settings;
  }

The viewElements() Function
`````````````````````````````

The `viewElements()` function is used to retrieve one or more property types
managed by this field, and prepare them for display. Our example will just display
a single value, but some fields can be configured for a cardinality greater than
one, meaning multiple values may be present, so the values can be made into a
list or a table as appropriate.

In the example code block below you can see the steps where the property values
are retrieved from the ``$items`` array..

.. code-block:: php

    public function viewElements(FieldItemListInterface $items, $langcode) {
      $elements = [];
      $list = [];
      $lookup_manager = \Drupal::service('tripal.tripal_entity.lookup');

      foreach ($items as $delta => $item) {
        $values = [
          'entity_id' => $item->get('entity_id')->getString(),
          'scientific_name' => $item->get('organism_scientific_name')->getString(),
        ];

Then for each retrieved item, we convert the returned value into a
`render array <https://www.drupal.org/docs/drupal-apis/render-api/render-arrays>`_
item using the `tripal.tripal_entity.lookup` service. When possible, the item
includes a link to the corresponding organism entity page, and if not, then
plain markup is generated. Either way, it is then added to the array 
``$list`` of values to display.

.. code-block:: php

        // Create a clickable link to the corresponding entity when one exists.
        $renderable_item = $lookup_manager->getRenderableItem($values['scientific_name'],
                                                              $values['entity_id']);
        $list[$delta] = $renderable_item;
      }

The last step is to populate the ``$elements`` array. If there is only one value,
as will be the case for this example, it becomes the only value in the array.
However, when multiple values are present, we can present them as a list.
Alternatively, you might want to display them in a table format.
For an example of a table formatter, see the `ChadoSequenceCoordinatesFormatterTable` formatter.

.. code-block:: php

      // If only one element has been found, don't make into a list.
      if (count($list) == 1) {
        $elements = $list;
      }
      // If more than one value has been found, display all values in an
      // unordered list.
      elseif (count($list) > 1) {
        $elements[0] = [
          '#theme' => 'item_list',
          '#list_type' => 'ul',
          '#items' => $list,
          '#wrapper_attributes' => ['class' => 'container'],
        ];
      }

      return $elements;
    }

This completes your field formatter!

The next section :ref:`Field Widgets` will describe how to create a widget
for this new field to allow editing content.

.. note::

  A good way to learn about fields is to look at examples of fields in the Tripal
  core codebase. Specifically, look in the
  `tripal_chado/src/Plugin/Field/FieldFormatter` directory.


Field Formatter Schema
^^^^^^^^^^^^^^^^^^^^^^^^

Field formatter schema is required to make field formatter information translatable in Drupal. The schema is defined in ``config/schema/mymodule.schema.yml`` and should include the following:

.. code-block:: yaml

  field.formatters.settings.my_field_formatters:
    type: mapping
    mapping: {}