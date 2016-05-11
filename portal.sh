#!/bin/sh

# A series of commands used for auto-generating all of the tests custom to the DVUSD Portal.

perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/lib" -o "../../gitlab/Portal/htdocs/includes/portal/tests/lib" -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app" -r;

perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/model" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/model" -t model -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/store" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/store" -t store -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/view" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/view" -r;
