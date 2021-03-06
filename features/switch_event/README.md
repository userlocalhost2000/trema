# Switch Event forwarding API

This API controls the forwarding of certain type of Openflow messages received from a switch to a specified controller. 
The processes responsible for this are Switch Manager and Switch Daemons.   

This API can be used for: 

* Diagnosing a controller environment:
    * Check which controller is handling the messages from a certain switch. 
    * Forward a copy of a message to another user-defined controller 
      for debug level logging, etc. 
* Dynamically change configuration to:
    * Add/Remove a controller on a running network setup. 
    * Replace a running controller with another controller. 

Switch events, are OpenFlow messages sent from switches on various types of events,
and forwarded to controllers based on the event forwarding entries of each Switch Daemon. 
Initial forwarding entries of a Switch Daemon derived from the
forwarding entries of the Switch Manager, when a switch first connects to trema. 

In other words, configuring a Switch Daemon changes the behavior of
existing connected switches, and configuring a Switch Manager changes the behavior
of switches that may connect later on. 

Following switch event types can be forwarded by this API: 

* :vendor
* :packet_in
* :port_stat
* :state_notify

Note that this API only change where each event is forwarded, 
and it will **not** emulate any switch events, which normally occur when a 
switch is connected to or disconnected from a controller.

* switch_ready event will **not** be generated by adding an entry to an existing switch.
* disconnected event will **not** be generated by removing an entry from an existing switch.

Please see the YARD generated document for method details.

