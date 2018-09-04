$(document).on("ajax:success", "#bright_cove_api", function(e) {
    var result = e.detail[0]
    $('.result').html(`<div class="alert alert-secondary" style="word-wrap: break-word;"> <pre>${JSON.stringify(result, null, "\t")}</pre></div>`)
    if (result['format'] == 'single') {
        var data = []
        result.items.forEach(r => {
            var view = r.items.map(i => { return i['video_view'] })
            data.push({ name: `video: ${r.video}` , data: view })
            // console.log(view)
        })
        chart2('single', result.date, data)
    } else {
        all(result)
    }
});
$(document).on("ajax:error", "#bright_cove_api", function(e) {
    $('.result').html(`<div class="alert alert-danger" style="word-wrap: break-word;">エラー</div>`)
});

function all (result) {
    var data = result.items.map((item) => {
        return item['video_view']
    })
    var cat = result.items.map((item) => {
        return item['date']
    })
    chart('total_video_view',cat,data)
}

function chart (title, cat, data) {
    var myChart = Highcharts.chart('container', {
        yAxis: {
            title:{
                text: 'views',
            }
        },
        xAxis: {
            categories: cat,
        },
        plotOptions: {
            series: {
                allowPointSelect: true
            },
        },
        series: [{
            name: title,
            data: data,
        }],
        title: {
            text: title,
        }
    });
}

function chart2 (title, cat, data) {
    var myChart = Highcharts.chart('container', {
        yAxis: {
            title:{
                text: 'views',
            }
        },
        xAxis: {
            categories: cat,
        },
        plotOptions: {
            series: {
                allowPointSelect: true
            },
        },
        series: data,
        title: {
            text: title,
        }
    });
}