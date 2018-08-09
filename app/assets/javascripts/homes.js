$(document).on("ajax:success", "#bright_cove_api", function(e) {
  var result = e.detail[0]
  $('.result').html(`<div class="alert alert-secondary" style="word-wrap: break-word;"> <pre>${JSON.stringify(result, null, "\t")}</pre></div>`)
  chart(result.items[0])
});
$(document).on("ajax:error", "#bright_cove_api", function(e) {
    $('.result').html(`<div class="alert alert-danger" style="word-wrap: break-word;">エラー</div>`)
});

function chart(ary) {
    var ctx = document.getElementById("myChart").getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ["video_engagement_1", "video_engagement_25", "video_engagement_50", "video_engagement_75", "video_engagement_100"],
            datasets: [{
                label: '# of Votes',
                data: [ary['video_engagement_1'], ary['video_engagement_25'], ary['video_engagement_50'], ary['video_engagement_75'], ary['video_engagement_100']],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255,99,132,1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero:true
                    }
                }]
            }
        }
    });
}