(function() {
  'use strict';
  angular.module('rottenListApp', ['ui.select2', 'angular-lodash']).config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/', {
      templateUrl: 'views/main.html',
      controller: 'MainCtrl'
    }).otherwise({
      redirectTo: '/'
    });
    return $locationProvider.html5Mode(true);
  });

}).call(this);
