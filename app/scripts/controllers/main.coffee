'use strict'

angular.module('rottenListApp')
  .factory('location', [
    '$location',
    '$route',
    '$rootScope',
    ($location, $route, $rootScope) ->
      $location.skipReload = ->
        lastRoute = $route.current
        un = $rootScope.$on('$locationChangeSuccess', ->
          $route.current = lastRoute
          un()
        )
        $location
      $location
  ])
  .controller('MainCtrl', ($scope, $location, location)->
    $scope.separator = ","
    $scope.apikey = "gbngrekn754krwuqf7ajaumr"
    $scope.movies = []
    if $location.search().movies
      ids = $scope.getUrlIds $location.search().movies
      $.ajax("http://api.rottentomatoes.com/api/public/v1.0/movies/"+id+".json", {
          data:
            apikey: "gbngrekn754krwuqf7ajaumr"
          dataType: "jsonp"
      }).done((data)-> callback(data))

    console.log $location.search()
    $scope.select2Options =
        placeholder: "Search for a movie"
        minimumInputLength: 1
        dropdownCssClass: "header-drop"
        ajax:
            url: "http://api.rottentomatoes.com/api/public/v1.0/movies.json"
            dataType: 'jsonp',
            data: (term, page)->
              q: term, #search term
              page_limit: 10,
              apikey: $scope.apikey #please do not use so this example keeps working
            results: (data, page)-> #parse the results into the format expected by Select2.
              #since we are using custom formatting functions we do not need to alter remote JSON data
              results: data.movies
        initSelection: (element, callback)->
          #the input tag has a value attribute preloaded that points to a preselected movie's id
          # this function resolves that id attribute to an object that select2 can render
          # using its formatResult renderer - that way the movie name is shown preselected
          id = $(element).val()
          if (id isnt "")
            $scope.fetchMovie(id, callback)

        formatResult: (m)-> 
          m.title #omitted for brevity, see the source of this page
        formatSelection: (m)-> m.title  #omitted for brevity, see the source of this page
        escapeMarkup: (m)-> m #we do not want to escape markup since we are displaying html in results

    $scope.fetchMovie = (id, callback)->
      $.ajax("http://api.rottentomatoes.com/api/public/v1.0/movies/"+id+".json", {
          data:
            apikey: "gbngrekn754krwuqf7ajaumr"
          dataType: "jsonp"
      }).done((data)-> callback(data))


    $scope.change = (e)->
      movie = $scope.select2
      if $location.search().movies
        ids = $scope.getUrlIds $location.search().movies
        if _.indexOf(ids, parseInt movie.id) is -1
          ids.push parseInt(movie.id)
        idsStr = ids.join ","
      else
        idsStr = "#{movie.id}"
      $scope.movies.push movie
      location.skipReload().search(movies: idsStr)
      #$location.skipReload().path('/thing/' + id).replace();
      console.log $scope.movies

    $scope.getUrlIds = (idsStr)->
      ids = []
      splits = idsStr.split $scope.separator
      _.each splits, (id)->
        ids.push parseInt(id)
      ids

  )
