# Dockerfile for AMQ for Openshift v3 with JDBC Persistence

Based from the [Jboss A-MQ Paas Image](https://docs.openshift.com/enterprise/3.1/using_images/xpaas_images/a_mq.html)

Using [Source2Image stuff](https://github.com/openshift/source-to-image)

[Other docs](https://docs.openshift.com/enterprise/3.0/creating_images/s2i.html)

## What it should do...

1.  Override the openshift-activemq.xml with one that supports JDBC postgresql
2.  Include the postgresql libs into the image
3.  hopefully run up an image connected to postgresql...!


## Extra Environment Variables

In addition to the existing Jboss A-MQ Paas Image vars, you'll need the following:

	AMQ_LOCK_KEEP_ALIVE_PERIOD=5000
	AMQ_DB_CREATE_TABLE_ON_STARTUP="false"
	AMQ_LOCK_ACQUIRE_SLEEP_INTERVAL=10000
	AMQ_MAX_ALLOWABLE_DIFF_FROM_DB_TIME=1000

	AMQ_DB_HOST=
	AMQ_DB_NAME=
	AMQ_DB_PORT=5432
	AMQ_DB_USER=root
	AMQ_DB_PASS=
	AMQ_DB_INIT_CONNECTION=1
	AMQ_DB_MAX_CONNECTION=10

## needs a postgres - docker run command

	docker run -Pitd <imageID> --link postgres-db:postgres


	docker run -Pitd 

## Build it

	s2i build git://github.com/pmorie/simple-ruby openshift/ruby-20-centos7 test-ruby-app

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

	oc new-app registry.access.redhat.com/jboss-amq-6/amq62-openshift:1.2~https://github.com/welshstew/jboss-amq-jdbc-dockerfile.git  \
	-e AMQ_LOCK_KEEP_ALIVE_PERIOD=5000 \
	-e AMQ_DB_CREATE_TABLE_ON_STARTUP=false \
	-e AMQ_LOCK_ACQUIRE_SLEEP_INTERVAL=10000 \
	-e AMQ_MAX_ALLOWABLE_DIFF_FROM_DB_TIME=1000 \
	-e AMQ_DB_HOST=192.168.99.100 \
	-e AMQ_DB_NAME=postgres \
	-e AMQ_DB_PORT=5432 \
	-e AMQ_DB_USER=postgres \
	-e AMQ_DB_PASS=postgresql \
	-e AMQ_DB_INIT_CONNECTION=1 \
	-e AMQ_DB_MAX_CONNECTION=10 \
	--name=amqz

	# this command will create the app in openshift and generate a buildConfig (bc) and a deploymentConfig (dc)
	oc new-app registry.access.redhat.com/jboss-amq-6/amq62-openshift:1.2~https://github.com/welshstew/jboss-amq-jdbc-dockerfile.git --name=petstorez

	oc policy add-role-to-user admin admin -n amq-test-1

## TODO:

1.  replace:

	<persistenceAdapter>
        <kahaDB directory="${activemq.data}/kahadb" />
    </persistenceAdapter>	

    with:

	content from postgres-jdbc-persistence-adapter.xml

2.  Append between </broker> and </beans> the jdbc bean	
