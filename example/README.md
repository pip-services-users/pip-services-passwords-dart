# Examples for Passwords Microservice

This is a password authentication microservice from Pip.Services library. 
* Sets user passwords and authenticate
* Safely change passwords
* Reset and recover passwords via emails

Define configuration parameters that match the configuration of the microservice's external API
```dart
// Service/Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the service
```dart
persistence = PasswordsMemoryPersistence();
persistence.configure(ConfigParams());

controller = PasswordsController();
controller.configure(ConfigParams());

service = PasswordsHttpServiceV1();
service.configure(httpConfig);

var references = References.fromTuples([
    Descriptor('pip-services-passwords', 'persistence', 'memory',
        'default', '1.0'),
    persistence,
    Descriptor('pip-services-passwords', 'controller', 'default',
        'default', '1.0'),
    controller,
    Descriptor(
        'pip-services-passwords', 'service', 'http', 'default', '1.0'),
    service
]);

controller.setReferences(references);
service.setReferences(references);

await persistence.open(null);
await service.open(null);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = PasswordsHttpClientV1(config);

// Configure the client
client.configure(httpConfig);

// Connect to the microservice
try{
  await client.open(null)
}catch() {
  // Error handling...
}       
// Work with the microservice
// ...
```

Now the client is ready to perform operations
```dart
// Create a new password
final USER_PWD = UserPasswordV1(id: '1', password: 'password123');

    // Create the password
    try {
      await client.setPassword('123', USER_PWD.id, USER_PWD.password);
      // Do something with the returned password...
    } catch(err) {
      // Error handling...     
    }
```

```dart
// Authenticated
try {
var authenticated =
          await controller.authenticate(null, USER_PWD.id, 'password123');
    // Do something with authentication...

    } catch(err) { // Error handling}
``` 

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services-users/pip-services-passwords-dart/tree/master/test).
