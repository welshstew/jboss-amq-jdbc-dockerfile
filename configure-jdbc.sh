#!/bin/sh
OPENSHIFT_CONFIG_FILE=$AMQ_HOME/conf/openshift-activemq.xml
CONFIG_FILE=$AMQ_HOME/conf/activemq.xml
POSTGRES_PA_SNIPPET=$AMQ_HOME/conf/postgres-jdbc-persistence-adapter.xml
POSTGRES_DB_SNIPPET=$AMQ_HOME/conf/postgres-db-snippet.xml


# Finds the environment variable  and returns its value if found.
# Otherwise returns the default value if provided.
#
# Arguments:
# $1 env variable name to check
# $2 default value if environemnt variable was not set
function find_env() {
  var=`printenv "$1"`

  # If environment variable exists
  if [ -n "$var" ]; then
    echo $var
  else
    echo $2
  fi
}


function configureJdbcPersistence() {

	amqLockKeepAlivePeriod="${AMQ_LOCK_KEEP_ALIVE_PERIOD}"
	amqCreateTablesOnStart="${AMQ_DB_CREATE_TABLE_ON_STARTUP}"
	amqLockAquireSleepInterval="${AMQ_LOCK_ACQUIRE_SLEEP_INTERVAL}"
	amqMaxAllowableDiffFromDbTime="${AMQ_MAX_ALLOWABLE_DIFF_FROM_DB_TIME}"
	
	amqDbHost="${AMQ_DB_HOST}"
	amqDbName="${AMQ_DB_NAME}"
	amqDbPort="${AMQ_DB_PORT}"
	amqDbUser="${AMQ_DB_USER}"
	amqDbPassword="${AMQ_DB_PASS}"

	amqDbInitialConnections="${AMQ_DB_INIT_CONNECTION}"
	amqDbMaxConnections="${AMQ_DB_MAX_CONNECTION}"


	# PA BEAN (persistenceAdapter)
	sed -i "s|#amqLockKeepAlivePeriod|${amqLockKeepAlivePeriod}|" "${POSTGRES_PA_SNIPPET}"
    sed -i "s|#amqCreateTablesOnStart|${amqCreateTablesOnStart}|" "${POSTGRES_PA_SNIPPET}"
    sed -i "s|#amqLockAquireSleepInterval|${amqLockAquireSleepInterval}|" "${POSTGRES_PA_SNIPPET}"
    sed -i "s|#amqMaxAllowableDiffFromDbTime|${amqMaxAllowableDiffFromDbTime}|" "${POSTGRES_PA_SNIPPET}"

	echo "replacing PERSISTENCE_ADAPTER"
    pasnippet=$(cat ${POSTGRES_PA_SNIPPET})
	sed -i "s|<!-- ##### PERSISTENCE_ADAPTER ##### -->|${pasnippet}|" "$CONFIG_FILE"
  
	# DB BEAN
    sed -i "s|#amqDbHost|${amqDbHost}|" "${POSTGRES_DB_SNIPPET}"
    sed -i "s|#amqDbName|${amqDbName}|" "${POSTGRES_DB_SNIPPET}"
    sed -i "s|#amqDbPort|${amqDbPort}|" "${POSTGRES_DB_SNIPPET}"
    sed -i "s|#amqDbUser|${amqDbUser}|" "${POSTGRES_DB_SNIPPET}"
    sed -i "s|#amqDbPassword|${amqDbPassword}|" "${POSTGRES_DB_SNIPPET}"
    sed -i "s|#amqDbInitialConnections|${amqDbInitialConnections}|" "${POSTGRES_DB_SNIPPET}"
    sed -i "s|#amqDbMaxConnections|${amqDbMaxConnections}|" "${POSTGRES_DB_SNIPPET}"

	echo "replacing DATASOURCE_BEAN"
    dbsnippet=$(cat ${POSTGRES_DB_SNIPPET})
	
	sed -i "s|<!-- ##### DATASOURCE_BEAN ##### -->|${dbsnippet}|" "$CONFIG_FILE"
  
}


configureJdbcPersistence