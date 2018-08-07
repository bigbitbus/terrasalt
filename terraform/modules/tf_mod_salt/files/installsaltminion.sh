#!/usr/bin/env bash

#   Copyright 2018 BigBitBus Inc. http://bigbitbus.com
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

cd /tmp
curl -o bootstrap-salt.sh -L https://bootstrap.saltstack.com
sudo sh bootstrap-salt.sh $4
curl -L https://bootstrap.saltstack.com | sudo sh
mkdir -p /etc/salt/minion.d/
cat << EOF | sudo tee /etc/salt/minion.d/min.conf
# Terraform's installsaltminion.sh added config start
mine_interval: 1
master: $1
id: $2
grains:
  platformgrain: $3
# Terraform's installsaltminion.sh added config end
EOF
service salt-minion restart

