User Permissions (Edit v1)
==========================

.. warning::

  These docs are still being developed. In the future this page will contain a
  very short introduction to user management in Drupal and practical examples
  for site administration of a Tripal site.

.. hint::

  *Hint for contributing to documentation.*

  Use the information from `Official Drupal Docs: What are Users, Roles, and Permissions? <https://www.drupal.org/docs/user_guide/en/user-concept.html>`_
  to breifly summarize what a user, role and permission is, with a focus on
  managing biological data. For example, users and permissions allow you to
  give certain researchers access to private data, roles can help you setup
  groups of collaborators so you can assign the permission to the group as a
  whole which makes it easier if any one member leavers or joins the group.


`Begin Content for User Permissions`_
#####################################

What are *Users* ?

Anyone who visits your website is a *user*, including you. There are three groups of users:

 - Users who are not logged in, or *anonymous users*

 - Users who are logged in, or *authenticated users*

 - The administrative user account that was automatically created when your site was installed, or User 1.

What are *Permissions* ?

The ability to do actions on your site (including viewing content, editing content, and changing configuration) is governed by permissions. Each permission has a name (such as View published content) and covers one action or a small subset of actions. A user must be granted a permission in order to do the corresponding action on the site; permissions are defined by the modules that provide the actions.

What are *Roles* ?

Rather than assigning individual permissions directly to each user, permissions are grouped into roles. You can define one or more roles on your site, and then grant permissions to each role. The permissions granted to authenticated and anonymous users are contained in the Authenticated user and Anonymous user roles, and depending on the installation profile you used when you installed your site, there may also be an Administrator role that is automatically assigned all permissions on your site.

Each user account on your site is automatically given the Authenticated user role, and may optionally be assigned one or more additional roles. When you assign a role to a user account, the user will have all the permissions of the role when logged in.

It is a good practice to make several roles on your Tripal site. For example, you might want the following roles:

A Curator role that allows data curators to edit their own gene, analysis or transcriptome page
A Project Manager role for managing the roles in a scientific Project 
The Administrator role that was installed with your site, for expert users to manage the site configuration

`End Content`_
##############



Creating Roles to enable Curation
------------------------------------

.. hint::

  *Hint for contributing to documentation.*

  Walk admin through creating one or more "Curator" roles based on their needs
  and then assign these roles permissions in Tripal. For example, a curator of
  genomic data would need access to specific importers and content types.

Creating Roles to define collaborative groups
------------------------------------------------

.. hint::

  *Hint for contributing to documentation.*

  Walk admin through the idea of creating roles which focus on specific grants
  or publications. This way and draft or private pages being created related to
  those projects cab be made available to the group for proof reading and collaboration
  before they are made public.

  Walk the admin through assigning permissions / visibility to specific content pages.
  Currently this requires an additional Drupal module: https://www.drupal.org/project/permissions_by_term
  so use this module in your example including screenshots.

Additional Resources:
 - `Official Drupal Docs: What are Users, Roles, and Permissions? <https://www.drupal.org/docs/user_guide/en/user-concept.html>`_
 - `Official Drupal Docs: Creating a Role <https://www.drupal.org/docs/user_guide/en/user-new-role.html>`_
 - `Official Drupal Docs: Assigning Permissions to a Role <https://www.drupal.org/docs/user_guide/en/user-permissions.html>`_
 - `Official Drupal Docs: Changing a User’s Roles <https://www.drupal.org/docs/user_guide/en/user-roles.html>`_
 - `Official Drupal Docs: Creating a User Account <https://www.drupal.org/docs/user_guide/en/user-new-user.html>`_
