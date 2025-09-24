ChadoOrganismAutocompleteController is deprecated in favour of ChadoOrganismFormElementController
======================================================================================================

- **Deprecated in** tripal 4.0.0-alpha3
- **Removed in** tripal 4.1.0
- **Issue** `#2284 <https://github.com/tripal/tripal/issues/2284>`_
- **PR** `#2293 <https://github.com/tripal/tripal/pull/2293>`_

The ChadoOrganismFormElementController class replaces the functionality of the existing ChadoOrganismAutocompleteController. It retains all existing methods with the same functionality. This class was created as an extension of the original class, and all method calls can be directly replaced without any changes.

ChadoOrganismAutocompleteController::handleAutocomplete()
--------------

**Before:**

.. code-block:: php

  $organism_autocomplete = new ChadoOrganismAutocompleteController();
  $request = Request::create(
      'chado/organism/autocomplete/10',
      'GET',
      ['q' => 't']
    );
  $organism_autocomplete->handleAutocomplete($request, 5);


**After:**

.. code-block:: php

  $organism_autocomplete = new ChadoOrganismFormElementController();
  $request = Request::create(
      'chado/organism/autocomplete/10',
      'GET',
      ['q' => 't']
   );
  $organism_autocomplete->handleAutocomplete($request, 5);


ChadoOrganismAutocompleteController::getPkeyId()
--------------

**Before:**

.. code-block:: php

  $organism_id = ChadoOrganismAutocompleteController::getPkeyId('Tripalus databasica (1)');


**After:**

.. code-block:: php

  $organism_id = ChadoOrganismFormElementController::getPkeyId('Tripalus databasica (1)');


ChadoOrganismAutocompleteController::getQuery()
--------------

**Before:**

.. code-block:: php

  $query = ChadoOrganismAutocompleteController::getQuery('%', $options);


**After:**

.. code-block:: php

  $query = ChadoOrganismFormElementController::getQuery('%', $options);
