function drawChart() {
  var series = [
    { name: "estimate",
      data: [],
      color: 'rgba(255,100,100,0.6)',
      stroke: 'rgba(0,0,0,0.15)'
    }, {
      name: "spent",
      data: [],
      color: 'rgba(100,100,255,0.6)',
      stroke: 'rgba(0,0,0,0.15)'
    } ];
      
  d3.text("http://localhost:4567/q/redmine_burndown", function(d) {
    s = d.replace(/"/g, '').split("\n");
    for (var i = 0; i < s.length; i++) {
      r = s[i].split(",");
      if ( r[0] == "estimate") {
        series[0]["data"].push({ x: parseInt(r[2]), y: parseFloat(r[1]) }); 
      }
      if ( r[0] == "spent") {
        series[1]["data"].push({ x: parseInt(r[2]), y: parseFloat(r[1]) }); 
      }
    };

    var graph = new Rickshaw.Graph( {
      element: document.querySelector("#chart"),
      width: 800,
      height: 350,
      interpolation: 'basis',
      renderer: 'area',
      stroke: true,
      series: series
    });

    var x_axis = new Rickshaw.Graph.Axis.Time( { graph: graph } );

    var y_axis = new Rickshaw.Graph.Axis.Y( {
      graph: graph,
      orientation: 'left',
      tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
      element: document.getElementById('y_axis'),
    });

    var legend = new Rickshaw.Graph.Legend( {
      element: document.querySelector('#legend'),
      graph: graph
    });

    graph.renderer.unstack = true;
    graph.render();
    
  });
}
