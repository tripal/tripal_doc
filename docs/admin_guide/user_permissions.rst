.. warning::

  These docs are still being developed. In the future this page will contain a
  very short introduction to user management in Drupal and practical examples
  for site administration of a Tripal site.

User Permissions
================

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

A Curator role that allows data curators to edit their own gene, analysis or transcriptome page.
A Project Manager role for managing the roles in a scientific Project 
The Administrator role that was installed with your site, for expert users to manage the site configuration

Creating Roles to enable Curation
---------------------------------

Here is a walk through creating a “Curator” roles based on a need and then assign these roles permissions in Tripal by the Admin. For example, a curator of genomic data would need access to specific importers and content types.

Create User
***********

From the top menu -> **People** -> **+Add User** -> 
  * Username : curator_user
  * Password : `abcd_123_!@#`
  * Roles : Content editor  

Click on **Create new account** leaving other items as default 

From the top menu -> **People** -> *curator_user* appears in list of Usernames.

To perform same action on multiple users, for example, to add the Content editor role, from the top menu, click on -> **People** -> click inside checkbox before *curator_user*.

Click on Apply to selected items.

 .. figure:: curator_role.png

From the top menu -> **People** -> **Permissions**

Click in applicable checkboxes for **Content editor**.

Permission sections available are:
 * Block
 * Block Content
 * Comment
 * Configuration Manager
 * Contact
 * Contextual Links
 * Devel 
 * Devel PHP 
 * Field UI 
 * File 
 * Filter 
 * Image 
 * Node 
 * Path
 * Search 
 * Shortcut
 * System 
 * Taxonomy 
 * Toolbar 
 * Tour 
 * Tripal 
 * Tripal Chado 
 * Update Manager 
 * User 
 * Views UI 

Checkboxes are provided under each header: *Anonymous user*,	*Authenticated user*,	*Content editor* and	*Administrator* for every item in each section.Some of the checkboxes are already checked are some are not changeable.

An administrator can change the default permissions for roles. For example, to change roles of *Content editor*, 

From the top menu -> **People** -> **Roles**, next to *Content editor*, click on *Edit* -> *Edit permissions*. Administrator can chnage individual permissions by checking on the Content editor item for the relevant section.

Creating Roles to define collaborative groups
---------------------------------------------


Additional Resources:
 - `Official Drupal Docs: What are Users, Roles, and Permissions? <https://www.drupal.org/docs/user_guide/en/user-concept.html>`_
 - `Official Drupal Docs: Creating a Role <https://www.drupal.org/docs/user_guide/en/user-new-role.html>`_
 - `Official Drupal Docs: Assigning Permissions to a Role <https://www.drupal.org/docs/user_guide/en/user-permissions.html>`_
 - `Official Drupal Docs: Changing a User’s Roles <https://www.drupal.org/docs/user_guide/en/user-roles.html>`_
 - `Official Drupal Docs: Creating a User Account <https://www.drupal.org/docs/user_guide/en/user-new-user.html>`_
