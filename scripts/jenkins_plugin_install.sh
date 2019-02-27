#!/bin/bash

plugin_dir=/var/lib/jenkins/plugins
file_owner=jenkins.jenkins

mkdir -p /var/lib/jenkins/plugins

function installPlugin() {
  if [ -f ${plugin_dir}/${1}.hpi -o -f ${plugin_dir}/${1}.jpi ]; then
    if [ "$2" == "1" ]; then
      return 1
    fi
    echo "Skipped: $1 (already installed)"
    return 0
  else
    echo "Installing: $1"
    curl -L --silent --output ${plugin_dir}/${1}.hpi  https://updates.jenkins-ci.org/latest/${1}.hpi
    return 0
  fi
}

if [[ ${data} == "" ]]; then
        data=${1}
fi

IFS=","
for plugin in $data
do
    installPlugin "$plugin"
done

echo "fixing permissions"
chown ${file_owner} ${plugin_dir} -R
echo "all done"