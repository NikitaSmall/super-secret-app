$(document).ready(function() {
  var data = {
    // A labels array that can contain any sort of values
    labels: ['Mon', 'Tue', 'Wed', 'Thu'],
    // Our series array that contains series objects or in this case series data arrays
    series: [
      [5, 2, 4, 12]
    ]
  };

  // Create a new line chart object where as first parameter we pass in a selector
  // that is resolving to our chart container element. The Second parameter
  // is the actual data object.
  new Chartist.Bar('#repo-chart', data);
});
