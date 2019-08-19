#!/bin/bash
/repo/vendor/bin/codecept run --report --html| tee /project/.audit/codecept.txt
/repo/vendor/bin/phpcs --config-set installed_paths /repo/vendor/wp-coding-standards/wpcs/
/repo/vendor/bin/phpcs --config-set error_severity 1
/repo/vendor/bin/phpcs -i
#/repo/vendor/bin/phpcs -nps --colors --standard=Wordpress  --report-full=/project/.audit/phpcs-full.txt --report-summary=/project/.audit/phpcs-summary.txt /project
/repo/vendor/bin/phpcs -nps --standard=/phpcs.xml --colors /project
/bin/bash


#/project/../wordpress/wp-content/.env