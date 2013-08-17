'use strict'

angular.module('rottenListApp', ['ui.select2'])
  .config ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      )
      .otherwise
        redirectTo: '/'
