# Dockerfile for AMQ for Openshift v3 with JDBC Persistence

Based from the [Jboss A-MQ Paas Image](https://docs.openshift.com/enterprise/3.1/using_images/xpaas_images/a_mq.html)

Using [Source2Image stuff](https://github.com/openshift/source-to-image)

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

	docker run -d --restart=always \
	  -v /var/appdata/postgres-db:/var/lib/postgresql \
	  -v /var/appdata/postgres-db/recon-db/data:/var/lib/postgresql/data \
	  -e POSTGRES_PASSWORD=postgresql \
	  -p 5432:5432 \
	  --name postgres-db \
	  postgres:9.5

## Build it

	s2i build git://github.com/pmorie/simple-ruby openshift/ruby-20-centos7 test-ruby-app

	s2i build git@github.com:welshstew/jboss-amq-jdbc-dockerfile.git registry.access.redhat.com/jboss-amq-6/amq62-openshift test-amq-app