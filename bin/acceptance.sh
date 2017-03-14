#!/bin/bash

set -e
bin_dir=$(cd $(dirname $0) && pwd)
project_root=$(cd $bin_dir/.. && pwd)
node_modules_path=$(cd $project_root/node_modules && pwd)

PATH=.bin:$node_modules_path/.bin:$PATH

chromedriver_version=2.28
selenium_version=3.3
selenium_jar_version=3.3.1

function get_chromedriver {
  mkdir -p tmp/chromedriver
  pushd tmp/chromedriver
    echo "Installing chromedriver"
    curl -LO "https://chromedriver.storage.googleapis.com/$chromedriver_version/chromedriver_mac64.zip"
    unzip chromedriver_mac64.zip
    chmod a+x chromedriver
    mv chromedriver $project_root/.bin
  popd

  rm -rf tmp/chromedriver
}

function get_selenium_standalone {
  echo "Fetching selenium standalone jar"
  pushd .bin
    curl -O http://selenium-release.storage.googleapis.com/$selenium_version/selenium-server-standalone-$selenium_jar_version.jar
  popd
}

function start_selenium {
  java -jar .bin/selenium-server-standalone-$selenium_jar_version.jar > /dev/null 2>&1 &
  selenium_pid=$!
  echo "Started selenium with pid $selenium_pid"
}

function start_app {
  NODE_ENV=test yarn start > /dev/null 2>&1 &
  app_pid=$!
  echo "Started app with pid $app_pid"
}

function wait_for_app {
  set +e
  app_status=$(curl -sL -w "%{http_code}\\n" "http://localhost:3001" -o /dev/null)
  while [ $app_status -ne 200 ]; do
    printf  "."
    sleep 0.5
    app_status=$(curl -sL -w "%{http_code}\\n" "http://localhost:3001" -o /dev/null)
  done
  set -e
}

function clean_up {
  echo "Killing app with pid $app_pid"
  pkill -15 -P $app_pid
  echo "Killing selenium with pid $selenium_pid"
  kill -15 $selenium_pid
}

trap clean_up EXIT

pushd $project_root > /dev/null
  mkdir -p .bin

  [ ! -e .bin/chromedriver ] && get_chromedriver
  [ ! -e .bin/selenium-server-standalone-$selenium_jar_version.jar ] && get_selenium_standalone

  start_selenium
  start_app

  printf "Waiting for app to come online"
  wait_for_app

  echo
  echo "Running Acceptance Tests"
  wdio wdio.conf.js
popd > /dev/null

exit 0
