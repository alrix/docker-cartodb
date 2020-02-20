# Overview
CartoDB build in docker using upstream documentation at https://cartodb.readthedocs.io/en/latest/install.html. This setup differs slightly from others on the internet in that it uses three separate images. One for postgres with the cartodb extensions installed, one for redis and one for the cartodb ruby/nodejs apps.

# Building
There are three docker images to build, one in each subdirectory - cartodb, redis and postgresql.

You will need to update the config files under config replacing the hostname with where you are installing cartodb.

