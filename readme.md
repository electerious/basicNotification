# basicNotification

Easy-to-use notification-system for your website or webapp.

![Notification Screenshot](http://l.electerious.com/uploads/big/0721157332ff59313b7601382036a20b.png)

## Installation

	bower install basicNotification
	
## Requirements

basicNotification requires jQuery >= 2.1.0
	
## How to use

Simply include the following files in your HTML:

```html
<link type="text/css" rel="stylesheet" href="bower_components/basicNotification/dist/basicNotification.min.css">
<script async type="text/javascript" src="bower_components/jQuery/dist/jquery.min.js"></script>
<script async type="text/javascript" src="bower_components/basicNotification/dist/basicNotification.min.js"></script>
```

Show a context-menu by using the following command:

```coffee
loading = basicNotification.show {
	icon: 'ios7-clock'
	text: 'Still loading ...'
	pin: false
}
```