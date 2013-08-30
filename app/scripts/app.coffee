'use strict'

angular.module('rottenListApp', ['ui.select2', 'angular-lodash'])
  .config ($routeProvider, $locationProvider)->
    $routeProvider
      .when('/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      )
      .otherwise
        redirectTo: '/'
    $locationProvider.html5Mode on
