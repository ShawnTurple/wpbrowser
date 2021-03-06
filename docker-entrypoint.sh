#!/bin/bash
codecept() {
    codecept=$1
    cmd=${2:-run}
    if [ "run" == "${cmd}" ] &&  [ -z "${2}" ]; then
        echo "Default test"
        /repo/vendor/bin/codecept ${cmd} --coverage --coverage-html
    else
        # just means than a custom codecept command was passed.
        echo "Custom test"
        /repo/vendor/bin/${@} --coverage --coverage-html
    fi
}

codecept_report() {
    echo "Report test"
    /repo/vendor/bin/codecept run  --report --html --coverage --coverage-html | tee /project/.audit/codecept.txt
}

phpcs() {
    /repo/vendor/bin/phpcs --config-set installed_paths /repo/vendor/wp-coding-standards/wpcs/
    /repo/vendor/bin/phpcs --config-set error_severity 1
    /repo/vendor/bin/phpcs -i
    if [ -z "${2}" ]; then
        /repo/vendor/bin/phpcs -ps --standard=/phpcs.xml --colors --ignore=*/.phpdocs/*,*/tests/*,dist/*,vendor/*,coverage/* /project
    else
        /repo/vendor/bin/${@}
    fi
}

phpcbf() {
    /repo/vendor/bin/phpcs --config-set installed_paths /repo/vendor/wp-coding-standards/wpcs/
    if [ -z "${2}" ]; then
        /repo/vendor/bin/phpcbf -ps  --colors --ignore=*/.phpdocs/*,*/tests/*,dist/*,vendor/*,coverage/* /project
    else
        /repo/vendor/bin/${@}
    fi
}

phpdocs() {
    /repo/vendor/bin/phpdoc -d /project -t /project/.phpdocs -i /project/vendor/,/project/node_modules,/project/.phpdocs
}

mysql() {
    mysql -u root  -h bcgov_mysql -p
}

composer() {
   
    if [ -z == "${2}" ]; then
        /user/local/bin/composer update
    else
        /usr/local/bin/${@} 
    fi
}

echo "Command $1 $2"
if [ "$1" == 'codecept' ]; then
    codecept $@
elif [ "$1" == 'codecept_report' ]; then
    codecept_report
elif [ "$1" == 'phpcs' ]; then
    echo "Checking php standards"
    phpcs $@
elif [ "$1" == 'phpcbf' ]; then
    echo "Auto fixing standards"
    phpcbf $@
    phpcs
elif [ "$1" == 'docs' ]; then
    echo "Creating Phpdocs at .phpdocs"
    phpdocs $@
elif [ "$1" == 'bash' ]; then
    echo "Running bash into wpbrowser"
    /bin/bash
elif [ "$1" == 'mysql' ]; then
    echo "Logging into mysql client"
    mysql
elif [ "$1" == 'composer' ]; then
    echo "Composer!!!"
    composer $@
else
    echo "Please use wputil --help for usage"
fi


#/repo/vendor/bin/phpcs -nps --colors --standard=Wordpress  --report-full=/project/.audit/phpcs-full.txt --report-summary=/project/.audit/phpcs-summary.txt /project
# Creates php docs from project folder, creates info in .phpdocs and excludes /vendor

#/project/../wordpress/wp-content/.env