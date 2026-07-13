Tripal Chado Organism API is deprecated in favour of the ChadoOrganismBuddy and ChadoOrganismFormElementController
===================================================================================================================

- **Deprecated in** tripal 4.0.0-alpha5
- **Removed in** tripal 4.1.0
- **Issue** `#2424 <https://github.com/tripal/tripal/issues/2424>`_
- **PR** `#2426 <https://github.com/tripal/tripal/pull/2426>`_

Methods in ChadoOrganismBuddy and ChadoOrganismFormElementController classes replace the majority of the functionality of the existing Chado Organism API methods. 

Some of these methods can be provided a ChadyBuddyRecord as a parameter, and may return one or more Organism buddies. To learn more about ChadoBuddies, refer to: :ref:`Chado Buddies Documentation <Chado Buddies>`

.. note::
    The examples below demonstrate static service calls to the ChadoOrganismBuddy and ChadoOrganismFormElementController classes; however, Dependency Injection is preferred when integrating services, as recommended by Drupal best practices. For more details regarding Injecting ChadoBuddy Services, refer to: :ref:`Injecting the Buddy Service Documentation <Injecting the Buddy Service>`



chado_get_organism()
--------------------

**Before:**

.. code-block:: php

    $identifiers = [
        'genus' => 'Tripalus',  
        'species' => 'databasica',
    ];
    $organism_object = chado_get_organism($identifiers, []);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $conditions = [
        'organism.genus' => 'Tripalus',  
        'organism.species' => 'databasica',
    ];
    // Retrieves an array of ChadoOrganismBuddy records. This array will be empty if no records
    // matched the input values, and can have one or more records if matches were found.  
    $organism_buddies = $organism_buddy_instance->getOrganism($conditions, []);

chado_get_organism_scientific_name()
------------------------------------

**Before:**

.. code-block:: php

    // Returns a string of the matching organism's scientific name  
    $organism_name = chado_get_organism_scientific_name($organism_object); 

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $conditions = [  
        'organism.common_name' => 'Tripal',  
    ];  

    // Returns a string of the matching organism's scientific name  
    $organism_name = $organism_buddy_instance->getOrganismScientificName($conditions);

chado_get_organism_image_url()
------------------------------

This function currently has no replacement in Tripal 4.

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

By Scientific Name:

.. code-block:: php

    $scientific_name = 'Tripalus databasica';  
    // Returns an array of organism IDs that match the specified scientific name.  
    $organism_ids = chado_get_organism_id_from_scientific_name($scientific_name);  
    
By Common Name:

.. code-block:: php

    $common_name = 'Tripal';  
    // Returns an array of organism IDs that match the specified common name.  
    $organism_ids = chado_get_organism_id_from_scientific_name($common_name,
      ['check_common_name' => TRUE]);

**After:**

By Scientific Name:  

.. code-block:: php

    $scientific_name = 'Tripalus databasica';  
    // Retrieves an array of ChadoOrganismBuddy records. This array will be empty if no records
    // matched the input values, and can have one or more records if matches were found.  
    $organism_buddies = $organism_buddy_instance->getOrganismFromScientificName($scientific_name);  
    // Then grab the organism's ID  
    $organism_id = $organism_buddies[0]->getValue('organism.organism_id');  

By Common Name:

.. code-block:: php

    $common_name = 'Tripal';  
    $organism_buddies = $organism_buddy_instance->getOrganismFromScientificName($common_name,
      ['check_common_name' => TRUE]);  
    // Then grab the organism's ID  
    $organism_id = $organism_buddies[0]->getValue('organism.organism_id');  

chado_abbreviate_infraspecific_rank()
-------------------------------------

**Before:**

.. code-block:: php

    // Returns the abbreviation of an organism's rank.  
    $rank_abbreviation = chado_abbreviate_infraspecific_rank($rank);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $rank_abbreviation = $organism_buddy_instance->abbreviateInfraspecificRank($rank);

chado_unabbreviate_infraspecific_rank()
----------------------------------------

**Before:**

.. code-block:: php

    $rank = chado_unabbreviate_infraspecific_rank($rank_abbreviation);

**After:**

.. code-block:: php

    $buddy_service = \Drupal::service('tripal_chado.chado_buddy');
    $organism_buddy_instance = $buddy_service->createInstance('chado_organism_buddy', []);

    $rank = $organism_buddy_instance->unabbreviateInfraspecificRank($rank_abbreviation);  

chado_autocomplete_organism()
------------------------------

**Before:**

.. code-block:: php

    $organism_autocomplete = chado_autocomplete_organism($text);

**After:**

.. code-block:: php

    use Drupal\tripal_chado\Controller\ChadoOrganismFormElementController;

    ...

    $organism_autocomplete = new ChadoOrganismFormElementController();
    $request = Request::create(
        'chado/organism/autocomplete/10',
        'GET',
        ['q' => $text]
    );
    $organism_autocomplete->handleAutocomplete($request, 5);
