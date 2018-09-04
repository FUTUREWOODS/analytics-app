require 'json'

class HomesController < ApplicationController
  # "/v1/data?accounts=#{account_id}&dimensions=#{dimensions}&fields=#{fields}&sort=-video_view#{'&sort=date&limit=all' if params[:dimensions].first == 'date'}"
  def new
  end

  def create
    body = BrightCove.new(set_params)
    case params[:format]
    when 'all'
      body = JSON.parse(body.all_view)
      body[:format] = 'all'
      render json: body.to_json
    when 'single'
      body = JSON.parse(body.single)
      videos = body['items'].map { |item| item['video'] }
      body = BrightCove.new(set_params)
      results = []

      span = (Date.parse(params[:start_date])..Date.parse(params[:end_date])).to_a
      videos.each do |video|
        items = JSON.parse(body.video(video))['items'].map {|item| item.symbolize_keys}
        date = items.map {|item| item[:date]}
        span.each do |d|
          items << { "date": d.to_s, "video_view": 0, "video": video } unless date.include?(d.to_s)
        end
        items.sort_by! {|item| item[:date] }
        results << { video: video, items: items }
      end


      render json: { date: span, items: results, format: 'single' }.to_json
    end
  end

  private

  def set_params(where = "")
    {
        account_id: params[:account_id],
        client_id: params[:client_id],
        client_secret: params[:client_secret],
        site: params[:site],
        dimensions: params[:dimensions],
        fields: params[:fields],
        format: params[:format],
        where: where,
        start_date: params[:start_date],
        end_date: params[:end_date]
    }
  end

  def set_items(id, items)
    {
        video_id: id,
        items: items.map { |item| item.except!('video') }
    }
  end
end
