
Upgrading an Extension Module
===============================

If you have developed an extension module on a previous version of Tripal that
you want to upgrade to Tripal 4, the first step will be to assess what kind of
components your module can be broken down into. If you haven't already, it is
recommended to first become familiar with Drupal 10's object-oriented
programming principles. In Drupal 10, your module is composed of any combination
of entities, fields, plugins, services, controllers and YAML configuration.

If your module provided an entity in Drupal 7, it will also provide an entity in
Drupal 10, but you will have to determine whether it is a
`Configuration Entity <https://drupalize.me/tutorial/what-are-configuration-entities>`_
or `Content Entity <https://drupalize.me/tutorial/user-guide/planning-data-types>`_.

Making decisions
-----------------
Keep in mind that your module can be comprised of multiple components at once,
and/or implementations of other plugins/services/entities that have already been
defined. This process can be overwhelming, but luckily many developers in the
Tripal community have a lot of experience with developing in Drupal 8+
(including Tripal 4 itself, which is comprised of many many many different
components!). We recommend first reading through the
:doc:`Extending Tripal <../module_dev>` section of this documentation.
Additionally, please consider joining our weekly Tripal codefests and joining
our Slack channel, and someone will be happy to help you with the decision
making process.
