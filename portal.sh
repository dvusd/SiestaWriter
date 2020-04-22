#!/bin/sh

# A series of commands used for auto-generating all of the tests custom to the DVUSD Portal.

perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/lib" -o "../../gitlab/Portal/htdocs/includes/portal/tests/lib" -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/classic/src" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/classic" -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/modern/src" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/modern" -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/shared/src" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/shared" -r;

#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller" -o "../../gitlab/Portal/htdocs/includes/portal/tests/universal/app/controller" -t controller -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/classic/src/app/controller" -o "../../gitlab/Portal/htdocs/includes/portal/tests/classic/app/controller" -t controller -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/modern/src/app/controller" -o "../../gitlab/Portal/htdocs/includes/portal/tests/modern/app/controller" -t controller -r;

#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/model" -o "../../gitlab/Portal/htdocs/includes/portal/tests/universal/app/model" -t model -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/classic/src/app/model" -o "../../gitlab/Portal/htdocs/includes/portal/tests/classic/app/model" -t model -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/modern/src/app/model" -o "../../gitlab/Portal/htdocs/includes/portal/tests/modern/app/model" -t model -r;

#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/store" -o "../../gitlab/Portal/htdocs/includes/portal/tests/universal/app/store" -t store -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/classic/src/app/store" -o "../../gitlab/Portal/htdocs/includes/portal/tests/classic/app/store" -t store -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/modern/src/app/store" -o "../../gitlab/Portal/htdocs/includes/portal/tests/modern/app/store" -t store -r;

#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/view" -o "../../gitlab/Portal/htdocs/includes/portal/tests/universal/app/view" -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/classic/src/app/view" -o "../../gitlab/Portal/htdocs/includes/portal/tests/classic/app/view" -r;
#perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/modern/src/app/view" -o "../../gitlab/Portal/htdocs/includes/portal/tests/modern/app/view" -r;
