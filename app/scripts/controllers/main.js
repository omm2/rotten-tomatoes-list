// Generated by CoffeeScript 1.6.3
'use strict';
angular.module('rottenListApp').controller('MainCtrl', function($scope) {
  return $scope.select2Options = {
    placeholder: "Search for a movie",
    minimumInputLength: 1,
    ajax: {
      url: "http://api.rottentomatoes.com/api/public/v1.0/movies.json",
      dataType: 'jsonp',
      data: function(term, page) {
        return {
          q: term,
          page_limit: 10,
          apikey: "ju6z9mjyajq2djue3gbvv26t"
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
        return $.ajax("http://api.rottentomatoes.com/api/public/v1.0/movies/" + id + ".json", {
          data: {
            apikey: "ju6z9mjyajq2djue3gbvv26t"
          },
          dataType: "jsonp"
        }).done(function(data) {
          return callback(data);
        });
      }
    },
    formatResult: function(m) {
      return m.title;
    },
    formatSelection: function(m) {
      return m.title;
    },
    dropdownCssClass: "bigdrop",
    escapeMarkup: function(m) {
      return m;
    }
  };
});