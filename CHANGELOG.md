# CHANGELOG

## 0.2.0
* add a fake transporter that can be used for testing without dependencies on an
  actual connected transporter

##  0.1.1
* fixes bug where event publishing uses the wrong method name to look up local events
* fixes condition where events may double publish when multiple events are registered