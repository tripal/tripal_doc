
Tripal Fields (Content building blocks)
========================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   fields/overview
   fields/types
   fields/formatters
   fields/widgets

Fields are the building blocks of content in Drupal. For example, all content
types (e.g. "Article", or "Basic Page") provide content to the end-user via
fields that are bundled with them.  For example, when adding a basic
page (a default Drupal content type), the end-user is provided with form
elements (or widgets) that allow the user to set the title and the body text
for the page. The "Body" is a field.  When a basic page is
viewed, the body is rendered on the page using formatters, and
Drupal stores the values for the body in the database. Every
field, therefore, provides three types of functionality: instructions
for storage, widgets for allowing input, and formatters for rendering.

Drupal provides a variety of built-in fields, and extension module developers
have created a multitude of new fields that can be added by the site admin
to add new functionality and support new types of data.  Tripal follows this
model, but adds a variety of new object oriented classes to support storage
of data in biological databases such as Chado.

.. note::

  Not every custom module will require fields. But if you need a new way
  to store and retrieve data, or if you need data to appear on an existing
  Tripal content type, then you will want to create a new field for your
  custom module.

