[webappservers]
%{ for ip in webappserver  ~}
${ip}
%{ endfor ~}

