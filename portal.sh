#!/bin/sh

# A series of commands used for auto-generating all of the tests custom to the DVUSD Portal.

perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/lib" -o "../../gitlab/Portal/htdocs/includes/portal/tests/lib" -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app" -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/admin" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/admin" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/cms" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/cms" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/core" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/core" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/dvusd" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/dvusd" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/gw" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/gw" -t controller -r
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/hours" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/hours" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/payroll" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/payroll" -t controller -r
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/phones" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/phones" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/ps" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/ps" -t controller -r;
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/sso" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/sso" -t controller -r
perl ./writer.pl -i "../../gitlab/Portal/htdocs/includes/portal/app/controller/whd" -o "../../gitlab/Portal/htdocs/includes/portal/tests/app/controller/whd" -t controller -r