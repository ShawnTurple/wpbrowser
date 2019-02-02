# WP BROWSER

Docker container for creating a codecdept instance.


## Usage
```
docker  run \
	--rm \
	-v ${pwd):/project \
	-v ${WORDPRESS_TEST_SITE_INSTALL}:/wordpress/ \
	--link mysql
	--link selenium_chrome:chrome.test \
	--link wptest:wp.test \
	--link wordpress:mytestsite.test \
	bcgovgdx/wpbroswer \
	$@
```

### chromium
