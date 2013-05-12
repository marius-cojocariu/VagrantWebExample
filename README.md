Vagrant Web Example
=================

Simple vagrant template for creating a php web development environment.

What it does: provisions the vagrant box with apache, php and mysql. Setups the correct permissions for required directories. Adds phpmyadmin to the mix.
Uses a collection of puppet modules from the puppet forge. All credits goes to them and the creators of vagrant.

How to use:

Simply copy the puppet directory and Vagrantfile to your project dir and run the command 
```
vagrant up
```

The password for mysql's root is 
```
asd123
```

Don't forget to check the Vagrantfile for options.
