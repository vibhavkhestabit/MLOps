#!/bin/bash
set -euo pipefail

echo "=========================================="
echo "Initializing MongoDB Replica Set (rs0)..."
echo "=========================================="

# 1. Create isolated data directories for the 3 nodes
mkdir -p data/node1 data/node2 data/node3

# 2. Create the configuration file for Node 1 (Port 27017)
cat <<EOF > mongod-node1.conf
storage:
  dbPath: $(pwd)/data/node1
net:
  bindIp: 127.0.0.1
  port: 27017
replication:
  replSetName: rs0
processManagement:
  fork: true
systemLog:
  destination: file
  path: $(pwd)/data/node1/mongod.log
  logAppend: true
EOF

# 3. Create the configuration file for Node 2 (Port 27018)
cat <<EOF > mongod-node2.conf
storage:
  dbPath: $(pwd)/data/node2
net:
  bindIp: 127.0.0.1
  port: 27018
replication:
  replSetName: rs0
processManagement:
  fork: true
systemLog:
  destination: file
  path: $(pwd)/data/node2/mongod.log
  logAppend: true
EOF

# 4. Create the configuration file for Node 3 (Port 27019)
cat <<EOF > mongod-node3.conf
storage:
  dbPath: $(pwd)/data/node3
net:
  bindIp: 127.0.0.1
  port: 27019
replication:
  replSetName: rs0
processManagement:
  fork: true
systemLog:
  destination: file
  path: $(pwd)/data/node3/mongod.log
  logAppend: true
EOF

echo "[PASS] Created isolated data directories and configuration files."

# 5. Launch the three independent MongoDB daemon processes
mongod --config mongod-node1.conf
mongod --config mongod-node2.conf
mongod --config mongod-node3.conf

echo "[PASS] 3 MongoDB nodes launched in the background."

# 6. Wait a few seconds for the processes to boot up
sleep 5

# 7. Execute the JavaScript command to link them together into a Replica Set
echo "Configuring the Replica Set cluster..."
mongosh --port 27017 --eval '
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "127.0.0.1:27017" },
    { _id: 1, host: "127.0.0.1:27018" },
    { _id: 2, host: "127.0.0.1:27019" }
  ]
})
'

echo "=========================================="
echo "[SUCCESS] MongoDB Replica Set is ACTIVE."
echo "=========================================="