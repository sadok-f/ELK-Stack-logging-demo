# ELK Stack for single Vagrant machine with many containers

## Description:

Simple Demo installation contain ELK Stack (Elasticseach, Logstash, Kibana) containers runs inside a Vagrant machine.

The docker-compose file contain 5 services:

- **elasticsearch**: a database that store JSON documents.
- **logstash**: consume data from many source, processes it and then send it to Elasticsearch.
- **kibana**: visualize the Elasticsearch data and query it.
- **logspout**: Log routing for Docker container logs (+logstash plugin to push it to logstash)
- **flyimg**: a Demo php application for resizing images on the fly


## Installation:

- Clone the repo
- Install vagrant
- Install Docker compose plugin : `vagrant plugin install vagrant-docker-compose`
- Up the Vm: `vagrant up`

## Usage:
- It might take some time for Kibana to load up, wait for a few minutes and try again.
- To follow the logs: ssh to the vagrant machine `vagrant ssh` , `cd /vagrant` and then `docker-compose log -f`
- Access Kibana interface: [http://192.168.33.11:5601/app/kibana](http://192.168.33.11:5601/app/kibana)
- Access and test the PHP demo application : [http://192.168.33.11:8080/upload/w_300,h_250,c_1/https://m0.cl/t/resize-test_1920.jpg](http://192.168.33.11:8080/upload/w_300,h_250,c_1/https://m0.cl/t/resize-test_1920.jpg)

## Useful Commands:
- Getting indices created in Elasticsearch : `curl '192.168.33.11:9200/_cat/indices?v'`



# ELK Stack For Docker Swarm

## Installation:

- Clone the repo

## Set up your swarm:

- Create a couple of VMs using docker-machine:
    - `docker-machine create --driver virtualbox --virtualbox-memory "3072" manager`
    - `docker-machine create --driver virtualbox worker1`
    
- Fixing out of memory error for Elasticsearch:
    - `docker-machine ssh manager sudo sysctl -w vm.max_map_count=262144`
    - `docker-machine ssh worker1 sudo sysctl -w vm.max_map_count=262144`
    
- Instruct `manager` VM to become a Swarm manager:
    - Copy the IP address for `manager` by running `docker-machine ip manager`
    - `docker-machine ssh manager "docker swarm init --advertise-addr 192.168.99.100:2377"`

- the response to docker swarm init contains a pre-configured docker swarm join command for you to run on any nodes you want to add. Copy this command, and send it to worker1 via docker-machine ssh to have worker1 join your new swarm as a worker:
    - `docker-machine ssh worker1 "docker swarm join \
       --token <token> \
       <ip>:<port>"`

## Deploy your app on a cluster
    
- Copy `docker-stack.yml` file the manager node:
    - `docker-machine scp -r docker-stack.yml manager:~`
    
- Copy `logstash.conf` file the manager node:
    - `docker-machine scp -r logstash/pipeline/logstash.conf manager:~`
    
- Deploy the app:
    - `docker-machine ssh manager "docker stack deploy -c docker-stack.yml elk"`
    
- See all containers have been distributed between both nodes `manager` and `worker1`:
    - `docker-machine ssh manager "docker stack ps elk"`
    
## Usage: 

- It might take some time for Kibana to load up, wait for a few minutes and try again.
- to get the manager ip :  `docker-machine ip manager`

- Kibana:
    - http://192.168.99.100:5601/app/kibana
    
- Visualizer:
    - http://192.168.99.100:8081/