Relationships between content
===============================

Content on your tripal site is almost always related in some way to other types of content.
A *publication* may be about a particular *organism*, or a *project* may consist of several *analyses*.
In other cases, however, the relationship may be between records of the same type of content.
For example, a *chapter* is a part of a *book*, and these are both types of *publication* content.
Similarly, an *exon* may be part of a *gene*, which both are sequence *features*.
A *project* may be part of a larger *umbrella project*.

These types of relationships can be stored in Chado using one of the *relationship* tables.
These relationships are then presented to site users using the relationship field.

How to create a new relationship
----------------------------------

Through the Tripal user interface, you can specify one or more relationships between similar types of content.
When specifying a relationship, a controlled vocabulary term is used to specify how the
records are related.

Let's examine an example where we have a high-level umbrella project which
has two smaller projects that are a part of it.

First we create the three project records.
We have created "The Tripalus Genome Project" which will be the umbrella project,
and two other projects, an assembly and an annotation project.

.. image:: relationships.1.three-projects.png
      :alt: Three projects have been created, "The Tripalus Genome Project", "Tripalus Genome Assembly", and "Tripalus Genome Annotation".

If we edit the umbrella project "The Tripalus Genome Project",
we will find the relationship field section, which is currently blank.

.. image:: relationships.2.blank-relationship.png
      :alt: The relationship form, currently blank.

First we select a controlled vocabulary term which indicates the type of relationship.
Here we are selecting *part_of*, because the two other projects will be *part of* this umbrella project.

.. image:: relationships.3.selecting-term.png
      :alt: Selecting a controlled vocabulary term in the relationship field.

Next we select the related project

.. image:: relationships.4.selecting-project.png
      :alt: Selecting a project in the relationship field.

Then we toggle *reverse* because the selected project *Tripalus Genome Assembly* is the **subject**,
meaning the selected project is the *subject* of the *part of* relationship,
and the *object* is the project that we are currently editing.

.. image:: relationships.5.reverse.png
      :alt: Selecting reverse in the relationship field.

We can add a second relationship by clicking the *Add another item* button.

.. image:: relationships.6.add-another-item.png
      :alt: Adding a second relationship in the relationship field.

After we add the second relationship, the form looks like this, and we can click the "Save" button.

.. image:: relationships.7.second-relationship.png
      :alt: After adding a second relationship in the relationship field.

After saving, the relationships will appear like this.

.. image:: relationships.8.appearance-subject.png
      :alt: Appearance of relationships in the umbrella project.

The relationships will not yet appear on the other two projects.
We need to republish for that to happen.

Go to Tripal → Content → + Publish Tripal Content.

For *Content Type* select *Project*, and make sure to check *Republish Existing Content*.

.. image:: relationships.9.republish.png
      :alt: Publish form for project with republish selected.

When this is done, you will see the command you need to run to run the publish job.
It will be different from the one shown here.

.. image:: relationships.10.drush-command.png
      :alt: Republish job submitted showing drush command "drush trp-run-jobs --job-id=1 --username=drupaladmin --root=/var/www/drupal/web".

Now on the other two projects you will also see the relationship.

.. image:: relationships.11.appearance-object.png
      :alt: Appearance of relationship in the sub-project.

.. hint::
    You can also run the republish job on the command line using drush.
    For the project content type, the command would be:

    ``drush trp-chado-publish project --republish``
