[kafka_broker_hosts]
%{ for ip in kube-control-plane ~}
${ip}
%{ endfor ~}

[test_client_hosts]
%{ for ip in kube-worker ~}
${ip}
%{ endfor ~}