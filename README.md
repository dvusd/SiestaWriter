SiestaWriter
===========

A shell script that can be used to auto-generate JavaScript unit/integration tests for the [Siesta] unit-testing framework.

Background
----------
I am a member of a team that is currently developing a multi-headed, vampiric mammoth with thick leathery scales, stone eyes, a spiked tail, and garlic breath. You should never look directly into any eye of the beast or your inner being will be consumed in a fiery abyss.  Scared yet?  In actuality, the project is a huge business-mashup portal that includes a custom content management system, SSO links to dozens of sites, a file management UI similar to Windows Explorer, and dozens of other custom apps.  I have been involved with the project since the beginning and have refactored the code a multitude of times, most recently utilizing the Ext MVC style for organization.  

Until recently, the massive codebase for the front-end JavaScript almost completely lacked unit & integration tests.  Encumbered by the vacancy of a JavaScript unit testing framework capable of testing graphical UI components, tests were not even possible until the last year when [Siesta] was released.  Empowered with a new tool, I have been trying to quickly write basic tests for as many components & classes as possible.  Since I perform the same assertions for like-components, I wanted a means to template different tests for basic types of classes.  For example, if I'm testing an Ext.data.Model, then I have assertions to verify I can create the model, populate an instance with default values, and validate any conversion functions.  These "common" assertions are defined in template files that can be changed at will.  The script can be re-run to refresh any differences in the auto-generated tests. 


Usage
-----
In the shell, run the following to see all options:

```bash
perl ./writer.pl
```

* Specify an input file/folder with the "-i" option.
* Specify an output location for the generated files with "-o".  
* Process a folder recursively with the "-r" option.  This will generate the files in a tree structure that mimics the input tree.  
* A verbose mode is available with "-v".  
* The script also supports a command-line argument for statically declaring the type of template to use when processing a file or folder containing JS class definitions.  For this, specify "-t" followed by one of these types:
** 'button', 'controller', 'form', 'generic', 'grid', 'model', 'panel', 'store', 'tab', 'toolbar', 'tree', 'window'

Templates
---------
A series of template test files exist under /tpl with the extension "t.js" that correspond with the different types of classes that the script can auto-detect.  These can be quickly modified to change the default test definition.

Checksums
---------
This script is not a full solution for writing tests.  It was designed with the sole purpose of quickly creating test stubs that would likely be customized by a developer at a later date.  With that in mind, the script can be re-run against the same code source and will only modify files that have *not* been customized by a coder.  It accomplishes this by writing an md5 hash into the doc-comment header of each auto-generated test.  As long as the body of the test does not change, the hash will be equivalent and the file contents will be refreshed whenever templates change.  However, if you modify anything in the test body, the file will no longer be touched by the script.  If you do modify the test, it is recommended that you remove the doc-comment header so that it's easier to identify auto-generated tests versus customized files.  


[Siesta]: http://www.bryntum.com/products/siesta/