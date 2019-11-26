#!/bin/bash
codecept() {
    codecept=$1
    cmd=${2:-run}
    echo "cmd ${cmd} 2: ${2}"
    if [ -z "${2}" ]; then
        echo "parameter 2 is zero"
    fi
    if [ "run" == "${cmd}" ] &&  [ -z "${2}" ]; then
        echo "default test"
        /repo/vendor/bin/codecept ${cmd} --report --html | tee /project/.audit/codecept.txt
    else
        # just means than a custom codecept command was passed.
        echo "custom test"
        /repo/vendor/bin/${@}
    fi
}

phpcs() {
    /repo/vendor/bin/phpcs --config-set installed_paths /repo/vendor/wp-coding-standards/wpcs/
    /repo/vendor/bin/phpcs --config-set error_severity 1
    /repo/vendor/bin/phpcs -i
    /repo/vendor/bin/phpcs -nps --standard=/phpcs.xml --colors --ignore=*/.phpdocs/*,*/tests/* /project
}

phpcbf() {
    /repo/vendor/bin/phpcbf -nps  --colors --ignore=*/.phpdocs/*,*/tests/* /project
}

phpdocs() {
    /repo/vendor/bin/phpdoc -d /project -t /project/.phpdocs -i /project/vendor/,/project/node_modules,/project/.phpdocs
}

mysql() {
    mysql -u root  -h bcgov_mysql -p
}

composer() {
    $1=-"update"
    /usr/local/bin/composer $1
}

echo "Command $1 $2"
if [ "$1" == 'codecept' ]; then
    codecept $@
elif [ "$1" == 'phpcs' ]; then
    echo "Checking php standards"
    phpcs
elif [ "$1" == 'phpcbf' ]; then
    echo "Auto fixing standards"
    phpcbf
    phpcs
elif [ "$1" == 'docs' ]; then
    echo "Creating Phpdocs at .phpdocs"
    phpdocs
elif [ "$1" == 'bash' ]; then
    echo "Running bash into wpbrowser"
    /bin/bash
elif [ "$1" == 'mysql' ]; then
    echo "Logging into mysql client"
    mysql
elif [ "$1" == 'composer' ]; then
    echo "Composer!!!"
    composer $2
else
    codecept
    phpcs
    phpdocs
fi


#/repo/vendor/bin/phpcs -nps --colors --standard=Wordpress  --report-full=/project/.audit/phpcs-full.txt --report-summary=/project/.audit/phpcs-summary.txt /project
# Creates php docs from project folder, creates info in .phpdocs and excludes /vendor

#/project/../wordpress/wp-content/.env