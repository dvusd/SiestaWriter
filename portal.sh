#!/bin/sh

# A series of commands used for auto-generating all of the tests custom to the DVUSD Portal.

perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/lib" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/lib" -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app" -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/admin/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/admin/controller" -t controller -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/cms/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/cms/controller" -t controller -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/core/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/core/controller" -t controller -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/dvusd/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/dvusd/controller" -t controller -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/hours/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/hours/controller" -t controller -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/phones/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/phones/controller" -t controller -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/ps/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/ps/controller" -t controller -r;
perl ./writer.pl -i "../../dvp.dvusd.org/htdocs/includes/portal/app/module/sso/controller" -o "../../dvp.dvusd.org/htdocs/includes/portal/tests/app/module/sso/controller" -t controller -r