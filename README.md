# Dockerfile for AMQ for Openshift v3 with JDBC Persistence

Based from the [Jboss A-MQ Paas Image](https://docs.openshift.com/enterprise/3.1/using_images/xpaas_images/a_mq.html)

Using [Source2Image stuff](https://github.com/openshift/source-to-image)

[Other docs](https://docs.openshift.com/enterprise/3.0/creating_images/s2i.html)

## What it should do...

1.  Override the openshift-activemq.xml with one that supports JDBC postgresql
2.  Include various jdbc libs into the image
3.  hopefully run up an image connected to db...! (default in memory hsql)


## Build it

### s2i locally

	s2i build git@github.com:welshstew/jboss-amq-jdbc-dockerfile.git registry.access.redhat.com/jboss-amq-6/amq62-openshift test-amq-app

	docker run -d \
	-e AMQ_LOCK_KEEP_ALIVE_PERIOD="5000" \
	-e AMQ_DB_CREATE_TABLE_ON_STARTUP="false" \
	-e AMQ_LOCK_ACQUIRE_SLEEP_INTERVAL="10000" \
	-e AMQ_MAX_ALLOWABLE_DIFF_FROM_DB_TIME="1000" \
	-e AMQ_DB_HOST="192.168.99.100" \
	-e AMQ_DB_NAME="postgres" \
	-e AMQ_DB_PORT="5432" \
	-e AMQ_DB_USER="postgres" \
	-e AMQ_DB_PASS="postgresql" \
	-e AMQ_DB_INIT_CONNECTION="1" \
	-e AMQ_DB_MAX_CONNECTION="10" --name test-amq test-amq-app

### s2i on openshift

	oc new-build registry.access.redhat.com/jboss-amq-6/amq62-openshift:1.2~https://github.com/welshstew/jboss-amq-jdbc-dockerfile.git

## Getting it up and running (3 broker mesh)	

	#create the template in the namespace
	oc create -n namespace -f amq-ssl-jdbc-presisted-template.json

	#create the service account "amq-service-account"
	oc create -f https://gist.githubusercontent.com/welshstew/08daeeef046aeb3ceb9b8b39c9e0d243/raw/1c9535126b57ab7c8adc4ae0859583c20c25eca9/amq-service-account.json

	#ensure the service account is added to the namespace for view permissions... (for pod scaling)
	oc policy add-role-to-user view system:serviceaccount:namespace:amq-service-account

	#ensure the secrets are added… (two files can go in one secret) (both broker.ks and broker.ts)
	oc secrets new amq-app-secret /Users/swinchester/sourcetree/activemq-broker-projects/simple-spring-amq/src/main/resources/just_keystores

	#use the template in the namespace then to create your app (3 broker mesh)
	oc new-app amq62-ssl-jdbc-custom




