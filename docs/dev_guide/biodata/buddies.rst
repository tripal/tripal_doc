
Chado Buddies
===============

Chado Buddies are a group of classes that make accessing certain types of chado
data as easy and as fast as possible. They allow retrieval, addition, and updating
of data in several tables or simultaneous combinations of tables.

All buddies are created by a two step process:

  1. Create the service. There is a single service that can be used for all buddies:

     ``$buddy_service = \Drupal::service('tripal_chado.chado_buddy');``

     For best practice, this service should be injected into your class.
     To see how to do this, see :ref:`Injecting the Buddy Service`

  2. Create an instance for each service you want, for example:

     ``$dbxref_instance = $buddy_service->createInstance('chado_dbxref_buddy', []);``

See the following sections for details on each buddy class.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   buddies/buddy_values
   buddies/inject
