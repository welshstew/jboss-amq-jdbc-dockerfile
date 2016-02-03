#!/bin/sh
echo "Running configure"
. $AMQ_HOME/bin/configure.sh
echo "Running configure-jdbc"
. $AMQ_HOME/bin/configure-jdbc.sh
. /usr/local/dynamic-resources/dynamic_resources.sh

MAX_HEAP=`get_heap_size`
if [ -n "$MAX_HEAP" ]; then
  ACTIVEMQ_OPTS="-Xms${MAX_HEAP}m -Xmx${MAX_HEAP}m"
fi

# Add command line options
cat <<EOF > $AMQ_HOME/bin/env
ACTIVEMQ_OPTS="${ACTIVEMQ_OPTS}"
EOF

echo "Running $JBOSS_IMAGE_NAME image, version $JBOSS_IMAGE_VERSION-$JBOSS_IMAGE_RELEASE"

exec $AMQ_HOME/bin/activemq console
