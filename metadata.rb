lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'berkshelf/api/version'

name             "berkshelf-api"
maintainer       "Serghei Anicheev"
maintainer_email "anikeev1988@yandex.ru"
license          "Apache 2.0"
description      "Installs/Configures a berkshelf-api server"
long_description "Installs/Configures a berkshelf-api server"
version          Berkshelf::API::VERSION

supports "centos"

depends "libarchive",      "~> 0.4"
depends "github",          "~> 0.2"
