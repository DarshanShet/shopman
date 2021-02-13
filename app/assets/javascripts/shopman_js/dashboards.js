var dashboards = new function () {
  var me = this;

  this.pageLoad = function(){
    me.salesChart();
    me.customerAmountPending();
  }

  this.salesChart = function(){
    var $chart = $('#yearlySale');

    var salesChart = new Chart($chart, {
      type: 'line',
      options: {
        scales: {
          yAxes: [{
            ticks: {
              // Include a dollar sign in the ticks
              callback: function(value, index, values) {
                  return '₹' + value;
              }
            },
            scaleLabel: {
              display: true,
              labelString: 'Sale'
            }
          }],
          xAxes: [{ 
            scaleLabel: {
              display: true,
              labelString: 'Month'
            }
          }]
        },
        tooltips: {
          callbacks: {
            label: function(item, data) {
              var label = data.datasets[item.datasetIndex].label || '';
              var yLabel = item.yLabel;
              var content = '';

              if (data.datasets.length > 1) {
                content += label + " ";
              }

              content += `₹ ${yLabel}`;
              return content;
            }
          }
        }
      },
      data: {
        labels: $chart.data("labels"),
        datasets: [{
          label: 'Receivings',
          borderColor: 'blue',
          fill: false,
          data: $chart.data("receiving_sale")
        },
        {
          label: 'Billings',
          borderColor: 'red',
          fill: false,
          data: $chart.data("billing_sale")
        }]
      }
    });

    // Save to jQuery object

    $chart.data('chart', salesChart);
  }

  this.customerAmountPending = function(){
    var $chart = $('#billingSale');

    var ordersChart = new Chart($chart, {
      type: 'bar',
      options: {
        scales: {
          yAxes: [{
            ticks: {
              // Include a dollar sign in the ticks
              callback: function(value, index, values) {
                  return '₹' + value;
              }
            },
            scaleLabel: {
              display: true,
              labelString: 'Sale'
            }
          }],
          xAxes: [{
            scaleLabel: {
              display: true,
              labelString: 'Month'
            }
          }]
        }
      },
			data: {
				labels: $chart.data("labels"),
				datasets: [{
          label: 'Sales',
          backgroundColor: [
            'rgb(255, 99, 132)',
            'rgb(54, 162, 235)',
            'rgb(255, 206, 86)',
            'rgb(75, 192, 192)',
            'rgb(153, 102, 255)',
            'rgb(255, 159, 64)',
            'rgb(175,238,238)',
            'rgb(147,112,219)',
            'rgb(255,20,147)',
            'rgb(210,105,30)',
            'rgb(50,205,50)',
            'rgb(255,215,0)',
          ],
					data: $chart.data("billing_sale")
				}]
			}
		});

		// Save to jQuery object
		$chart.data('chart', ordersChart);
  }
}