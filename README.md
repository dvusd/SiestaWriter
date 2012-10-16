SiestaWriter
===========

A shell script that can be used to auto-generate JavaScript unit/integration tests for the [Siesta] unit-testing framework.

Background
----------
I am a member of a team that is currently developing a multi-headed, vampiric mammoth with thick leathery scales, stone eyes, a spiked tail, and garlic breath. You should never look directly into any eye of the beast or your inner being will be consumed in a fiery abyss.  Scared yet?  In actuality, the project is a huge business-mashup portal that includes a custom content management system, SSO links to dozens of sites, a file management UI similar to Windows Explorer, and dozens of other custom apps.  I have been involved with the project since the beginning and have refactored the code a multitude of times, most recently utilizing the Ext MVC style for organization.  

Until recently, the massive codebase for the front-end JavaScript almost completely lacked unit & integration tests.  Encumbered by the vacancy of a JavaScript unit testing framework capable of testing graphical UI components, tests were not even possible until the last year when [Siesta] was released.  Empowered with a new tool, I have been trying to quickly write basic tests for as many components & classes as possible.  Since I perform the same assertions for like-components, I wanted a means to template different tests for basic types of classes.  For example, if I'm testing an Ext.data.Model, then I have assertions to verify I can create the model, populate an instance with default values, and validate any conversion functions.  These "common" assertions are defined in template files that can be changed at will.  The script can be re-run to refresh any differences in the auto-generated tests. 

Basics
------
A series of template test files exist under /tpl with the extension "t.js" that correspond with the different types of classes that the script can auto-detect.

The following are the supported types of classes:
'button', 'controller', 'form', 'generic', 'grid', 'model', 'panel', 'store', 'tab', 'toolbar', 'tree', 'window'

The script also supports a command-line argument for statically declaring the type of template to use when processing a file or folder containing JS class definitions.

Usage
-----
From the command line, run the following to see all options:

```bash
perl ./writer.pl
```


[Siesta]: http://www.bryntum.com/products/siesta/