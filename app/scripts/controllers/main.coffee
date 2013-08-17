'use strict'

angular.module('rottenListApp')
  .controller('MainCtrl', ($scope)->

    $scope.select2Options =
        placeholder: "Search for a movie"
        minimumInputLength: 1
        ajax:
            url: "http://api.rottentomatoes.com/api/public/v1.0/movies.json"
            dataType: 'jsonp',
            data: (term, page)->
              q: term, #search term
              page_limit: 10,
              apikey: "ju6z9mjyajq2djue3gbvv26t" #please do not use so this example keeps working
            results: (data, page)-> #parse the results into the format expected by Select2.
              #since we are using custom formatting functions we do not need to alter remote JSON data
              results: data.movies
        initSelection: (element, callback)->
          #the input tag has a value attribute preloaded that points to a preselected movie's id
          # this function resolves that id attribute to an object that select2 can render
          # using its formatResult renderer - that way the movie name is shown preselected
          id = $(element).val()
          if (id isnt "")
              $.ajax("http://api.rottentomatoes.com/api/public/v1.0/movies/"+id+".json", {
                  data:
                    apikey: "ju6z9mjyajq2djue3gbvv26t"
                  dataType: "jsonp"
              }).done((data)-> callback(data))
        formatResult: (m)-> m.title #omitted for brevity, see the source of this page
        formatSelection: (m)-> m.title  #omitted for brevity, see the source of this page
        dropdownCssClass: "bigdrop", #apply css that makes the dropdown taller
        escapeMarkup: (m)-> m #we do not want to escape markup since we are displaying html in results
  )
