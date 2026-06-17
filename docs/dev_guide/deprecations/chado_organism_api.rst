Tripal Chado Organism API is deprecated in favour of the ChadoOrganismBuddy and ChadoOrganismFormElementController
===================================================================================================================

- **Deprecated in** tripal 4.0.0-alpha4
- **Removed in** tripal 4.1.0
- **Issue** `#2424 <https://github.com/tripal/tripal/issues/2424>`_
- **PR** `#2426 <https://github.com/tripal/tripal/pull/2426>`_

Methods in ChadoOrganismBuddy class and ChadoOrganismFormElementController class replace the functionality of the existing Chado Organism API methods.

chado_get_organism()
--------------------

**Before:**

.. code-block:: php

    $identifiers = [
        'genus' => 'Lens',
        'species' => 'culinaris',
    ];
    $organism = chado_get_organism($identifiers, []);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $conditions = [
        'organism.genus' => 'Lens',
        'organism.species' => 'culinaris',
    ];
    $organism = $organism_buddy_instance->getOrganism($conditions, []);


chado_get_organism_scientific_name()
------------------------------------

**Before:**

.. code-block:: php

    $organism = chado_get_organism_scientific_name($organism_object);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $organism = $organism_buddy_instance->getOrganismScientificName($organism_object, []);

chado_get_organism_select_options()
-----------------------------------

**Before:**

.. code-block:: php

    $organisms = chado_get_organism_select_options();

**After:**

.. code-block:: php

  use Drupal\tripal_chado\Controller\ChadoOrganismFormElementController;

  ...

  $organisms = ChadoOrganismFormElementController::getSelectOptions([]);

chado_get_organism_id_from_scientific_name()
--------------------------------------------

**Before:**

.. code-block:: php

    $organism_id = chado_get_organism_id_from_scientific_name($scientific_name, $options);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $organism_id = $organism_buddy_instance->getOrganismFromScientificName($scientific_name, $options);

chado_abbreviate_infraspecific_rank()
-------------------------------------

**Before:**

.. code-block:: php

    $abbreviation = chado_abbreviate_infraspecific_rank($rank_species);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $abbreviation = $organism_buddy_instance->abbreviateInfraspecificRank($rank_species);

chado_unabbreviate_infraspecific_rank()
----------------------------------------

**Before:**

.. code-block:: php

    $rank = chado_unabbreviate_infraspecific_rank($rank_species);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $rank = $organism_buddy_instance->unabbreviateInfraspecificRank($rank_species);

