
Plugins and Services (Building blocks)
=================================================

What is a plugin?
------------------

You can think of a plugin as defining a type of functionality (e.g. Field,
Importer) that (a) has or will have multiple implementations and (b) a single
site may want to use 1+ of these implementations. A plugin is a sort of template or description that can be
used in multiple different situations, rather than explicitly coding a single
field or a single importer that is only used in one situation.

For example, if your module imports data into a Tripal site, you are *most
likely* going to create an implementation of the Tripal Importer class rather
than define your own plugin. A field is an example of a plugin created by
someone else that you would want to implement. In order for your module to
provide a custom Tripal field, then you are going to be implementing either the
:doc:`Tripal Field<tripal_fields>` plugin or Chado Field plugin.

Although more complex than typical plugins, entities are also technically an
example of a plugin. Read more about :doc:`Entities<entities>` to help decide
whether what you need to implement is an entity or a regular plugin.

Additional Resources:
 - `Official Drupal Plugin Documentation <https://www.drupal.org/docs/drupal-apis/plugin-api>`_
 - `Drupalize.me Topic on Plugins for Drupal 8, 9, and 10 <https://drupalize.me/topic/plugins-plugin-api>`_

What is a service?
-------------------

You can think of a service as a class providing a reusable component to other
classes within your module or other extension modules. A class whose purpose is
to provide an API is a great example of a service. Another example is pulling
values from configuration settings. A service should only be used if you do not
expect or support a site using multiple implementations of the same service. If
you do, then you should create a plugin instead. That said, services are more
lightweight than plugins and should be seriously considered as an option if you
are trying decide between developing a new service or a plugin.

Some Tripal-specific services you may want to utilize in your extension module
include:

- :doc:`Tripal Logger<logging>` to handle error reporting and logging of messages to the system
- :doc:`Tripal Jobs<jobs>` for dealing with large datasets outside of a page load (to prevent page timeout)

Additional Resources:
 - `Official Drupal Services and Dependency Injection Container Documentation for Drupal 11.x <https://api.drupal.org/api/drupal/core%21core.api.php/group/container/11.x>`_
 - `Drupalize.me Topic on Services for Drupal 8, 9, and 10 <https://drupalize.me/topic/services>`_
