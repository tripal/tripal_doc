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

  namespace Drupal\mymodule\Plugin\Field\FieldWidget;

  use Drupal\Core\StringTranslation\TranslatableMarkup;
  use Drupal\Core\Field\FieldItemListInterface;
  use Drupal\Core\Form\FormStateInterface;
  use Drupal\tripal\TripalField\Attribute\TripalFieldWidget;
  use Drupal\tripal_chado\TripalField\ChadoWidgetBase;

  /**
   * Plugin implementation of organism name widget.
   */
  #[TripalFieldWidget(
    id: 'my_field_widget',
    label: new TranslatableMarkup('Organism Scientific Name Widget'),
    description: new TranslatableMarkup('A chado organism scientific name widget.'),
    field_types: [
      'my_field',
    ],
  )]
  class MyFieldWidget extends ChadoWidgetBase {

    /**
     * {@inheritdoc}
     */
    public function formElement(FieldItemListInterface $items, $delta, array $element, array &$form, FormStateInterface $form_state) {

      // Get the list of organisms. Second parameter true includes common names.
      $organisms = chado_get_organism_select_options(FALSE, TRUE);

      $item_vals = $items[$delta]->getValue();
      $record_id = $item_vals['record_id'] ?? 0;
      $organism_id = $item_vals['organism_id'] ?? 0;

      $elements = [];
      $elements['record_id'] = [
        '#type' => 'value',
        '#default_value' => $record_id,
      ];
      $elements['organism_id'] = $element + [
        '#type' => 'select',
        '#options' => $organisms,
        '#default_value' => $organism_id,
        '#empty_option' => '-- Select --',
      ];

      return $elements;
    }

    /**
     * {@inheritDoc}
     */
    public function massageFormValues(array $values, array $form, FormStateInterface $form_state) {
      // Remove any empty values that don't have an organism
      foreach ($values as $delta => $item) {
        if ($item['organism_id'] == '') {
          unset($values[$delta]);
        }
      }

      // Reset the weights
      $i = 0;
      foreach ($values as $val_key => $value) {
        $values[$val_key]['_weight'] = $i;
        $i++;
      }
      return $values;
    }

  }

Below is a line-by-line explanation of each section of the code snippet above.

Widgets Namespace and Use Statements
``````````````````````````````````````

The following should always be present and specifies the namespace for this
field.

.. code-block:: php

  namespace Drupal\mymodule\Plugin\Field\FieldWidget;

.. note::

  Be sure to change `mymodule` in the `namespace` to the name of your module.

.. warning::

  If you misspell the `namespace` your field will not work properly.

The following "use" statements are required for all Chado fields.

.. code-block:: php

  use Drupal\Core\StringTranslation\TranslatableMarkup;
  use Drupal\Core\Field\FieldItemListInterface;
  use Drupal\Core\Form\FormStateInterface;
  use Drupal\tripal\TripalField\Attribute\TripalFieldWidget;
  use Drupal\tripal_chado\TripalField\ChadoWidgetBase;

Widget Attribute Section
``````````````````````````
The attribute section in the class file is the set of lines wrapped inside ``#[ ]``.
The attribute section is required.
This section is similar to the attribute section in the previous Type and Formatter classes.
Note the ``field_types`` attribute, which specifies what field types this formatter can be used
for. This should match the ``id`` attribute in the Type class.

.. code-block:: php

  /**
   * Plugin implementation of organism name widget.
   */
  #[TripalFieldWidget(
    id: 'my_field_widget',
    label: new TranslatableMarkup('Organism Scientific Name Widget'),
    description: new TranslatableMarkup('A chado organism scientific name widget.'),
    field_types: [
      'my_field',
    ],
  )]

.. warning::

   If the attribute section is not present, has misspellings, or is not
   complete, the field will not be recognized by Drupal.

Widget Class Definition
````````````````````````````

Next, the class definition line must extend the `ChadoWidgetBase` class. You
must name your class the same as the filename in which it is contained (minus
the `.php` extension).

.. code-block:: php

  class MyFieldWidget extends ChadoWidgetBase {

.. warning::

    If you misspell the class name such that it is not the same as the filename
    of the file in which it is contained, then the field will not be recognized by
    Drupal.

The formElement() Function
`````````````````````````````
The `formElement()` function is used to define how the form for editing the
field content is constructed.
For our example, a site administrator will want to select one of the existing
organisms to attach to the current content type.

In the example code block below you can see the steps where the list of existing
organisms is retrieved using a Chado API function.

.. code-block:: php

    public function formElement(FieldItemListInterface $items, $delta, array $element, array &$form, FormStateInterface $form_state) {

      // Get the list of organisms. Second parameter true includes common names.
      $organisms = chado_get_organism_select_options(FALSE, TRUE);

Next we retrieve the values for the existing organism, or zero if one is not set.

.. code-block:: php

      $item_vals = $items[$delta]->getValue();
      $record_id = $item_vals['record_id'] ?? 0;
      $organism_id = $item_vals['organism_id'] ?? 0;

Next we define two form elements. The first one, ``record_id`` is not
shown on the form, it is the value of the Drupal entity. This is the "host"
page on which this field is being displayed

.. code-block:: php

      $elements = [];
      $elements['record_id'] = [
        '#type' => 'value',
        '#default_value' => $record_id,
      ];

The second form element is an organism select. This select list contains all
organisms currently defined, and the site administrator can select the
appropriate organism. If editing an existing record, then the current
organism is presented as the default.

.. code-block:: php

      $elements['organism_id'] = $element + [
        '#type' => 'select',
        '#options' => $organisms,
        '#default_value' => $organism_id,
        '#empty_option' => '-- Select --',
      ];

      return $elements;
    }

.. note::

  For fields with a large number of possible items, it may be more appropriate
  to use an autocomplete field.
  A working example of this can be found in the additional type field in
  `tripal_chado/src/Plugin/Field/FieldWidget/ChadoAdditionalTypeWidgetDefault.php`.
  Additional documentation about adding an autocomplete to a form can be found in
  :ref:`The form() function`.

The massageFormValues() function
``````````````````````````````````

This function is called afther the form is submitted by the user, and takes care of
removing any records that may have been present earlier, but were removed before saving.
This is a simple example, but your field may need to do more, particularly if the field
is referencing a linked table.

.. code-block:: php

    public function massageFormValues(array $values, array $form, FormStateInterface $form_state) {
      // Remove any empty values that don't have an organism
      foreach ($values as $delta => $item) {
        if ($item['organism_id'] == '') {
          unset($values[$delta]);
        }
      }

      // Reset the weights
      $i = 0;
      foreach ($values as $val_key => $value) {
        $values[$val_key]['_weight'] = $i;
        $i++;
      }
      return $values;
    }


.. note::

  A good way to learn about fields is to look at examples of fields in the Tripal
  core codebase. Specifically, look in the
  `tripal_chado/src/Plugin/Field/FieldWidget` directory.
