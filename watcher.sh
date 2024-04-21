#!/bin/bash
namespace="sre"
deployment="swype-app"
max_restarts=3

while true;do
    #restarts=$(kubectl get pods -n $namespace | awk -v var="$deployment" '$0 ~ var { print $4}')
    restarts=$(kubectl get pods -n ${namespace} -l app=${deployment} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
    echo "Current restart count: $restarts"
    if [[ $restarts -gt $max_restarts ]]; then 
        echo "Restart limit exceeded. Scaling down deployment.";
        kubectl scale deployment $deployment -n $namespace --replicas=0
        break 
    fi
    sleep 60
done
