(function() {
  'use strict';
  angular.module('rottenListApp').factory('location', [
    '$location', '$route', '$rootScope', function($location, $route, $rootScope) {
      $location.skipReload = function() {
        var lastRoute, un;
        lastRoute = $route.current;
        un = $rootScope.$on('$locationChangeSuccess', function() {
          $route.current = lastRoute;
          return un();
        });
        return $location;
      };
      return $location;
    }
  ]).controller('MainCtrl', function($scope, $location, $http, location) {
    $scope.separator = ",";
    $scope.apikey = "gbngrekn754krwuqf7ajaumr";
    $scope.movies = [];
    $scope.getUrlIds = function(idsStr) {
      var ids, splits;
      ids = [];
      splits = idsStr.split($scope.separator);
      _.each(splits, function(id) {
        return ids.push(parseInt(id));
      });
      return ids;
    };
    $scope.updateList = function() {
      var ids, xhrs;
      if ($location.search().movies) {
        xhrs = [];
        ids = $scope.getUrlIds($location.search().movies);
        return _.each(ids, function(id) {
          console.log(id);
          return $http.jsonp("http://api.rottentomatoes.com/api/public/v1.0/movies/" + id + ".json?apikey=" + $scope.apikey, {
            params: {
              "callback": "JSON_CALLBACK"
            }
          }).success(function(data, status, headers, config) {
            return $scope.movies.push(data);
          });
        });
      }
    };
    $scope.updateList();
    $scope.select2Options = {
      placeholder: "PRESS ME",
      minimumInputLength: 1,
      dropdownCssClass: "header-drop",
      ajax: {
        url: "http://api.rottentomatoes.com/api/public/v1.0/movies.json",
        dataType: 'jsonp',
        data: function(term, page) {
          return {
            q: term,
            page_limit: 10,
            apikey: $scope.apikey
          };
        },
        results: function(data, page) {
          return {
            results: data.movies
          };
        }
      },
      initSelection: function(element, callback) {
        var id;
        id = $(element).val();
        if (id !== "") {
          return $scope.fetchMovie(id, callback);
        }
      },
      formatResult: function(m) {
        return m.title;
      },
      formatSelection: function(m) {
        return m.title;
      },
      escapeMarkup: function(m) {
        return m;
      }
    };
    $scope.fetchMovie = function(id, callback) {
      return $.ajax("http://api.rottentomatoes.com/api/public/v1.0/movies/" + id + ".json", {
        data: {
          apikey: "gbngrekn754krwuqf7ajaumr"
        },
        dataType: "jsonp"
      }).done(function(data) {
        return callback(data);
      });
    };
    return $scope.change = function(e) {
      var ids, idsStr, movie;
      movie = $scope.select2;
      console.log(movie);
      if ($location.search().movies) {
        ids = $scope.getUrlIds($location.search().movies);
        if (_.indexOf(ids, parseInt(movie.id)) === -1) {
          ids.push(parseInt(movie.id));
        }
        idsStr = ids.join(",");
      } else {
        idsStr = "" + movie.id;
      }
      $scope.movies.push(movie);
      return location.skipReload().search({
        movies: idsStr
      });
    };
  });

}).call(this);
