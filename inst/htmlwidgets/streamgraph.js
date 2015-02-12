HTMLWidgets.widget({

  name: 'streamgraph',

  type: 'output',

  initialize: function(el, width, height) {

    return {
      // TODO: add instance fields as required
    }

  },

  renderValue: function(el, params, instance) {


    // save params for reference from resize method
    instance.params = params;

    // draw the graphic
    this.drawGraphic(el, params, el.offsetWidth, el.offsetHeight);

  },

  drawGraphic: function(el, params, width, height) {

    // remove existing children
    while (el.firstChild)
      el.removeChild(el.firstChild);

    dbg = params;

    mkchart(HTMLWidgets.dataframeToD3(params.data),
      el,
      width, height,
      params);

  },

  resize: function(el, width, height, instance) {
    if (instance.params)
      this.drawGraphic(el, instance.params, width, height);
  }

});

var dbg ;
var dbg2 ;
var dbg3 ;
var dbg4 ;

var datearray = [];
var colorrange = [];

function mkchart(data, el, width, height, params) {

  var format = d3.time.format("%Y-%m-%d");

  dbg2 = data

  data.forEach(function(d) {
    d.date = format.parse(d.date);
    d.value = +d.value;
  });

  dbg2 = data

  var ncols = d3.map(data, function(d) { return(d.key) }).keys().length;
  if (ncols > 9) ncols = 9

  colorrange = colorbrewer[params.palette][ncols].reverse();
  strokecolor = colorrange[0];

  var margin = { top: 20, right: 40, bottom: 30, left: 40 };
  width = width - margin.left - margin.right;
  height = height - margin.top - margin.bottom;

  var tooltip ;
  var vertical;

  var x = d3.time.scale().range([0, width]);
  var y = d3.scale.linear().range([height-10, 0]);
  var z = d3.scale.ordinal().range(colorrange);
  var bisectDate = d3.bisector(function(d) { return d.date; }).left;

  var xAxis = d3.svg.axis().scale(x)
                .orient("bottom")
                .ticks(d3.time[params.x_tick_units],
                       params.x_tick_interval)
                .tickFormat(d3.time.format(params.x_tick_format))
                .tickPadding(8);
  var yAxis = d3.svg.axis().scale(y)
                .ticks(params.y_tick_count)
                .orient("left");

  var stack = d3.layout.stack()
  .offset("silhouette")
  .values(function(d) { return d.values; })
  .x(function(d) { return d.date; })
  .y(function(d) { return d.value; });

  var nest = d3.nest()
  .key(function(d) { return d.key; });

  var area = d3.svg.area()
  .interpolate("cardinal")
  .x(function(d) { return x(d.date); })
  .y0(function(d) { return y(d.y0); })
  .y1(function(d) { return y(d.y0 + d.y); });

  var svg = d3.select("#" + el.id).append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var layers = stack(nest.entries(data));
  var pro ;
  var mousedate ;

  x.domain(d3.extent(data, function(d) { return d.date; }));
  y.domain([0, d3.max(data, function(d) { return d.y0 + d.y; })]);

  svg.selectAll(".layer")
  .data(layers)
  .enter().append("path")
  .attr("class", "layer")
  .attr("d", function(d) { return area(d.values); })
  .style("fill", function(d, i) { return z(i); });

  if (params.interactive) {

    tooltip = d3.select("body")
    .append("div")
    .attr("class", "remove")
    .style("position", "absolute")
    .style("z-index", "20")
    .style("visibility", "hidden")
    .style("top", "30px")
    .style("left", "55px");

    svg.selectAll(".layer")
    .attr("opacity", 1)
    .on("mouseover", function(d, i) {
      svg.selectAll(".layer").transition()
      .duration(250)
      .attr("opacity", function(d, j) {
        return j != i ? 0.6 : 1;
      })})

    .on("mousemove", function(dd, i) {

      var x0 = x.invert(d3.mouse(this)[0]),
          i = bisectDate(data, x0, 1),
          d0 = data[i - 1],
          d1 = data[i],
          d = x0 - d0.date > d1.date - x0 ? d1 : d0;

      d3.select(this)
      .classed("hover", true)
      .attr("stroke", strokecolor)
      .attr("stroke-width", "0.5px"),
      tooltip.html( "<p>" + dd.key + " : " +
                    d.value + "</p>" ).style("visibility", "visible");
     })
    .on("mouseout", function(d, i) {
      svg.selectAll(".layer")
      .transition()
      .duration(300)
      .attr("opacity", "1");
      d3.select(this)
      .classed("hover", false)
      .attr("stroke-width", "0px"),
            tooltip.html( "<p>" + d.key + " : " +
            pro + "</p>" ).style("visibility", "hidden");
    })
  }

  svg.append("g")
  .attr("class", "x axis")
  .attr("transform", "translate(0," + height + ")")
  .call(xAxis);

  svg.append("g")
  .attr("class", "y axis")
  .call(yAxis);

//  if (params.interactive) {

    // white tracking line

//    vertical = d3.select("#" + el.id)
//    .append("div")
//    .attr("class", "remove")
//    .style("position", "absolute")
//    .style("z-index", "19")
//    .style("width", "0.5px")
//    .style("height", height+margin.top+margin.bottom + "px")
//    .style("top", "10px")
//    .style("height", "30px")
//    .style("bottom", "0px")
//    .style("left", "0px")
//    .style("background", "#000000");
//    .style("background", "#fff");

//   d3.select("#" + el.id)

//   .on("mousemove", function(){
//     mousex = d3.mouse(this);
//     mousex = mousex[0];
//     vertical.style("left", mousex + "px" )})

//   .on("mouseover", function(){
//     mousex = d3.mouse(this);
//     mousex = mousex[0];
//     vertical.style("left", mousex + "px")});

// }

}
