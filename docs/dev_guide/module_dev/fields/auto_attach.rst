Add Fields to Content Types
============================

In order for a field to be used, it needs to be added to a specific content type.
A field can also be defined in a YAML file for fields you want to be added automatically, 
see :ref:`Adding a field programatically`.

To add a field manually, this can be done through the "Manage Fields" interface for a given Content Type.
More specifically, go to **Tripal** → **Page Structure**
and then choose "**Manage Fields**" for the Content Type you want to add a field to,
and then click "**+ Create a new field**".


Field Categories
-----------------

Each field is present in one of the categories on this page based on its annotation.
For Tripal Core fields you will note that we use the categories
**Tripal Fields** (`tripal`) and **Chado Fields** (`tripal_chado`),
and this is based on whether the field is defined in the **tripal** or **tripal_chado** module.

  .. image:: auto_attach.1.tripal_field_categories.png
     :width: 711
     :alt: Selectors for Tripal fields and for Chado fields

For extension modules, we recommend determining your category as follows:

 - `tripal`: any generic tripal field which is independent of the storage backend.
   Usually this means it is very application-specific without a biological focus (`e.g.` permission control).

 - `tripal_chado`: any field which is dependent on chado for data storage/retrieval.
   This includes most fields in Tripal Core, and likely most fields in general.

 - custom category: you may want to make your own category if your field uses a different
   storage backend or REST API. You can also create your own category for a module providing
   a large number of fields supporting specific functionality, but be careful to ensure this
   will be intuitive to your users and keep it functionality focused, not development group
   focused (`e.g.` **Genetic Variants** but not **MyLab**).
   When making a custom category you will also need to provide an icon.
   You can follow the Drupal documentation on how to do this.

As an example, you can see the category `tripal_chado` has been defined for the Additional Type field:

.. code-block:: php

  /**
   * Plugin implementation of Tripal additional type field type.
   */
  #[TripalFieldType(
    id: 'chado_additional_type_type_default',
    category: 'tripal_chado',
    label: new TranslatableMarkup('Chado Type Reference'),
    description: new TranslatableMarkup('A Chado type reference'),
    default_widget: 'chado_additional_type_widget_default',
    default_formatter: 'chado_additional_type_formatter_default',
  )]
  class ChadoAdditionalTypeTypeDefault extends ChadoFieldItemBase {
  ...

Adding a field programatically
-------------------------------

If you are creating a custom module and want to add fields to content types programatically,
the preferred method is to define the fields in a YAML file in your module's `config` directory,
and they will be added automatically when your module is installed.

For example, this is the first field defined in `tripal_chado/config/install/tripal.tripalfield_collection.general_chado.yml`

.. code-block:: yaml

    -   name: 'organism_genus'
        content_type: 'organism'
        label: 'Genus'
        type: 'chado_string_type_default'
        description: 'The genus name of the organism.'
        cardinality: 1
        required: true
        storage_settings:
            storage_plugin_id: 'chado_storage'
            storage_plugin_settings:
                base_table: 'organism'
                base_column: 'genus'
            max_length: 255
        settings:
            termIdSpace: 'TAXRANK'
            termAccession: '0000005'
        display:
            view:
                default:
                    region: 'content'
                    label: 'above'
                    weight: 10
                    settings:
                      field_prefix: '<em>'
                      field_suffix: '</em>'
            form:
                default:
                    region: 'content'
                    weight: 10

If you need to add a field later, for example in an update hook, code similar to the
following can be used to load a specific field as defined in a YAML file.

.. code-block:: php

  $yaml_path = __DIR__ . '/config/install/your.yml';
  $field_name = 'your_field';

  /** @var \Drupal\tripal\Services\TripalFieldCollection $fields_service **/
  $fields_service = \Drupal::service('tripal.tripalfield_collection');
  /** @var \Drupal\Core\Entity\EntityTypeManager $entity_type_manager **/
  $entity_type_manager = \Drupal::entityTypeManager();
  $fields = Yaml::decode(file_get_contents($yaml_path));
  $field = $fields[$field_name];
  $bundle = $field['content_type'];
  /** @var \Drupal\tripal\Entity\TripalEntityType $entity_type **/
  $entity_type = $entity_type_manager->getStorage('tripal_entity_type')->load($bundle);
  if ($entity_type) {
    $fields_service->addBundleField($field);
  }
